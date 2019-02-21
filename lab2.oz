%%%% CSci 117, Lab 2 %%%%

% Answer written questions within block comments, i.e. /* */
% Answer program related questions with executable code (executable from within the Mozart UI) 

% Note: While many of these questions are based on questions from the book, there are some
% differences; namely, extensions and clarifications. 


% 1. Write a more effecient version of the function Comb from section 1.3
%% (a) use the definition   n choose r = n x (n-1) x ... x (n-r+1) / r x (r-1) x ... x 1
%% calculate the numerator and denominator separately, then divide the results
%% note: the solution is 1 when r = 0

declare
fun {Fact R}
   if R==0 then 1 else R*{Fact R-1} end
end
		    
declare
fun {Helper N X}
   if X==0 then 1 else N*{Helper (N-1) (x-1)} end
end

declare
fun {Comb2 N R}
   if R==0 then 1

      else {Helper N (N-(N-R+1))} div {Fact R} end
end

%% (b) use the identity   n choose r = n choose (n-r) to further increase effeciency 
%% So, if r > n/2 then do the calculation with n-r instead of r

% Program Code


% 2. Based on the example of a correctness proof from section 1.6, write a correctness
% proof for the function Pascal from section 1.5. 

% Example correctness proof for Fact from section 1.6
/* 
  Proof of correctness for Fact N by induction on N:
    Base case (N = 0), {Fact 0} retruns the correct answer, namely 1

    Inductive Hypothesis: {Fact K-1} is correct
    Inductive case (N=K): the 'if' instruction takes the 'else' case, adn calclulates
      K*{Fact K-1}. By the IH, {Fact K-1} is correct. Therefore, {Fact N} also returns 
      the correct solution.
*/
 
%% (a) Write the correctness proof for the function Pascal from section 1.5, assuming 
%% both the ShiftLeft and ShiftRight functions are correct.

/*
 	Your Proof
*/

% 3. Write a lazy function (section 1.8) that generates the list 
%        N | N-1 | N-2 | ... | 1 | 2 | 3 | ...    where N is a positive number
% Hint: you cannot do this with only one argument

declare
fun lazy{IntList N R}
    if N == 0 then R|{IntList N (R+1)}
    else N|{IntList (N-1) R} 
    end
end


% 4. Write a procedure (proc) that displays ({Browse}) the first N elements of a List
% and run this procedure on the list created in Q3

local
   proc{Disp N List}
      if N\=0 then
     case List of H|T then {Browse H} {Disp (N-1) T} end     
      end
   end
in {Disp 10 L}
end

/*
    Browser Input and Output
*/


% 5. Using the function Pascal from section 1.9, explore the possibilities of higher-order
% programmig by using the following functions as input: multiplication, subtraction, XOR,
% adjusted multiplication: Adjmult X Y = (X+1)*(Y+1), and an operation of your own.
% Display the first 5 rows using   for I in 1..10 do {Browse {GenericPascal Op I}} end
% where Op is the operation you have defined, e.g. multiplication.

% Program Code (for your own operation)

/*
    Describe the Browser output for the 5 operations, and give some insight as to why they
    outputed the values they did.
*/


% 6. local X in 				local X in
%       X=23						  X={NewCell 23}
%       local X in 				  X:=44
%          X=44					  {Browse @X}
%       end						end
%        {Browse X}				
%       end
% What does Browse display in each fragment? Explain.

/*
    one is bounded to a cell, and the cell can be changed. Other one is bounded to a value
*/


% 7. Define functions {Accumulate N} and {Unaccumulate N} such that the output of 
% {Browse {Accumulate 5}} {Browse {Accumulate 100}} {Browse {Unaccumulate 45}}
% is 5, 105, and 60. This will be implemeted using memory cells (section 1.12).

% Program Code

declare
C={NewCell 0}

fun {Accumulate N}
    C:=@C+N
end

fun {Unaccumulate}
    C:=@C-N
end

% Program Code 















