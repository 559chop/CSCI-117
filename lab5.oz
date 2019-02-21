%%%% CSci 117, Lab 5 %%%%

% Answer written questions within block comments, i.e. /* */
% Answer program related questions with executable code (executable from within the Mozart UI) 

% Note: While many of these questions are based on questions from the book, there are some
% differences; namely, extensions and clarifications. 

% Part 1 (Invariants and Proofs)
% For this section, you will state the invariant, and write an inductive proof (base case and inductive case
% similar to the Fact example from class)

% (a)
local
  fun {IterLength I Ys}
    case Ys
    of nil then I
    [] _|Yr then {IterLength I+1 Yr} end
    end
  in
    fun {Length Xs}
      {IterLength 0 Xs}
    end 
  end




% (b)
local
  fun {IterReverse Rs Ys}
    case Ys
    of nil then Rs
    [] Y|Yr then {IterReverse Y|Rs Yr} end
    end 
  in
    fun {Reverse Xs} 
      {IterReverse nil Xs}
    end 
  end




% (c) - write an iterative version of SumList, then find the invariant and create an inductive proof

%******* Non-iterative version of SumList ************
fun {SumList L} 
  case L
  of nil then 0
  [] X|L1 then X+{SumList L1} 
  end
end
%******* Non-iterative version of SumList ************




% (d)

fun {Merge Xs Ys} 
  case Xs # Ys
  of nil # Ys then Ys
  [] Xs # nil then Xs
  [] (X|Xr) # (Y|Yr) then
     if X<Y then X|{Merge Xr Ys} 
     else Y|{Merge Xs Yr}
     end
  end
end




fun {MergeSort Xs}
  fun {MergeSortAcc L1 N}
    if N==0 then 
      nil # L1
    elseif N==1 then 
      [L1.1] # L1.2
    elseif N>1 then
      NL=N div 2
      NR=N-NL
      Ys # L2 = {MergeSortAcc L1 NL} 
      Zs # L3 = {MergeSortAcc L2 NR}
    in
      {Merge Ys Zs} # L3
    end 
  end
in
  {MergeSortAcc Xs {Length Xs}}.1
end





% Part 2

% 1. Section 3.4.2 defines the Append function by doing recursion on the first argument. 
%    What happens if we try to do recursion on the second argument? Here is a possible solution:

fun {Append Ls Ms} 
  case Ms
  of nil then Ls
  [] X|Mr then {Append {Append Ls [X]} Mr} 
  end
end

% Is this program correct? Does it terminate? Why or why not?




% 2. This exercise explores the expressive power of dataflow variables. 
%    In the declarative model, the following definition of append is iterative:

fun {Append Xs Ys} 
  case Xs
  of nil then Ys
  [] X|Xr then X|{Append Xr Ys} 
  end
end

% We can see this by looking at the expansion:

proc {Append Xs Ys ?Zs} 
  case Xs
  of nil then Zs=Ys 
  [] X|Xr then Zr in
    Zs=X|Zr
    {Append Xr Ys Zr}
  end 
end

% This can do a last call optimization because the unbound variable Zr can be put in the list 
% Zs and bound later. Now let us restrict the computation model to calculate with values only. 
% How can we write an iterative append? One approach is to define two functions: (1) an 
% iterative list reversal and (2) an iterative function that appends the reverse of a list to 
% another. Write an iterative append using this approach.

% Note - by values only, we mean that every identifier must be bound to a value upon declaration




% 3. Calculate the number of operations needed by the two versions of the Flatten function given 
%    in Section 3.4.4. With n elements and maximal nesting depth k, what is the worst-case complexity 
%    of each version? 
%    Note - Assume IsList uses constant time to check if an input is a list and the append in the 
%           first function works in O(n) time

%  First, run the functions on the example [[1 2 3] [1 2] [1 2 [2 3 4]] 3 4] and give the exact number
%  of operations for execution.

fun {Flatten Xs} 
  case Xs
  of nil then nil
  [] X|Xr andthen {IsList X} then
    {Append {Flatten X} {Flatten Xr}} 
  [] X|Xr then
    X|{Flatten Xr}
  end 
end


fun {Flatten Xs}
  proc {FlattenD Xs ?Ds}
    case Xs
    of nil then Y in Ds=Y#Y
    [] X|Xr andthen {IsList X} then Y1 Y2 Y4 in
      Ds=Y1#Y4 
      {FlattenD X Y1#Y2}
      {FlattenD Xr Y2#Y4}
    [] X|Xr then Y1 Y2 in
      Ds=(X|Y1)#Y2 {FlattenD Xr Y1#y2}
    end 
  end Ys
  in {FlattenD Xs Ys#nil} Ys
end





% 4. The following is a possible algorithm for sorting lists. Its inventor, C.A.R. Hoare, called it 
%    quicksort, because it was the fastest known general-purpose sorting algorithm at the time it 
%    was invented. It uses a divide and conquer strategy to give an average time complexity of O(n log n).
%    Here is an informal description of the algorithm for the declarative model. Given an input list L. 
%    Then do the following operations:
%      (a) Pick L’s first element, X, to use as a pivot.
%      (b) Partition L into two lists, L1 and L2, such that all elements in L1 are less than X and 
%          all elements in L2 are greater or equal than X.
%      (c) Use quicksort to sort L1 giving S1 and to sort L2 giving S2.
%      (d) Append the lists S1 and S2 to get the answer.
%    Write this program with difference lists to avoid the linear cost of append.







