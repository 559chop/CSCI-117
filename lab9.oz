%%%% CSci 117, Lab 9 %%%%

% Answer written questions within block comments, i.e. /* */
% Answer program related questions with executable code (executable from within the Mozart UI) 

% Note: While many of these questions are based on questions from the book, there are some
% differences; namely, extensions and clarifications. 

/* Question 1: Rewrite the function SumList, and the function ScanL, 
where the state is stored in a memory cell when the function is called, 
and a helper function performs the recursive algorithm. */

declare
fun {SumList L}
  A = {NewCell 0}
  fun {SumListH L}
    case L
    of nil then @A
    [] X|Xr then A:= @A + X {SumListH Xr} end
  end
in
  {SumListH L}
end

/* ScanL will be handled similarly, 
except the initial value of your memory cell A will be the Z value passed into the function */

declare
fun {ScanL L F Z} 
  A = {NewCell Z}
   fun {ScanLA L}
      local C in
	 C = @A
	 case L of nil then C|nil
	 [] X|Xr then
	    A:= {F C X}
	    C| {ScanLA Xr}
	 end
      end
   end
in
  {ScanLA L}
end

/* Question 2: Assuming a memory cell A points to a list of integers, 
write a procedure that sums this list and assigns the sum to A. 
You are only allowed to use a single memory cell in your procedure. */

