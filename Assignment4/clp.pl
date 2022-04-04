% -------------------------------------------------------------------------------------------------------------------------------------------

% Question 1 (2 marks)

% Suppose we have a database of student marks for cmput 325, in the form of a relation with attribute names
%           c325(Semester, Name, as1, as2, as3, as4, midterm, final)

% There are some facts about the setup of course components, in the form

%         setup(Semester,Type,Max,Percentage)

% where Type is one of {as1,as2,as3,as4,midterm,final}, Max is the maximum marks for Type and percentage is the weight of Type in the course.

% You may use this database to test your programs. 


% (a) Define a predicate:

%               query1(+Semester, +Name, -Total)

% Given a semester and a student name, Total is bound to the total mark, in terms of percentage out of 100, of the student for that semester.

% Test case:

% ?- query1(fall_2021, kim, X).
% X = 81.53333333333335 ?;
% false

% In prolog, there is a way to truncate a real number up to a fixed number of decimal places, which is something you don't need to worry about.


% (b)  Define a predicate:

%         query2(+Semester, -L).

% Given a semester, find all students whose final exam shows an improvement over the midterm, in the sense that the percentage obtained from the final is (strictly) better than that of the midterm.

% Test case:
% ?- query2(fall_2021, X).
% X = [aperf, ...] 

% Here, we just list one name, there should be more. 


% (c) Define a predicate:

%           query3(+Semester,+Name,+Type,+NewMark)

% Updates the record of Name for Semester where Type gets NewMark. If the record is not in the database, print the message "record not found".

% Test cases:
% ?- query3(fall_2021, kim, final, 87).
% true

% ?- query3(fall_2014, jim, as1, 53).
% record not found
% true


% ----------------------------------------------------------------------------------------------------------------------


:- use_module(library(clpfd)).

insert_data :-
    assert(c325(fall_2021,aperf,15,15,15,15,75,99)),
    assert(c325(fall_2021,john,14,13,15,10,76,87)),
    assert(c325(fall_2021,lily, 9,12,14,14,76,92)),
    assert(c325(fall_2021,peter,8,13,12,9,56,58)),
    assert(c325(fall_2021,ann,14,15,15,14,76,95)),
    assert(c325(fall_2021,ken,11,12,13,14,54,87)),
    assert(c325(fall_2021,kris,13,10,9,7,60,80)),
    assert(c325(fall_2021,audrey,10,13,15,11,70,80)),
    assert(c325(fall_2021,randy,14,13,11,9,67,76)),
    assert(c325(fall_2021,david,15,15,11,12,66,76)),
    assert(c325(fall_2021,sam,10,13,10,15,65,67)),
    assert(c325(fall_2021,kim,14,13,12,11,68,78)),
    assert(c325(fall_2021,perf,15,15,15,15,80,100)),
    assert(setup(fall_2021,as1,15,0.1)),
    assert(setup(fall_2021,as2,15,0.1)),
    assert(setup(fall_2021,as3,15,0.1)),
    assert(setup(fall_2021,as4,15,0.1)),
    assert(setup(fall_2021,midterm,80,0.2)),
    assert(setup(fall_2021,final,100,0.4)).

assignments([as1, as2, as3, as4, midterm, final]).

query1(Semester, Name, Total) :-
    c325(Semester, Name, As1, As2, As3, As4, Midterm, Final).





% ----------------------------------------------------------------------------------------------------------------------




% Question 2 (2 marks)  (this is a written question; write your answers as prolog comments)

% This website gives the details of how sudoku is solved as a CSP and in particular,  the 
% details of constraint propagation using the arc-consistency algorithm, called AC-3, combined 
% with backtracking.  Study the algorithms of AC-3 and BACKTRACK.  First, show 5 examples of 
% removal of domain values in Example 1.  Then, show one example in Example 2 of domain values 
% that cannot be removed by AC-3; you need to argue why it cannot be removed. 

% In the upper left box we can remove 1 3 9 from the domain.
% In the upper middle box we can remove 2 3 5 8 6 from the domain.
% In the upper right box we can remove 1 4 6 from the domain.
% In the first row we can remove 2 3 6 from the domain. 
% In the first column we can remove 7 8 9 from the domain.

% Because the middle box is empty we are unable to remove many values. In the middle box, we are 
% unable to remove any value for certain so the domain of the whole box will still be {1-9}. We will
% have to go through the rows and columns to remove the domain values that way.





% ----------------------------------------------------------------------------------------------------------------------



% Question 3 (2 marks) 

% We have seen a constraint logic program for send+more=money. 
% Now, we want to extend this program to handle any cryptarithmetic puzzles. Define a predicate 

%        encrypt(W1,W2,W3)

% to assign the letters in the words with distinct digits so that the addition 
% of the values of W1 and W2 equals that of W3. Assume W1 and W2 are of the same length. 

% If the length of W1 and W2 is N, then the length of W3 is either N or N+1. 
% Note that the leading bit in any word cannot be assigned zero.

% For example.

% ?- encrypt([S,E,N,D], [M,O,R,E], [M,O,N,E,Y]). 

