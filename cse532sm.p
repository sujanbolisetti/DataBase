:-auto_table.

enrolls('John','102','Q1').
enrolls('John','202','Q2').
enrolls('John','302','Q3').
enrolls('Mike','102','Q1').
enrolls('Mike','202','Q1').
enrolls('Mike','302','Q3').


prereqs('202','102').
prereqs('302','202').


metro(c,1).
metro(1,2). 
metro(2,c).
metro(2,4).

bus(a,b).
bus(b,c).
bus(c,d).
bus(d,e).
bus(e,f).
bus(a,c).
bus(c,e).
bus(e,b).
bus(b,d).
bus(d,f).
bus(1,2).
bus(2,3).
bus(3,4).
bus(4,5).

/* Question1 : Find the direct and indirect prerequiste */

queAns1a(X,Y):-prereqs(X,Y).
queAns1a(X,Y):-queAns1a(Z,Y),queAns1a(X,Z),prereqs(X,_),prereqs(_,Y). 

:- table queAns1a/2.


/* Format output */
    ?- writeln('Pairs '),
       queAns1a(X, Y),
       write(' '),
       write(Y),
       write(' Prerequiste Of '),
       writeln(X),
       fail;
       true.


/* Finding all the pairs of student name, course and prerequiste  */
answer(X,Y,Z) :- enrolls(X,Y,_),queAns1a(Y,Z).

/* Doing a Natural Join for enrolls and total prerequiste */
ansInt(X,Y,S,Z) :- enrolls(X,Y,Z),queAns1a(Y,S).

/* we are getting the student course and prerequiste pair for eligible students for that course */

ansInt2(X,Y,S) :- enrolls(X,S,D),ansInt(X,Y,S,Z), D @< Z.

/*Subtracting from all the students to get the ineligible students course pairs */

queAns1b(X,Y) :- answer(X,Y,S),tnot(ansInt2(X,Y,S)).


:- table queAns1b/2.


/* Format output */
    ?- writeln('Student Course pairs '),
       queAns1b(X,Y),
       write(' '),
       write(X),
       write(' is Not eligible for taking the course '),
       writeln(Y),
	   fail;
       true.
	   
/* Question 2a */	

/* Find all the possible bus paths */ 

mbus(X,Y) :- bus(X,Y).
mbus(X,Y) :- mbus(X,Z), mbus(Z, Y).

/* Find all the possible bus paths */ 

mmetro(X,Y) :- metro(X,Y).
mmetro(X,Y) :- mmetro(X,Z), mmetro(Z, Y).

/* Get all the paths  */

ans(X,Y) :- mmetro(X,Y).
ans(X,Y) :- mbus(X,Y).

/* Find the paths where bus and metro are both operational */

ans(X,Y) :- ans(X,Z),ans(Z,Y),X\=Y.

/* subtracting only from only bus and metro will give us only those specific paths */

ans2a(X,Y) :- ans(X,Y),tnot(mbus(X,Y)),tnot(mmetro(X,Y)). 

:- table ans2a/2.

?- writeln('Ans ques2a'),
       ans2a(X,Y),
       write(' '),
       write(X),
       write(' has path to '),
       writeln(Y),
       fail;
       true.
	   
/* multi path bus */
mbus(X,Y) :- bus(X,Y).
mbus(X,Y) :- bus(X,Z), mbus(Z,Y).

/* multi path metro*/
mmetro(X,Y) :- metro(X,Y).
mmetro(X,Y) :- metro(X,Z), mmetro(Z,Y).

/* All possible combinations of X and Y */
anymode(X,Y) :- mbus(X,Y).
anymode(X,Y) :- mmetro(X,Y).
anymode(X,Y) :- anymode(X,_),anymode(Y,_),X\=Y.
anymode(X,Y) :- anymode(_,X),anymode(_,Y),X\=Y.
anymode(X,Y) :- anymode(X,_),anymode(_,Y),X\=Y.
anymode(X,Y) :- anymode(_,X),anymode(Y,_),X\=Y.

/* find the the bad path-where no station set (A,C) between(M,N) has link to subequent station via metro */  
badpath(A,B):- anymode(A,B),tnot(mmetro(A,B)),mbus(A,B).
badpath(A,C):- anymode(A,C),badpath(A,B),mbus(A,C),tnot(mmetro(A,C)),mbus(B,C).

/* complement of ans(M,N) whre A,C is any set of stations between M,N having bad path*/
complans(M,N):- mbus(M,A),mbus(C,N),badpath(A,C).

ans2b(M,N):- anymode(M,N), tnot(complans(M,N)),M\=N.

:-table ans2b/2.

?- writeln('Ans ques2b'),
       ans2b(M,N),
       write(' '),
       write(M),
       write(' has a path to '),
       writeln(N),
       fail;
       true.