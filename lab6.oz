%%%% CSci 117, Lab 6 %%%%

% Answer written questions within block comments, i.e. /* */
% Answer program related questions with executable code (executable from within the Mozart UI) 

% Note: While many of these questions are based on questions from the book, there are some
% differences; namely, extensions and clarifications. 


% Part 1: Control Flow

% For each question, come up with three operations, and test these operations on lists, displaying the input and output in a comment. 
/*
Q1 Binary Fold
The function BFold L F takes a list of integers L and a binary operation on integers F, and returns the binary fold of the F applied to L, where the binary fold is defined as follows:
• BFold where L contains a single element returns that element
• BFold where L contains two or more elements returns BFold of Bmap L F
  • Bmap applies F to successive pairs of a list as follows:
    • Bmap of a list with two or more elements, e.g. X|Y|Ls returns {F X Y} | {Bmap Ls F}
    • Bmap of a list with a single or no element, returns the list, i.e. Bmap [X] F returns [X] and Bmap nil F returns nil
*/
declare
fun {Sum L D}
   L + D
end

declare
fun {Bmap L F}
    case L
    of nil then nil
    [] [X] then X
    [] X|Y|Ls then {F X Y} | {Bmap Ls F}
    end
end

declare
fun {BFold L F}
    case L
    of nil then nil
    [] [X] then X
    [] X|Y|L2 then {Bmap L F}
    end
end

/*
Q2 Nested Fold
The function NFoldL L FZs takes a nested list L and a list of binary operators, value pairs. If FZs is ordered as   [ F1#ZF1 F2#ZF2 F3#ZF3 ... ], you will use the function Fi at the nested depth i, performing the right associative fold operation, with the second value of each pair being the initial value of the folds. 
e.g.)
{ NFold [ 1 2 [2 3] [1 [2 3] ] ] [ F#ZF G#ZG H#ZH ] }
F 1 (F 2 (F (G 2 (G 3 ZG)) (F (G 1 (G (H 2 (H 3 ZH)) ZG)) ZF)))

You will raise an error if the nesting depth d is greater than the length of FZs (i.e. There are not enough functions in FZs to match each level of nesting in L)
*/

declare Sum Sub Mul
fun {Sum F L}
   F+L
end

fun {Sub G L}
   G-L
end

fun {Mul H L}
   HL
end

declare
fun {NFold L B}
   case B of nil then raise illFormedZlength(L) end
   [] B1#D|B2 then
      case L of nil then D
      [] H|T andthen {IsList H} then
      	 {B1 {NFold H B2} {NFold T B}}
      [] H|T then
      	 {B1 H {NFold T B}}
      end
   end
end

/*
Q3 Scan
The function ScanL L Z F takes a list L, Initial value Z, and a binary function F. This will return a list with successive left folds. With L = [X1 X2 X3 X4 …] we will get the list
[ Z, F Z X1, F ( F Z X1) X2, ….] where the last element of the output is exactly the FoldL of L Z F. 
*/

declare
fun {ScanLA L Z F}
    case L
    of nil then nil
    [] X|Ls then
       {F Z X} | {ScanLA Ls {F Z X} F}
    end
end


declare
fun {ScanL L Z F}
    Z|{ScanLA L Z F}
end

% Part 2: Secure Data Types (pg 210)

/*
Secure Dictionary
Implement the list-based declarative dictionary as an ADT, as in Figure 3.27 on p. 199, but in a secure way, using wrap and unwrap, as outlined in Section 3.7.6 (Page 210). Each dictionary will come with two extra features, a binary function F on integers and an integer Z. Your dictionary will have integers as keys (aka features) and pairs of integer lists and atoms as values. The key for each list-atom pair will be calculated from the list by performing a left-associative fold on the list using F and Z. As a result, the Put function will not take a Key as argument but calculate it from the Value. Make sure the code for Put is updated appropriately.

After creating your dictionary, run several Put, CondGet, and Domain examples, displaying the inputs and outputs in a comment. Answer the following questions:
a) What happens when two distinct lists have the same Key value after the folding operation, based on the definition of Put from the book? Give an example.
b) Describe the NewWrapper function on page 207. How does the wrapper/unwrapper created by this function secure the dictionary?
c) Are the F and Z values associated with the dictionary secure? If not, how could you make these secure as well?
*/

declare
proc {NewWrapper ?Wrap ?Unwrap}
   Key={NewName}
