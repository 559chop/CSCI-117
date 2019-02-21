%%%% CSci 117, Lab 8 %%%%

% Answer written questions within block comments, i.e. /* */
% Answer program related questions with executable code (executable from within the Mozart UI) 

% Note: While many of these questions are based on questions from the book, there are some
% differences; namely, extensions and clarifications. 

% Part 1: Conceptual

% Q1 Laziness and concurrency
% This exercise looks closer at the concurrent behavior of lazy execution. Execute the following:

fun lazy {MakeX} {Browse x} {Delay 3000} 1 end
fun lazy {MakeY} {Browse y} {Delay 6000} 2 end
fun lazy {MakeZ} {Browse z} {Delay 9000} 3 end
X={MakeX}
Y={MakeY}
Z={MakeZ}
{Browse (X+Y)+Z}
  
% This displays x and y immediately, z after 6 seconds, and the result 6 after 15 seconds. 
% Explain this behavior. What happens if (X+Y)+Z is replaced by X+(Y+Z) or by thread X+Y end + Z? 
% X and Y run at the same time and then afterward Z will run. So, the total time would be 15 seconds.
% For X+(Y+Z), Y and Z would run at the same time and then afterward X will run. So, the total time would be 12 seconds.

% Which form gives the final result the quickest?
% The quickest form would be (X+Y+Z) because X, Y and Z would run at the same time. So, the total time would be 9 seconds.

% How would you program the addition of n integers i1, ..., in, given that integer ij only 
% appears after tj milliseconds, so that the final result appears the quickest?
% The quickest result would be (i1, ..., iN).

% Q2 Laziness and monolithic functions. 
% Consider the following two definitions of lazy list reversal:

declare
fun lazy {Reverse1 S} 
  fun {Rev S R}
    case S of nil then R
    [] X|S2 then {Rev S2 X|R} end 
    end
in {Rev S nil} end 

declare
fun lazy {Reverse2 S} 
  fun lazy {Rev S R}
    case S of nil then R
    [] X|S2 then {Rev S2 X|R} end 
  end
in {Rev S nil} end

% What is the difference in behavior between {Reverse1 [a b c]} and {Reverse2 [a b c]}?
% There is no difference between both Reverse.  

% Do the two definitions calculate the same result? Do they have the same lazy behavior? Explain your answer in each case. 
/*
Both will calculate the same result. Despite Reverse2 have the nested lazy, it and Reverse 1 will do the same behavior because
both need a value to become lazy and since getting the value is at the end of the list, both Reverse will recursion
until at the end, which return the value. 
*/

% Finally, compare the execution efficiency of the two definitions. Which definition would you use in a lazy program?
% (Generate a very long list e.g. size 10000 and run both reverse fucntions on the two lists, timing with your phone)
/*
Reverse1 take about 51 seconds to do a list of 500
Reverse2 take about 52 seconds to do a list of 500
I would take Reverse1 because both Reverse1 and Reverse2 does the same thing but Reverse2 have a nested lazy which is redundant. 
*/

% Q3 Concurrency and exceptions. 
% Consider the following control abstraction that implements try–finally:

proc {TryFinally S1 S2} 
  B Y in
    try {S1} B=false catch X then B=true Y=X end 
    {S2}
    if B then raise Y end end
end

% Using the abstract machine semantics as a guide, determine the different possible results of the following program:

local U=1 V=2 in 
  {TryFinally
   proc {$} 
    thread
      {TryFinally proc {$} U=V end
                  proc {$} {Browse bing} end}
    end 
   end
   proc {$} {Browse bong} end} 
end

% How many different results are possible? 
/*
There are 4 results that are possible:
Bing Bong Bing Bing Bong Bong Bong Bing
*/
								 
% How is it that the program is able to output both "Bing Bong" or "Bong Bing" depending on the order of statement executions?
% It's possible for the program to output both "Bing Bong" and "Bong Bing" because the final clause always executed.

% Part 2: A new way to write streams

