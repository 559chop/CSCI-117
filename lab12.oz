%%%%Lab 12%%%%
%%%%Tyler Gillette%%%%
%%%%Due Wed 28%%%%

% Part 1 (4 pts)
% 1. Figure 7.3 on Page 500 defines the Function New, which creates objects from classes, and takes 
% in an initial message. pg. 523

% (a) Write a function New2, which takes a class as input, and creates an object without an initial message.

%%new One
fun {New Class}
    Fs={Map Class.attrs fun {$ X} X#{NewCell _} end} S={List.toRecord state Fs}
    proc {Obj M} 
    {Class.methods.{Label M} M S} 
    end in 
    Obj 
    end 

%%new Two

% (b) Write a function New3, which takes a class as input, and creates an object where the initial 
% message in always the zero-arity record init.
fun {New2 Class}
   ({New3 Class init()}
   end)
end 

%=================================================================================================================================%

% 2. Figure 7.6 on Page 510 defines the class Account, and page 511 defines 
% a subclass LoggedAccount.

fun {StrangeClass}
class A 
meth foo(X) X=a 
end 
end 

class B 
meth foo(X) X=b 
end 
end 

class C 
from A B 
end
in C 
end



    class LoggedAccount from Account 
    meth transfer(Amt) 
    {LogObj addentry(transfer(Amt))} 
            Account,transfer(Amt)
    end end 


class Counter attr val
meth init(Value) val:=Value
end
meth browse
         {Browse @val}
end
meth inc(Value)
         val:=@val+Value
end end

C={New Counter init(0)} 
{C inc(6)} 
{C inc(6)} 
{C browse}

fun {New Class Init}
Fs={Map Class.attrs fun {$ X} X#{NewCell _} end} S={List.toRecord state Fs}
proc {Obj M}
{Class.methods.{Label M} M S}
end in
{Obj Init}
Obj
end

class Account
 attr balance:0 
 meth transfer(Amt) 
        balance:=@balance+Amt
    end
meth getBal(Bal) 
        Bal=@balance
    end
meth batchTransfer(AmtList) 
    for A in AmtList do {self transfer(A)} 
    end 
end 
end 


% (a) The class Counter from Page 498 is redefined on Page 499 without syntactic
%  support. Do the same with the Account.

declare
local
   proc {Transfer M S}
      M=transfer(Amt) in
      (S.balance):=@(S.balance)+Amt
   end

   proc {GetBal M S} 
   M=getBal(Bal) in
      (Bal):=@balance
   end

   proc {BatchTransfer M S}
      M=batchTransfer(AmtList) in
      for A in AmtList do {Transfer transfer(A) S}
      end    
   in
      Account=a(attrs:[balance] methods:m(transfer:Transfer getBal:GetBal batchTransfer:BatchTransfer))
   end
end

% (b) Implement the LogObj used in LoggedAccount, where LogObj is an 
% instance of the class LogTransfer. 
% LogTransfer is a class with a single attribute log, which is a list 
% containing the transfer values in order, 
% and a single method addEntry, which takes transfer(Amt) as input, 
% adds Amt to the end of log, and displays 
% Amt with a Browse statement.


   class LogTransfer
    attr log
    meth addentry(transfer(Value))
        {Browse Value}
        {AppendL log Value}
    end
end

% (c) Test the complete code and run several batchTransfer calls for an 
% instance of Account and an instance of LoggedAccount. 
% What is the behavior of batchTransfer for both objects? Answer this in terms 
% of dynamic versus static binding as described 
% on Page 512.

declare LogObj in
LogObj = {New LogTransfer init}
%=================================================================================================================================%

% 3. Using flexible argument lists with variable reference to method head from 
% Page 505, extend the class Counter from 
% Page 498 in the following way: change the attribute val to a record of counters 
% (memory cells) with feature names from 
% a ... m, i.e,. val(a:(memory cell) b:(memory cell) ... m(memory cell)). 
% Change the method inc, to a method which takes 
% in a flexible argument list that starts at a. i.e. inc(a:A ...)=M. 
% This method should loop through the features of M which 
% correspond to the features of val, and increment the corresponding memory 
% cells with e.g., M.a 
% (the value corresponding to the feature in M).
% Example:
% Count is a Counter object with val(a:0 b:0 ... m:0) {Count inc(a:5 d:10)}
% Count now has val(a:5 b:0 c:0 d:10 ... m:0)

  class Counter 
        attr val 
    meth init(Value) val:=Value 
    end
    meth browse 
            {Browse @val}
    end
    meth inc(Value) 
            val:=@val+Value
    end end 


% declare 
% class Counter
%    attr val:val(a:{NewCell 0} b:{NewCell})
%     meth inc(a:X ...)=M
%         FeatureList = {Arity M}
        %%Helper function to loop through list
        %%could use a map


        %%Need to loop through this 
        %A=FeatureList.1 "a"
        %((@Val).A):= @((@Val).A)+M.A

%     {Obj inc(a:5 b:6)}
% end

class Counter
    attr val(a:{NewCell 0} b:{NewCell 0} ... m:{NewCell 0})
    meth init()
        skip
    end
    meth browse
        {Browse @val}
    end
    meth inc(a:A...) = M
        for Ar in {Arity M} do
            @((@val).Ar) := @((@val).Ar) + Value
    end
end 


%=================================================================================================================================%
% 4. Using the wrapping methods described on Page 522-3 for TraceNew and TraceNew2, 
% write a function that wraps an input object inside the class AttrCount. That is, 
% write a function from objects to object, where AttrCount has the same structure 
% as TraceNew2, but also contains a single attribute count, an additional method 
% browseCount (Browsing the value of count), and modifies the otherwise case to 
% increment the value of count for each time a Message is passed to the wrapped 
% object.

declare
class Counter
   attr val
   meth init(Value)
      val:=Value
   end
   meth browse
      {Browse @val}
   end
   meth inc(Value)
      val:=@val+Value
   end
end

declare
fun {Wrap Obj}
   WrapInit = {NewName}
   class AttrCount
      attr count
      meth !WrapInit skip end
      meth browseCount
     {Browse @count}
      end
      meth otherwise(M)
     @count = @count + 1
     {Obj M}
      end
   end
in {New AttrCount WrapInit} end

declare
Test = {Wrap {New Counter init(0)}}
{Test inc(a:2 b:3)}

%***************************** failure **************************
%**
%** Tell: <O: AttrCount> = test
%**
%** Call Stack:
%** procedure 'Wrap' in file "c:/Users/Nicholas/Desktop/117/labs/lab12.oz", line 154, column 0, PC = 48404520
%**--------------------------------------------------------------
Compile time
%********************** static analysis error *******************
%**
%** applying non-procedure and non-object
%**
%** Value found: test
%** in file "c:/Users/Nicholas/Desktop/117/labs/lab12.oz", line 171, column 0
 
declare
fun {Wrap Obj} %------------------------------------- line 154
   WrapInit = {NewName}
   class AttrCount
      attr count
      meth !WrapInit skip end
      meth browseCount
	 {Browse @count}
      end
      meth otherwise(M)
	 @count = @count + 1
	 {Obj M}
      end
   end
in {New AttrCount WrapInit} end

declare
test = {Wrap {New Counter init(0)}}
{test inc(a:2 b:3)} % ---------------------------------------  line 171

test = {Wrap {New Counter init(0)}}

%=================================================================================================================================%
% Part 2 (4 pts)
% Convert the C++ code lab12Market.cpp on Piazza into Oz. Run several tests and include them in your assignment file, to show that the code executes properly.
% Important concepts:
% • Static member variables -> in lab example
% • Protected methods -> Page 515-6
% • Private methods -> Page 514
% • All instances of ‘this->’ can be ignored.


declare
CashierNum = {NewCell 0}
class Market
   attr
      apples: {NewCell 100}
      oranges: {NewCell 130}
      bananas: {NewCell 218}
      pineapples: {NewCell 231}
      profits: {NewCell 0}
      cashiers: {NewCell 0}
      transactions: {NewCell 0}
      getApples: GetApples
      getOranges: GetOranges
      getBananas: GetBananas
      getPineapples: GetPineapples
      getProfits: GetProfits
      getCashiers: GetCashiers
      getTransactions: GetTransactions
      updateApples: UpdateApples
      updateBananas: UpdateBananas
      updateOranges: UpdateOranges
      updatePineapples: UpdatePineapples
      updateProfits: UpdateProfits
      updateCashiers: UpdateCashiers
      updateTransactions: UpdateTransactions
      
   meth GetApples(X)
      X = @(@apples)
   end
   
   meth GetOranges(X)
      X = @(@oranges)
   end
   
   meth GetBananas(X)
      X = @(@bananas)
   end
   
   meth GetPineapples(X)
      X = @(@pineapples)
   end

   meth GetProfits(X)
      X = @(@profits)
   end

   meth GetCashiers(X)
      X = @(@cashiers)
   end

   meth GetTransactions(X)
      X = @(@transactions)
   end
   
   meth UpdateApples(X)
      (@apples) := @(@apples) - X 
   end

   meth UpdateOranges(X)
      (@oranges) := @(@oranges) - X
   end
   
   meth UpdateBananas(X)
      (@bananas) := @(@bananas) - X
   end

   meth UpdatePineapples(X)
      (@pineapples) := @(@pineapples) - X
   end

   meth UpdateProfits(X)
      (@profits) := @(@profits) + X
   end
   
   meth UpdateCashiers(X)
      (@cashiers) := @(@cashiers) + X
   end

   meth UpdateTransactions(X)
      (@transactions) := @(@transactions) + X
   end

   meth displayAll()
      {Inspect 'Apples: '#@(@apples)}
      {Inspect 'Oranges: '#@(@oranges)}
      {Inspect 'Bananas: '#@(@bananas)}
      {Inspect 'Pineapples: '#@(@pineapples)}
      {Inspect 'MarketProfits: '#@(@profits)}
      {Inspect 'Transactions: '#@(@transactions)}
   end

   meth init() skip end
end

declare
class Cashier
   from Market

   attr
      profits1
      transactions1
      id 
      
   meth GetProfits(X)
      X = (@profits1)
   end

   meth GetTransactions(X)
      X = (@transactions1)
   end
      
   meth UpdateProfits(X)
      profits1 := (@profits1) + X
   end

   meth UpdateTransactions(X)
      transactions1 := (@transactions1) + X
   end
      
   meth init()
      UC = @updateCashiers
   in
      profits1 := 0
      transactions1 := 0
      Market,UC(1)
      id := @CashierNum
      CashierNum := @CashierNum + 1
   end
   
   meth makePurhase(Fruit Amount Completed)
      Store
      UT = @updateTransactions
      GA = @getApples
      UA = @updateApples
      GO = @getOranges
      UO = @updateOranges
      GB = @getBananas
      UB = @updateBananas
      GPA = @getPineapples
      UPA = @updatePineapples
      UP = @updateProfits
   in
      Market,UT(1)
      {self UpdateTransactions(1)}
      if Fruit == 'apple' then
	 {self GA(Store)}
	 if Store > Amount then
	    {self UA(Amount)}
	    {self UpdateProfits(5 * Amount)}
	    Market,UP(5 * Amount) %Market
	    Completed = true
	 else
	    Completed = false
	 end
      elseif Fruit == 'orange' then
	 {self GO(Store)}
	 if Store > Amount then
	    {self UO(Amount)}
	    {self UpdateProfits(5 * Amount)}
	    Market,UP(5 * Amount) %Market
	    Completed = true
	 else
	    Completed = false
	 end
      elseif Fruit == 'banana' then
	 {self GB(Store)}
	 if Store > Amount then
	    {self UB(Amount)}
	    {self UpdateProfits(5 * Amount)}
	    Market,UP(5 * Amount) %Market
	    Completed = true
	 else
	    Completed = false
	 end
      elseif Fruit == 'pineapple' then
	 {self GPA(Store)}
	 if Store > Amount then
	    {self UPA(Amount)}
	    {self UpdateProfits(5 * Amount)}
	    Market,UP(5 * Amount) %Market
	    Completed = true
	 else
	    Completed = false
	 end
      end
   end
   
   meth displayAll()
      X
      GC = @getCashiers
   in
      {Inspect 'ID: '#(@id)}
      {Inspect 'UserProfits: '#(@profits1)}
      {Inspect 'Transaction: '#(@transactions1)}
      Market,displayAll()
      Market,GC(X)
      {Inspect 'X: '#X}
   end
end

declare
Obj1 = {New Cashier init()}
Obj2 = {New Cashier init()}
Obj3 = {New Cashier init()}
Complete

{Obj1 makePurhase('orange' 1 Complete)}
{Obj2 makePurhase('banana' 2 Complete)}
{Obj3 makePurhase('pineapple' 3 Complete)}

{Obj1 displayAll()}
{Obj2 displayAll()}
{Obj3 displayAll()}

