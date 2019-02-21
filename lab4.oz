%%%% CSci 117, Lab 4 %%%%

% 1. Section 2.4 explains how a procedure call is executed. Consider the following procedure MulByN:

declare MulByN N in 
N=3
proc {MulByN X ?Y}
    Y=N*X
end

% together with the call {MulByN A B}. Assume that the environment at the call contains {A → 10, B → x1}. When the procedure body is executed, the mapping N → 3 is added to the environment. Why is this a necessary step?

%In particular, would not N → 3 already exist somewhere in the environment at the call? Would not this be enough to  
% ensure that the identifier N already maps to 3? Give an example where N does not exist in the environment at the 
% call. Then give a second example where N does exist there, but is bound to a different value than 3.

/*
    -Defining N when the function is defined is neccessary because when we push it to the store it will have the statement and the environment so N will always be defined

    -the N is only matter when it is declared within the local variable within that scope.

local MulByN in
 local N in 
N=3
proc {MulByN X ?Y}
    Y=N*X
end 
{MulByn X Y}
end

- The N would not be defined in this scope because the N scope stopped at the first end before the munction call.
 this doesnt matter that N is not defined in the scope that the function is called because it was defined in the
 environment that the function was defined in. 
 The store will have {<s1><e>} so it will still have N defined.

local MulByN in
 local N in 
N=3
proc {MulByN X ?Y}
    Y=N*X
end 
end

local N in
N = 30
{MulByn X Y}
end
*/

- in this example, N exists as 30 but it doesn't matter because the proc will still use the local variable N=3.


% 2. This exercise examines the importance of tail recursion, in the light of the semantics given in the chapter.
% Consider the following two functions:

fun {Sum1 N}
  if N==0 then 0 else N+{Sum1 N-1} end
end

fun {Sum2 N S}
  if N==0 then S else {Sum2 N-1 N+S} end
end

% (a) Expand the two definitions into kernel syntax. It should be clear that Sum2 is tail recursive and Sum1 is not.

% Program Code

Sum1 = proc {$ N M}
local Z B A C N1 in
      Z = 0
      {'==' N Z B}
      if B then M = 0
      else
	A=1
	{'-' N A C}
	{Sum1 C N1}
	{'+' N N1 N2}
	M = N2
      end
end


Sum 2 = proc{$ N S M}
local Z B A in
      Z = 0
      {'==' N Z B}
      if B then M = S
      else
	A = 1
	{'-' N A C}
	{'+' N S S1}
	{Sum2 C S1 P}
	M = P
      end
end


% (b) Execute the two calls {Sum1 3} and {Sum2 3 0} by hand, using the semantics of this chapter to follow what 
%  happens to the stack and the store. 
%  Specifically, for the first iteration through the procedure definition, show the affect of each statement on the
%  stack, environemnt, and store similar to Dr. Wilson's Piazza post @85. Iteration two and three will be similar
%  so only show the environemnt, store, and stack right before the recursive call. Then, for iteration 4 (Base Case)
%  go through each statement, and finish popping statements off of the stack from the previous procedure calls.

/*
    Your answer
*/

% (c) What would happen in the Mozart system if you would call {Sum1 100000000} or {Sum2 100000000 0}? Which one 
% is likely to work? Which one is not? Try both on Mozart to verify your reasoning.

/*
    Your answer
*/


% 3. Given the following program code:

fun {Eval E}
  if {IsNumber E} then E 
    else
    case E
    of plus(X Y) then {Eval X}+{Eval Y} 
    [] times(X Y) then {Eval X}*{Eval Y} 
    else raise illFormedExpr(E) end
    end
  end 
end

try
  {Browse {Eval plus(plus(5 5) 10)}} 
  {Browse {Eval times(6 11)}} 
  {Browse {Eval minus(7 10)}}