% should generate a solution where the variables in the goal are bound to appropriate 
% domain values.  By typing ";" at the end of each answer, your program should generate all 
% solutions and terminate. 

% https://stackoverflow.com/questions/11882760/cryptarithmetic-puzzle-prolog 
% https://ai.ia.agh.edu.pl/pl:prolog:pllib:cryptoarithmetic_puzzle_2

sum(N1, N2, N)  :-                    % Numbers represented as lists of digits
  sum1( N1, N2, N, 
	0, 0,                         % Carries from right and to left both 0
        [0,1,2,3,4,5,6,7,8,9], _).    % All digits available
 
sum1( [], [], [], C, C, Digits, Digits).
 
sum1( [D1|N1], [D2|N2], [D|N], C1, C, Digs1, Digs)  :-
  sum1( N1, N2, N, C1, C2, Digs1, Digs2),
  digitsum( D1, D2, C2, D, C, Digs2, Digs).
 
digitsum( D1, D2, C1, D, C, Digs1, Digs)  :-
  del_var( D1, Digs1, Digs2),        % Select an available digit for D1
  del_var( D2, Digs2, Digs3),        % Select an available digit for D2
  del_var( D, Digs3, Digs),          % Select an available digit for D
  S  is  D1 + D2 + C1,    
  D  is  S mod 10,                   % Reminder
  C  is  S // 10.                    % Integer division
 
del_var( A, L, L) :-
  nonvar(A), !.                      % A already instantiated
 
del_var( A, [A|L], L).
 
del_var( A, [B|L], [B|L1])  :-
  del_var(A, L, L1).



% ----------------------------------------------------------------------------------------------------------------------

% Question 4 (2 marks)

% In Week 12 in eClass there is a program that solves the problem of Sudoku where 
% some library definitions are used. In this question, you are asked to write your 
% own definitions for some of these predicates.  You should start with this program, 
% where the definitions of the three predicates below are missing. Your job is to 
% complete this program by filling in these definitions. 

% grid/2,  xtranspose/2,  xall-distinct/1

% Requirement: You cannot use library predicates that trivialize defining these 
% predicates: E.g. transpose or all_distinct from clpfd.
% Predicates such as #= and maplist are fine.

/* 
The goal of Sudoku is to fill in a 9 by 9 grid with digits 
so that each column, row, and 3 by 3 section contain the 
numbers between 1 to 9. At the beginning of the game, 
the 9 by 9 grid will have some of the squares filled in. 
Your job is to fill in the missing digits and complete the grid. 

*/


sudoku(Rows) :-
    grid(9, Rows),
        % Rows now is a 9x9 grid of variables
    append(Rows, Vs),
        % Vs is a list of all 9*9 variables in Rows
    Vs ins 1..9,
    xall-distinct(Rows),
        % Variables of each row get distinct values
    xtranspose(Rows, Columns),
        % get the columns of 9x9 grid
    xall-distinct(Columns),
    Rows = [As,Bs,Cs,Ds,Es,Fs,Gs,Hs,Is],
        % need references to rows
    blocks(As, Bs, Cs),
        % deal with three rows at a time
    blocks(Ds, Es, Fs),
    blocks(Gs, Hs, Is).

xlength(L, Ls) :- length(Ls, L).   

grid(9, Rows) :-
    length(Rows, 9),
    maplist(xlength(9), Rows).


xall-distinct(X):-
    maplist(all_different, X).

% https://stackoverflow.com/questions/20131904/check-if-all-numbers-in-a-list-are-different-in-prolog
xdifferent([]).
xdifferent([L|Rest]) :- 
    \+ (append(_,[X|R],L), memberchk(X,R)),
    xdifferent(Rest).



% https://stackoverflow.com/questions/4280986/how-to-transpose-a-matrix-in-prolog
xtranspose([[]|_], []).
xtranspose(Matrix, [Row|Rows]) :- transposecol(Matrix, Row, RestMatrix),
                                 xtranspose(RestMatrix, Rows).
transposecol([], [], []).
transposecol([[H|T]|Rows], [H|Hs], [T|Ts]) :- 
    transposecol(Rows, Hs, Ts).



blocks([], [], []).
blocks([N1,N2,N3|Ns1], [N4,N5,N6|Ns2], [N7,N8,N9|Ns3]) :-
    all_distinct([N1,N2,N3,N4,N5,N6,N7,N8,N9]),
    blocks(Ns1, Ns2, Ns3).

problem(P) :-
    P = [[1,_,_,8,_,4,_,_,_],
	 [_,2,_,_,_,_,4,5,6],
	 [_,_,3,2,_,5,_,_,_],
	 [_,_,_,4,_,_,8,_,5],
	 [7,8,9,_,5,_,_,_,_],
	 [_,_,_,_,_,6,2,_,3],
	 [8,_,1,_,_,_,7,_,_],
	 [_,_,_,1,2,3,_,8,_],
	 [2,_,5,_,_,_,_,_,9]].

t(Rows) :-
    problem(Rows),
    sudoku(Rows),
    maplist(labeling([ff]), Rows),
    maplist(writeln, Rows).