% Q1 Programmed triggers using higher-order programming. Programmed triggers can be implemented by using higher-order programming 
% instead of concurrency and dataflow variables. The producer passes a zero-argument function F to the consumer. 
% Whenever the consumer needs an element, it calls the function. This returns a pair X#F2 where X is the next stream element 
% and F2 is a function that has the same behavior as F. 
% A key concept for this question is how to return 0 argument functions. For example, the functin that returns the value 3
% can be written as   F = fun {$} 3 end   such that {F} will return the value 3. 

% (a) write a generator for the numbers 0 1 2 3 ..., where the generator returns a pair V#F, V being the next value in the 
% stream and F being the function that returns the next V1#F1 pair. 
% exmaple with generator G1...    {G1} -> 0#G2      {G2} -> 1#G3     {G3} -> 2#G4

declare
fun {Generate N}
  fun {$} N#{Generate N+1} 
  end
end


% (b) write a function that displays the first N values from the stream in part a

fun {FirstValue X N}
   if (N == 0) then {X}.1|nil
   else {X}.1 | {FirstValue {X}.2 N-1}
   end
end



% (c) write a function that takes the stream from a as input, and returns a stream with the numbers multiplied by some number N
%     e.g. N = 3 ... the stream would be 0 3 6 9 ...

fun {Mult X N}
  fun {$} N*{X}.1#{Mult {X}.2 N}
  end
end



% (d) write a function that takes a stream as input, and adds the number N to the front of the stream.
%  e.g. the stream 1 2 3 4 ... with N = 5 would return 5 1 2 3 4 ...

fun {FrontStream X N}
   fun {$} N#{FrontStream {X}.2 {X}.1} end
end


  

% (e) write a function that merges two streams into a single stream, where the output is the zip of the two streams
%    e.g.   S1 = 1 2 3 4 ...   S2 = a b c d ..    output = 1 a 2 b 3 c ...
% 3 variables xs ys and bool or something to keep track

fun {MergeStream X Y true}
  if (B)
    fun {$} {X}.1#{MergeStream {X}.2 Y false} end
  else
    fun {$} {Y}.1#{MergeStream X {Y}.2 true} end
  end
end




% Q2 Hamming Problem
% Convert the solution of the hamming problem for primes 2,3,5 given in the book section 4.5.6 from an implementation using 
% lazy generators, to an implementation using the generators described in part two that produce value function pairs. 
% Note that you will still be needing data flow variables.
% Hint  -> Merge will take in generators, and return a generator (function that returns a value function pair)
% Hint  -> H will be a generator, where the first call {H} will return the pair 1#(some function)




fun lazy {LFilter Xs F}
   case Xs
   of nil then nil
   [] X|Xr then if {F X} then X|{LFilter Xr F} else {LFilter Xr F} end
   end
end
fun lazy {Generate N}
   N|{Generate N+1}
end
fun {Sieve Xs N}
   if N == 0 then nil
   else
      case Xs of X|Xr then Ys in
     Ys = {LFilter Xr fun {$ Y} Y mod X \= 0 end} 
     X|{Sieve Ys N-1}
      end
   end
end
fun {GetPrimes N}
   {Sieve {Generate 2} N}
end

declare
proc {Touch N H}
   if N>0 then {Touch N-1 H.2} else skip end
end
fun lazy {Times N H}
   case H of X|H2 then N*X|{Times N H2} else nil end
end
fun lazy {Merge Xs Ys}
   case Xs#Ys of (X|Xr)#(Y|Yr) then
      if X<Y then X|{Merge Xr Ys}
      elseif X>Y then Y|{Merge Xs Yr}
      else X|{Merge Xr Yr}
      end
   end
end
fun {MergeN Hs}
   case Hs
   of H1|H2|nil then {Merge H1 H2}
   [] H|Hr then {Merge H {MergeN Hr}}
   end
end


declare
fun {Hamming N K}
   Primes = {GetPrimes K}
   H = 1|{MergeN {Map Primes fun{$ Prime} {Times Prime H} end}}
in
   {Touch N H}
   H
end

{Browse {Hamming 30 3}}