catch illFormedExpr(E) then
  {Browse  ́*** Illegal expression  ́#E# ́ *** ́}
end

% Include the Records divide(X Y), list(L) which returns the list L, and append(H T) which takes an integer and appends it to a list
% such that the function Eval will return either an integer, a list, or an error.
% Change the catch into a pattern matching catch (Page 96) with the following exceptions
%     illFormedExpr(E)   -- same as the already existsing error
%     illFormedList(E)   -- if list(L) is evaluated and L is not a list (using a helper function IsList that you define)
%                             IsList checks if the head of the input is an integer, then recursively checks the rest of 
%                             the list. Base case is nil which returns true. 
%     illFormedAppend(E) -- if append(H T) is passed to Eval and H is not an integer (using the IsNumber function)

% Include another exception for dividing by 0, such that the exception will then execute the division, by changing the 
% denominator to 1, and output the result to the browser. This exception will not be in the pattern matching catch 
% described above, but will be on the outside (You will need a nested try, catch statement to achieve this)

% Program Code


% Describe the process, in terms of the stack, from the moment a division by 0 exception is raised, to the moment the division 
% division is executed with a new denominator. (Ignore Environment and Store)

/*
declare L
L=[1 2 3 5 6]

declare Eval
fun {Eval E}
   if {IsNumber E} then E
   else
      case E
      of plus(X Y) then {Eval X}+{Eval Y} 
      [] times(X Y) then {Eval X}{Eval Y}
      [] divide(X Y) then {Eval X}div{Eval Y}
      [] list(X) then {IsList X}
      [] append(X Y) then {Append X Y}
      else raise illFormedExpr(E)
       end
      end
   end
end

declare IsList
fun {IsList Ls}
   case Ls
   of H|T andthen {IsNumber H} then {IsList T}
   [] nil then true
   else raise illFormedList(Ls)
    end
   end
end

declare Append
fun {Append H T}
   if {IsNumber H} then H|T
   else raise illFormedAppend(H)
    end
   end
end

try
   {Browse {Eval plus(plus(5 5) 10)}} 
   {Browse {Eval times(6 11)}}
   try
      {Browse {Eval divide(10 0)}}
   catch
      error(...) then {Browse {Eval divide(10 1)}}
   end
   {Browse {Eval list(L)}}
   {Browse {Eval append(b L)}}
catch illFormedExpr(E) then
   {Browse  '** Illegal expression  '#E# '  '}
[] illFormedList(E) then
   {Browse ' Illegal list  '#E# '  '}
[] illFormedAppend(E) then
   {Browse ' Illegal append  '#E# ' *** '}
end
*/

% 4. Based on the unification algoirthm on page 103, describe the unification process for the following example
%    Describe the Stack, Environment, and Store as each statement is executed, similar to Q2(b), and show the output store
%    Remark: Describe each step in the unification when it occurs, using the syntax unify(X,Y), bind(ESx,ESy), etc.
%            as shown on page 103

declare X Y A B C D E F G H I J K L M N
L = D 
M = D
N = F
A = birthday(day:3 month:C year:1986)
B = birthday(day:D month:D year:F)
I = J
J = 19
K = D
X = person(age:I name:"Stan" birthday:A)
Y = person(age:G name:H birthday:B)
X = Y

/*
 1. Environment: {X -> x, Y-> y, A -> a, B -> b, C -> c, D -> d, E -> e, F -> f, G -> g, H -> h, I -> i,  J -> j, K -> k, L -> l, M -> m, N -> n}

2. Store: {{x},{y},{a},{b},{c},{d},{e},{f},{g},{h},{i},{j},{k}.{l},{m},{n}}

3. Bind L and D
    Store = {{x}, {y}, {a}, {b}, {c}, {e}, {f}, {g}, {h}, {i}, {j}, {k}, {l, d},{m}, {n}}

4. Bind M and D.
   Store = {{x}, {y}, {a}, {b}, {c}, {e}, {f}, {g}, {h}, {i}, {j}, {k}, {l, d, m}, {n}}

5. Bind N and F 
    store = {{x}, {y}, {a}, {b}, {c}, {e}, {g}, {h}, {i}, {j}, {k}, {l, d, m}, {n, f}}

6. Bind the values to A 
    Store = {{x},{y},{a = x1 = birthday(day: three month: c year: year)},{three = 3},{year = 1986}, {b}, {c}, {e}, {g}, {h}, {i}, {j}, {k}, {l, d, m}, {n, f}} 

7. Bind B to the label.
    Store = {{x},{y},{a = x1 = birthday(day: three month: c year: year)},{three = 3},{year = 1986},{b},{e},{g},{h},{i},{j},{k},{l, d, m, c},{n, f},{b = x2 = birthday(day: d month: d year: f}, {d = 3},{f = 1986}} 
 8 Bind I to J.
    Store = {{x},{y},{a = x1 = birthday(day: three month: c year: year)},{three = 3},{year = 1986},{b},{e},{g},{h},{i,j},{k},{l, d, m, c},{n, f},{b = x2 = birthday(day: d month: d year: f}, {d = 3},{f = 1986}}

9. Bind J to 19.
Store = {{x},{y},{a = x1 = birthday(day: three month: c year: year)},{three = 3},{year = 1986},{b},{e},{g},{h},{j = 19},{i,j},{k},{l, d, m, c},{n, f},{b = x2 = birthday(day: d month: d year: f}, {d = 3},{f = 1986}}

10. Bind K to D
Store = {{x},{y},{a = x1 = birthday(day: three month: c year: year)},{three = 3},{year = 1986},{b},{e},{g},{h},{j = 19},{i,j},{l,d,m,c,k},{n,f},{b = x2 = birthday(day: d month: d year: f}, {d = 3},{f = 1986}}

11. Bind the values to X
Store = {{x = x3 = age: i, name: "stan" birthday: a},{y},{a = x1 = birthday(day: three month: c year: year)},{three = 3},{year = 1986},{b},{e},{g},{h},{j = 19},{i,j},{l,d,m,c,k},{n,f}
{b = x2 = birthday(day: d month: d year: f}, {d = 3},{f = 1986}}

12. Bind Y to the label
Store = {{x = x3 = age: i, name: "stan" birthday: a},{y x4 = age: g name: h birthday: b},{a = x1 = birthday(day: three month: c year: year)},{three = 3},{year = 1986},{b,a},{e},{h = "Stan"},
{j = 19},{i,j,g},{l,d,m,c,k},{n,f},{b = x2 = birthday(day: d month: d year: f}, {d = 3},{f = 1986}}

13. Bind X to Y 
Store = {{x,y},{x = x3 = age: i, name: "stan" birthday: a},{y x4 = age: g name: h birthday: b},{a = x1 = birthday(day: three month: c year: year)},{three = 3},
{year = 1986},{b,a},{e},{h = "Stan"},{j = 19},{i,j,g},{l,d,m,c,k},{n,f},{b = x2 = birthday(day: d month: d year: f}, {d = 3},{f = 1986}} 
*/