declare
A = {NewCell [0 2 4 6 1 3]}
proc {SumL A}
  B = {NewCell @A#0} 
  proc {SumLA}
     if @B.1==nil then skip
     else
	    B:= @B.1.2#@B.1.1+@B.2
	    {SumLA}
     end
  end
in
   {SumLA} 
   A := @B.2
end

{SumL A}
{Browse @A} 



/* Question 3: Assuming a memory cell A points to a list of integers, 
write a procedure that reverses this list and assigns the reversed list to A. 
You are only allowed to use a single memory cell in your procedure. 
This will be handled similarly to Question 2, except your initialization of B will be different. */


declare
A = {NewCell [0 2 4 6 1 3]}
proc {RevL A}
  B = {NewCell @A#nil} 
  proc {RevLA}
     if @B.1==nil then skip
     else
	B:= (@B.1.2)#(@B.1.1|@B.2)
	{RevLA}
     end
  end
in
   {RevLA} 
   A := @B.2
end

{RevL A}
{Browse @A} 


/* Question 4: Rewrite the functional stream that generates the numbers
starting form 0 then adding one up to infinity, (0 1 2 3 …), 
but instead use a local memory cell, such that {Generate} will return a zero argument function, 
and executing that zero argument function gives the next value in the stream. */
declare
fun {Generate}
   local A = {NewCell 0} in
      fun {$} A:=@A+1 end
   end
end

% For example,
GenF = {Generate}
{Browse {GenF}} % outputs 0
{Browse {GenF}} % outputs 1
{Browse {GenF}} % outputs 2



/* Question 5: Return to Nested List Flattening. */
/* (a) Use a memory cell to count the number of list creation operations i.e. when ‘|’ is used, 
within the two versions of flattening a nested list from lab 5. */						       
%1
local A = {NewCell 0}
   fun {Append Xs Ys}
      case Xs of nil then Ys
      [] X|Xr then
	 A:=@A+1
	 X|{Append Xr Ys}
      end
   end
   
   fun {Flatten Xs} 
      case Xs of nil then nil
      [] X|Xr andthen {IsList X} then
	 {Append {Flatten X} {Flatten Xr}} 
      [] X|Xr then
	 A:=@A+1
	 X|{Flatten Xr}
      end 
   end
in
   {Browse {Flatten [[1 2 3] [1 2] [1 2 [2 3 4]] 3 4]}} 
   {Browse @A}
end

%2
local A = {NewCell 0} 
   fun {Flatten Xs}
      proc {FlattenD Xs ?Ds}
	 case Xs of nil then Y in Ds=Y#Y
	 [] X|Xr andthen {IsList X} then Y1 Y2 Y4 in
	    Ds=Y1#Y4 
	    {FlattenD X Y1#Y2}
	    {FlattenD Xr Y2#Y4}
	 [] X|Xr then Y1 Y2 in
	    A:=@A+1
	    Ds=(X|Y1)#Y2 {FlattenD Xr Y1#Y2}
	 end 
      end
      Ys
   in
      {FlattenD Xs Ys#nil}
      Ys
   end
in
   {Browse {Flatten [[1 2 4 5 6] [2 3 5 [6 7 8 4 [3 4 5] 5 6]] 3 4]}}
   {Browse @A}
end



/* (b) Verify that your program is correct by running the example [[1 2 3] [1 2] [1 2 [2 3 4]] 3 4] from lab 5, 
along with three other examples of your choosing. */
/*
Example 0:  [[1 2 3] [1 2] [1 2 [2 3 4]] 3 4]
Flatten 1: 25
Flatten 2: 12

Example 1:[[1 2 4 5 6] [2 3 5 [6 7 8 4 [3 4 5] 5 6]] 3 4]
Flatten 1: 48
Flatten 2: 19
	   
Example 2: [1 2 [3 5 6] [3 4 5 6 7 [9 4 3 [2 3 4 [5 6 7]]]]]
Flatten 1: 54
Flatten 2: 19	   

Example 3: [2 5 2 9 6 [3 4] [[[[[5]]]]]]
Flatten 1: 15
Flatten 2: 8
*/
/* (c) Create a function that takes in a list of nested lists, 
and returns the average for both flatting function of list creation operations for these nested lists. 
Test this on the list containing all possible nested lists of 3 elements with nesting depth 2,
 i.e., [[1 2 3]  [[1] 2 3]  [[1] [2] 3] … and give the average for both of the flattening functions. */

%[[1 2 3]  [[1] 2 3]  [1 [2] 3] [1 2 [3]] [[1] 2 [3]] [[1] [2] 3] [1 [2] [3]] [[1] [2] [3]] [[1 2] 3] [1 [2 3]] [[1 2 3]]]
local
   All = {NewCell 0}
   Count = {NewCell 0}
   X = [[1 2 3] [[1] 2 3] [1 [2] 3] [1 2 [3]] [[1] 2 [3]] [[1] [2] 3] [1 [2] [3]] [[1] [2] [3]] [[1 2] 3] [1 [2 3]] [[1 2 3]]]
   
   fun {Append Xs Ys}
      case Xs of nil then Ys
      [] X|Xr then
	 All:=@All+1
	 X|{Append Xr Ys}
      end
   end

   fun {Flatten Xs} 
      case Xs of nil then nil
      [] X|Xr andthen {IsList X} then
	 {Append {Flatten X} {Flatten Xr}} 
      [] X|Xr then
	 All:=@All+1
	 X|{Flatten Xr}
      end 
   end
   
   fun{FindAverage Xs}
      case Xs of nil then {Int.toFloat @All}/{Int.toFloat @Count}
      [] X|Xr then D in
	 Count:=@Count+1
	 D = {Flatten X}
	 {FindAverage Xr}
      end
   end
in
   {Browse {FindAverage X}}
end


local
   All = {NewCell 0}
   Count = {NewCell 0}
   X = [[1 2 3] [[1] 2 3] [1 [2] 3] [1 2 [3]] [[1] 2 [3]] [[1] [2] 3] [1 [2] [3]] [[1] [2] [3]] [[1 2] 3] [1 [2 3]] [[1 2 3]]]
   
   fun {Flatten Xs}
      proc {FlattenD Xs ?Ds}
	 case Xs of nil then Y in Ds=Y#Y
	 [] X|Xr andthen {IsList X} then Y1 Y2 Y4 in
	    Ds=Y1#Y4 
	    {FlattenD X Y1#Y2}
	    {FlattenD Xr Y2#Y4}
	 [] X|Xr then Y1 Y2 in
	    All:=@All+1
	    Ds=(X|Y1)#Y2 {FlattenD Xr Y1#Y2}
	 end 
      end
      Ys
   in
      {FlattenD Xs Ys#nil}
      Ys
   end

   fun{FindAverage Xs}
      case Xs of nil then {Int.toFloat @All}/{Int.toFloat @Count}
      [] X|Xr then D in
	 Count:=@Count+1
	 D = {Flatten X}
	 {FindAverage Xr}
      end
   end
in
   {Browse {FindAverage X}}
end