in
   fun{F X Y}
      X+Y
   end
   fun {Fold L F Z}
      case L of nil then Z
      [] X|L1 then {F X {Fold L1 F Z}}
   end
   end
   fun {Wrap X}
      fun {$ K}
     if K==Key then X
     end
      end
   end
   fun {Unwrap W}
      {W Key}
   end
end

local Wrap Unwrap in
   {NewWrapper Wrap Unwrap}
   fun {NewStack} {Wrap nil} end
   fun {Push S E} {Wrap E|{Unwrap S}} end
   fun {Pop S E} case {Unwrap S} of X|S1 then E=X {Wrap S1} end end
   fun {IsEmpty S} {Unwrap S}==nil end
end

local Wrap Unwrap Key
   {NewWrapper Wrap Unwrap}
   fun {NewDictionary2} nil end
   fun {Put2 Ds Ls Value}
      Key={Fold Ls F Z}
      case Ds of nil then [Key#Value]
      [] (K#V)|Dr andthen Key==K then (Key#Value) | Dr
      [] (K#V)|Dr andthen K>Key then (Key#Value)|(K#V)|Dr
      [] (K#V)|Dr andthen K<Key then (K#V)|{Put Dr Key Value}
      end
   end 
   fun {CondGet2 Ds K Default}
      case Ds of nil then Default
      [] (K#V)|Dr andthen Key==K then V
      [] (K#V)|Dr andthen K>Key then Default
      [] (K#V)|Dr andthen K<Key then {CondGet Dr Key Default}
      end
   end
   fun {Domain2 Ds}
      {Map Ds fun {$ K#_} K end}
   end

   fun {NewDictionary} {Wrap {NewDictionary2}} end
   fun {Put Ds K Value} {Wrap {Put2 {Unwrap Ds} K Value}} end
   fun {CondGet Ds K Default} {CondGet2 {Unwrap Ds} K Default} end
   fun {Domain Ds} {Domain2 {Unwrap Ds}} end
end


% Part 3: Declarative Concurrency

/*
Given the following program code:
local A B C in 
  thread   %%%%%%%%%%%%%%%%%%%%%%%%%% A
    A = 5  %%%%%%%%%%%%%%%%%%%%%%%%%% T1
  end
  thread   %%%%%%%%%%%%%%%%%%%%%%%%%% B
    B = 7  %%%%%%%%%%%%%%%%%%%%%%%%%% T2
  end
  thread   %%%%%%%%%%%%%%%%%%%%%%%%%% C
    C = 3  %%%%%%%%%%%%%%%%%%%%%%%%%% T3
  end
  
  if C > A then  %%%%%%%%%%%%%%%%%%%% S1
    {Browse “C is greater than A”} %% S2
  else
    if B > A then  %%%%%%%%%%%%%%%%%% S3
      {Browse “B is greater than A”}% S4
    end
  end
end



What are all the possible interleavings of the statements T1, T2, T3, S1..S4? How about when A = 2?
*/

[A B C T1 T2 T3 S1 S3 S4]

[A B C T1 T2 S3 S4 T3 S1]

[A B C T1 T2 S3 S4 S1 T3]

[A B C T1 T2 S3 S1 S4 T3]

[A B C T1 T2 S1 S3 S4 T3]

[A B C T2 T1 S1 S3 S4 T3]

---

[A B C T2 T1 T3 S1 S3 S4]

[A B C T2 T1 S3 S4 T3 S1]

[A B C T2 T1 S3 S4 S1 T3]

[A B C T2 T1 S3 S1 S4 T3]

[A B C T2 T1 S1 S3 S4 T3]

[A B C T2 T1 S1 S3 S4 T3]

--

[A T1 B T2 C T3 S1 S3 S4]

[A T1 B T2 C S3 S4 T3 S1]

[A T1 B T2 C S3 S4 S1 T3]

[A T1 B T2 C S3 S1 S4 T3]

[A T1 B T2 C S1 S3 S4 T3]

[A T1 B T2 C S1 S3 S4 T3]

--

[A T1 B C T2 T3 S1 S3 S4]

[A T1 B C T2 S3 S4 T3 S1]

[A T1 B C T2 S3 S4 S1 T3]

[A T1 B C T2 S3 S1 S4 T3]

[A T1 B C T2 S1 S3 S4 T3]

[A T1 B C T2 S1 S3 S4 T3]
