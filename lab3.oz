%%%% CSci 117, Lab 3 %%%%

% 1. If a function body has an 'if' statement with a missing 'else' clause, then an exception
%    is raised if the 'if' condition is false. Explain why this behavior is correct. This 
%    situation does not occur for procedures. Explain why not.

/*
    function return values and procedures doesn't have to return values
*/


% 2. Using the following:
%    (1) - if X then S1 else S2 end
%    (2) - case X of Lab(F1: X1 ... Fn: Xn) then S1 else S2 end
% (a) Define (1) in terms of the 'case' statement. 
/*
    case X of true then S1 else S2 end
*/

% (b) Define (2) in terms of the 'if' statement, using the operations
%     Label, Arity, and '.' (feature selection). 
%     Note - Don't forget to make assignment before S1. You should use ... when ranging from F1 to Fn.
/*
if {Label X} = Lab then
   if{Arity X} == {F1...Fn} then
       local X1...Xn
       	     X1=X.F1
	     X2=X.F2
		.
		.
	     Xn=X.Fn
	     S1 
    else S2 end
else S2 end

*/

% (c) Rewrite the following 'case' statement using 'if' statements

declare L
L = lab(f1:5 f2:7 f3:'jim')

case L of lab(f1:X f2:Y f3:Z) then
   case L.f1 of 5 then
      {Browse Y}
   else
      {Browse a}
   end
else
   {Browse b}
end

% Program Code

if {Label L} == lab then
   if {Arity L} == [f1 f2 f3] then
      local X Y Z in
	 X = L.f1
	 Y = L.f2
	 Z = L.f3
      if L.f1 == 5 then
      	 {Browse Y}
      else
         {Browse a} end
      end
   else
      {Browse b} end
else
   {Browse b}
end



% 3. Given the following procedure:

declare
proc {Test X} 
  case X
  of a|Z then {Browse  'case (1)'}
  [] f(a) then {Browse  'case (2)'}
  [] Y|Z andthen Y==Z then {Browse  'case (3)'} 
  [] Y|Z then {Browse  'case (4)'}
  [] f(Y) then {Browse  'case (5)'}
  else {Browse  'case (6)'} end
end

% Without em{Test [b c a]}, {Test f(b(3))}, {Test f(a)}, {Test f(a(3))}, {Test f(d)}, {Test [a b c]},
% {Test [c a b]}, {Test a|a}, and {Test  ́| ́(a b c)}
% Run the code to verify your predictions.
/*
    case 4
    case 5
    case 2
    case 5
    case 5
    case 1
*/


% 4. Given the following procedure:

declare
proc {Test X}
  case X of f(a Y c) then {Browse 'case (1)'} 
  else {Browse  'case (2)'} end
end

% (a) Without executing any code, predict what will happen when you feed
% declare X Y {Test f(X b Y)}
% declare X Y {Test f(a Y d)}
% declare X Y {Test f(X Y d)}
% Run the code to verify your predictions.
/*
    case 2
    case 1
    case 2
*/

% (b) Run the following example:

declare X Y
if f(X Y d)==f(a Y c) then {Browse 'case (1)'} 
else {Browse 'case (2)'} end

% Is the result different from the previous example? Explain.
% Run the code to verify your predictions. 
/*
    case 2
    case 2
    case 2
*/

the second one works because Y is unbounded and c = d

% 5. Given the following code:

declare Max3 Max5
  proc {SpecialMax Value ?SMax}
    fun {SMax X}
      if X>Value then X else Value end
  end 
end
{SpecialMax 3 Max3} 
{SpecialMax 5 Max5}

% Without executing any code, predict what will happen when you feed
% {Browse [{Max3 4} {Max5 4}]}
% Run the code to verify your predictions.
/*
    [4 5] it takes the max of each one
*/


% 6. Expand the following function SMerge into the kernel syntax.
% Note - X#Y is a tuple of two arguments that can be written '#'(X Y). 
%        The resulting procedure should be tail recursive if the rules from
%        section 2.5.2 are followed correctly. (PG.87)

declare
fun {SMerge Xs Ys} 
  case Xs#Ys
  of nil#Ys then Ys
  [] Xs#nil then Xs
  [] (X|Xr)#(Y|Yr) then
    if X=<Y then 
      X|{SMerge Xr Ys}
    else
      Y|{SMerge Xs Yr}
    end 
  end
end

% e.g.
{Browse {SMerge [1 2 3] [1 2 3]}}

% Program Code

declare
proc {SMerge Xs Ys ?Z}
   local X Res in
      local Y in
	local Xr in
	   local Yr in
	      case Xs of nil then Z = Ys
	      else
		 case Ys of nil then Z = Xs
		 else
		    case Xs of X|Xr then
			case Ys of Y|Yr then
			  local Comp in
			     Comp = X=<Y
			     if Comp then
				Z = X|Res
				{SMerge Xr Ys Res}
			     else
				Z=Y|Res
				{SMerge Xs Yr Res}
			     end
			  end
			else
			  Z = Y|Res
			  {SMerge Xs Yr Res} end
		    else
			Z = Y|Res
			{SMerge Xs Yr Res} end
		 end
	      end
	   end
	end
      end
   end
end





