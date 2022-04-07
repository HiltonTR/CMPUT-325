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
:- use_module(library(lists)).

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
	setup(Semester, as1, MaxAs1, Weight1),
	setup(Semester, as2, MaxAs2, Weight2),
	setup(Semester, as3, MaxAs3, Weight3),
	setup(Semester, as4, MaxAs4, Weight4),
	setup(Semester, midterm, MaxMidterm, WeightMidterm),
	setup(Semester, final, MaxFinal, WeightFinal),
	c325(Semester, Name, As1, As2, As3, As4, Midterm, Final),
	Total is As1 / MaxAs1 * Weight1 + 
    As2 / MaxAs2 * Weight2 + 
    As3 / MaxAs3 * Weight3 + 
    As4 / MaxAs4 * Weight4 + 
    Midterm / MaxMidterm * WeightMidterm + 
    Final / MaxFinal * WeightFinal.



query2(Semester, L) :-
	findall(Name, getResults(Semester, Name), L).

getResults(Semester, Name) :-
	setup(Semester, midterm, MidtermMark, _),
	setup(Semester, final, FinalMark, _),
	c325(Semester, Name, _, _, _, _, Midterm, Final),
	Midterm / MidtermMark < Final / FinalMark.



query3(Semester, Name, as1, NewMark) :-
    c325(Semester, Name, As1, As2, As3, As4, Midterm, Final),
    retract(c325(Semester, Name, As1, As2, As3, As4, Midterm, Final)),
    assert(c325(Semester, Name, NewMark, As2, As3, As4, Midterm, Final)).

query3(Semester, Name, as2, NewMark) :-
    c325(Semester, Name, As1, As2, As3, As4, Midterm, Final),
    retract(c325(Semester, Name, As1, As2, As3, As4, Midterm, Final)),
    assert(c325(Semester, Name, As1, NewMark, As3, As4, Midterm, Final)).

query3(Semester, Name, as3, NewMark) :-
    c325(Semester, Name, As1, As2, As3, As4, Midterm, Final),
    retract(c325(Semester, Name, As1, As2, As3, As4, Midterm, Final)),
    assert(c325(Semester, Name, As1, As2, NewMark, As4, Midterm, Final)).

query3(Semester, Name, as4, NewMark) :-
    c325(Semester, Name, As1, As2, As3, As4, Midterm, Final),
    retract(c325(Semester, Name, As1, As2, As3, As4, Midterm, Final)),
    assert(c325(Semester, Name, As1, As2, As3, NewMark, Midterm, Final)).

query3(Semester, Name, midterm, NewMark) :-
    c325(Semester, Name, As1, As2, As3, As4, Midterm, Final),
    retract(c325(Semester, Name, As1, As2, As3, As4, Midterm, Final)),
    assert(c325(Semester, Name, As1, As2, As3, As4, NewMark, Final)).

query3(Semester, Name, final, NewMark) :-
    c325(Semester, Name, As1, As2, As3, As4, Midterm, Final),
    retract(c325(Semester, Name, As1, As2, As3, As4, Midterm, Final)),
    assert(c325(Semester, Name, As1, As2, As3, As4, Midterm, NewMark)).

query3(_,_,_,_):-
    write('Record not found').





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

encrypt(W1,W2,W3) :- 
    length(W1,N), % if you need to know the lengths of words
    length(W3,N1),   
    append(W1,W2,W),
    append(W,W3,L),
    list_to_set(L, Letters), % remove duplicates, a predicate in list library
    [LeadLetter1|_] = W1, % identify the leading letter to be set to non-zero
    [LeadLetter2|_] = W2,
    [LeadLetter3|_] = W3,
    !, % never need to redo the above
    LeadLetter1 #\= 0,
    LeadLetter2 #\= 0,
    LeadLetter3 #\= 0,
    all_diff(Letters),

    get_sum(W1, Sum1),
    get_sum(W2, Sum2),
    Sum4 #= Sum3,
    Sum3 #= Sum1 + Sum2,
    get_sum(W3, Sum4),

    Letters ins 0..9,
    label(Letters).
 
 get_sum([], 0).
 get_sum([A|L], Sum) :-
    length([A|L], Len),
    Exp is Len - 1,
    power(10, Exp, P),
    Sum1 #= A*P,
    get_sum(L, Sum2),
    Sum #= Sum1 + Sum2.
 
 power(_, 0, 1) :- !.
 power(Base, Exp, Result) :-
    Exp1 is Exp - 1,
    power(Base, Exp1, Result1),
    Result is Result1 * Base.
 
 %taken from eclass
 all_diff([_]).
 all_diff([A|L]) :-
    diff(A, L),
    all_diff(L).
 
 diff(_, []).
 diff(A, [B|L]) :-
    A #\= B,
    diff(A,L).
 


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

xlength(L, Ls) :- 
    length(Ls, L).   

grid(9, Rows) :-
    length(Rows, 9),
    maplist(xlength(9), Rows).

% I couldnt figure out how to get my different to work so i just used the library definition. 
xall-distinct(X):-
    maplist(all_different, X).

% user of memberchk found from here
% https://stackoverflow.com/questions/33910925/define-a-rule-to-determine-if-a-list-contains-a-given-member
xdifferent([]).
xdifferent([L|Rest]) :- 
    \+ (append(_,[X|R],L), 
    memberchk(X,R)),
    xdifferent(Rest).


xtranspose([[]|_], []).
xtranspose(Mat, [Row|Rows]) :- 
    transposecol(Mat, Row, Matrix),
    xtranspose(Matrix, Rows).

transposecol([], [], []).
transposecol([[First|Remainder]|Rows], [First|Rest1], [Remainder|Rest2]) :- 
    transposecol(Rows, Rest1, Rest2).



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



% ----------------------------------------------------------------------------------------------------------------------


% Question 5 (3 marks)
% As a conference program chair, you are to assign papers to reviewers, given facts of the form
%      paper(ID, Co-author1, Co-author2, Subject)
%      reviewer(Name, Subject1, Subject2)

% where each paper is identified by its id number, co-authors (for simplicity assume no more than two; 
%     for single-authored papers, Co-author2 is filled with xxx), and subject area, and each reviewer 
%     is identified by name and two subject areas of expertise. For example, the input data may look like
%     paper(2, john, lily, ai).
%     paper(3, ken, xxx, database).
%     reviewer(audrey, ai, logic).
%     ......

% What we want is a paper review assignment satisfying

% (1) No one reviews his/her own paper;
% (2) For a reviewer to review an assigned paper, one of his/her areas of expertise must match the paper's subject.
% (3) Each paper is assigned to 2 reviewers; and
% (4) No reviewer is assigned more than k papers, where k will be given as a fact: workLoadAtMost(k).
% You should write a program so that a paper assignment is generated by
% ?-   assign(W1,W2).
% where W1 and W2 denote a list of papers assigned to each be reviewed by two people. Positions in a list 
% represents a paper ID. E.g.
% W1 = [lily,john,...]
% W2 =[peter, ann,...]
% means that paper #1 is assigned to lily and peter, and paper #2 to john and ann, etc. Papers will be 
% numbered consecutively starting from 1.  See this instance for an example. 

