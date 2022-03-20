% Assignment 3
% Hilton Truong 1615505

% 1. (1 mark)
% Define a predicate
%
% setDifference(+S1,+S2,-S3)
%
% where S1 and S2 are lists of atoms, and S3 is a list of atoms that are in S1 but not in S2. We assume S1 is a list of distinct atoms
% E.g.
%
% ?- setDifference([a,b,c,d,e,g],[b,a,c,e,f,q],S).
% S=[d,g]

% Base case
setDifference([], _, []).
% If S1 is in S2 
setDifference([A|S1], L, [A|S2]) :- 
	\+ member(A, L), 
	setDifference(S1, L, S2).
% If S1 is not in S2 
setDifference([A|S1], L, L2) :- 
	member(A, L), 
	setDifference(S1, L, L2).

% 2. (1 mark)
% Define a predicate
%
%                   swap(+L, -R)
% 
% where L is a list of elements and R is a list where the 1st two elements in L are swapped positions, so are the next two elements, and so on. If the number of elements in L is odd, then the last element is left as is. E.g,
%
% ?- swap([a,1,b,2], W).
% W = [1,a,2,b].
% 
% ?- swap([a,1,b], W).
% W = [1,a,b].
% 
% Note that L may be empty, in which case R should be empty too.


swap([], []).
swap([A], [A]).
swap([A, B |L1], [B, A |L2]) :- 
	swap(L1, L2).


% 3. (1 mark)
% Define a predicate
%
% filter(+L,+OP,+N,-L1)
%
% where L is a possibly nested list of numbers; OP is one of the following words: 
% equal, greaterThan, and lessThan; N is a number; and L1 is a flat list containing 
% all the numbers in L such that the condition specified by OP and N is satisfied. E.g.
%
% ?- filter([3,4,[5,2],[1,7,3]],greaterThan,3,W).
% W= [4,5,7]
%
% ?- filter([3,4,[5,2],[1,7,3]],equal,3,W).
% W= [3,3]
%
% ?- filter([3,4,[5,2],[1,7,3]],lessThan,3,W).
% W= [2,1]

% taken from eclass
flatten([],[]).
flatten([A|L],[A|L1]) :-
	xatom(A), flatten(L,L1).
flatten([A|L],R) :-
	flatten(A,Atom1), flatten(L,L1), append(Atom1,L1,R).

xatom(A) :- atom(A).
xatom(A) :- number(A).

greater(L,Limit,X) :- 
	findall(E,(member(E,L),E>Limit),Es),
	member(X,Es).

equal(L,Limit,X) :- 
	findall(E,(member(E,L),E==Limit),Es),
	member(X,Es).

less(L,Limit,X) :- 
	findall(E,(member(E,L),E<Limit),Es),
	member(X,Es).

filter([], _, _, _):-
	write('empty').

filter([L|R], O, N, W) :-
	O == 'greaterThan',
	flatten([L|R], L1),
	findall(X, greater(L1, N, X), W).

filter([L|R], O, N, W) :-
	O == 'equal',
	flatten([L|R], L1),
	findall(X, equal(L1, N, X), W).

filter([L|R], O, N, W) :-
	O == 'lessThan',
	flatten([L|R], L1),
	findall(X, less(L1, N, X), W).


% 4. (1 mark)
% Define a predicate
% 
%                       countAll(+L,-N)
% 
% such that given a flat list L of atoms, the number of occurrences of every atom is counted. Thus, N should be a list of pairs [a,n] representing that atom a occurs in L n times. These pairs should appear in increasing order. E.g.
% 
% ?- countAll([a,b,e,c,c,b],N).
% N = [[a,1],[e,1],[b,2],[c 2]]
% 
% Hint: First, get the occurrences counted, and then define a predicate that does the sorting.
%        You can adopt any shorting algorithm you can find and you will not be penalized for it (just cite the source). 

countAll(L, R) :-
	count(C, N, [], _),
	merge_sort(N, R).

% empty list
count([], [], S, S).
% if atom has already been previously accounted for skip
count([A|L], N, S, V) :-
	member(A, S),
	count(L, N, S, V).
% if this is a new atom, count the amount of times it appears
count([A|L], [X|N], S, V) :-
	count(L, N, [A|S], V).


% Merge sort and divide from the following: 
% http://kti.mff.cuni.cz/~bartak/prolog/sorting.html#merge
% http://kti.mff.cuni.cz/~bartak/prolog/recursion.html 

divide(L, A, B) :- 
	hv(L, [], A, B).
hv(L, L, [], L). 
hv(L, [_|L], [], L).
hv([H|T], Acc, [H|L], B) :- 
	!, 
	hv(T, [_|Acc], L, B).

merge_sort([], []).
merge_sort([X], [X]).
merge_sort(L, S) :-
	L = [_, _ | _],
	divide(L, L1, L2),
	!,
	merge_sort(L1, S1),
	merge_sort(L2, S2),
	merge(S1, S2, S).
merge([], L, L).
merge(L, [], L) :- 
	!, 
	L \= [].
merge([[Atom1, Count1]|T1], [[Atom2, Count2]|T2], [[Atom1, Count1]|T]) :-
	Count1 >= Count2,
	!,
	merge(T1, [[Atom2, Count2]|T2], T).
merge([[Atom1, Count1]|T1], [[Atom2, Count2]|T2], [[Atom2, Count2]|T]) :-
	Count1 =< Count2,
	!,
	merge([[Atom1, Count1]|T1], T2, T).



% 5 (1 mark)
% Define a predicate
% 
% sub(+L,+S,-L1)
% 
% where L is a possibly nested list of atoms, S is a list of pairs in the form [[x1,e1],...,[xn,en]],
% and L1 is the same as L except that any occurrence of xi is replaced by ei. Assume xi's are atoms 
% and ei's are arbitrary expressions. E.g. the goal sub([a,[a,d],[e,a]],[[a,2]],L). 
% should return L= [2,[2,d],[e,2]].
% 
% Note: S is intended as a substitution. In this case, Xi's are distinct, and they do not occur in ei's.

% Inspiriation taken from
% https://stackoverflow.com/questions/5850937/prolog-element-in-lists-replacement

sub([], [], []).
sub(L, [], L).
sub(L, [S1|SR], R) :-  
	rep(L, S1, R1), 
	sub(R1, SR, R).

% this predicate checks if the element is a list and if it is and the letter matches,
% it will substitute it into the new list.
rep([], [,], []).
rep([A|R], [A,B], L) :- 
	+is_list(A), 
	rep(R, [A,B], R2), 
	L = [B|R2].
rep([A|R], [C,D], L) :- 
	+is_list(A), 
	A == C,  
	rep(R, [C,D], R2), 
	L = [A|R2].
rep([A|R], [C,D], L) :- 
	rep( A,[C,D] ,R2), 
	rep( R,[C,D], R3), 
	L=[R2|R3].


% 6 (2 marks)
% The clique problem is a graph-theoretic problem of finding a subset of
% nodes where each is connected to every other node in the subset. In
% this problem, we assume that each node in a graph is connected to at
% least one another node, so a graph can just be represented by a
% collection of edges, edge(A,B). Assume edges are undirected, so that
% edge(A,B) implies edge(B,A). For example, the following Prolog facts
% represent a graph
% 
edge(a,b).
edge(b,c).
edge(c,a).
node(a).
node(b).
node(c).

% The set of nodes [a,b,c] is a clique, so is every subset of it. Note
% that the empty subset is a clique, by definition.
% 
% To solve this problem, first, by using the built-in predicate
% findall/3, one can find all nodes of a graph. Thus, the clique problem
% can be solved by generating all subsets and for each testing their
% connectivity.
% 
% Requirement:
% Define a predicate named clique(L) such that  findall(L, clique(L),
% Cliques) will unify Cliques with a list containing all cliques. L should contain a single clique. 
% The order that your predicate generates cliques does not matter.
% Your program must not contain definitions for edge/2 or node/1
% You can expect that facts for nodes edges will be appended to your
% program before it is run.

clique(L) :- 
	findall(A, node(A), Nodes), 
	ss(L, Nodes), 
	linked(L).

% custom subset function
ss([], _).
ss([A|B], S) :- 
	apnd(_, [A|S1], S), 
	ss(B, S1).

% custom append function 
apnd([], L, L).
apnd([F|T], L, [F|R]) :- 
	apnd(T, L, R).

% sees if all the nodes are connected
linked([]).
linked([A|L]) :- 
	connect(A, L), 
	linked(L).

% gets two nodes and sees if there's an edge between both nodes
connect(_, []).
connect(A, [B|L]) :- 
	edge(A,B), 
	connect(A, L).
connect(A, [B|L]) :- 
	edge(B,A), 
	connect(A, L).



% 7.  [3 marks]
% The question is about string conversion. Define a predicate
% 
%     convert(+Term,-Result)
% 
% with the following specification.
% 
% Term is a list (possibly empty) of single letters representing a string with the convention:
% 
%     * e represents an empty space
%     * q represents a single quote
% 
% Functionality:
% 
% Given Term, Result should hold the same Term except that
% 
%     * anything between two matching q's is not changed;
%     * any e's outside of a pair of matching q's are removed;
%     * any letter outside a pair of matching q's is changed to letter w.
%     * an unmatched q will be left as is.
% 
% Definition of matching q's:
% 
%       Any string with an odd number of occurrences of q has the last occurrence of
%       q unmatched; all the preceding ones are matched as: the first and second
%       form a pair, the 3rd and the 4th form the next pair, and so on.
% 
% Examples:
% 
% ?- convert([e,e,a,e,b,e],R)
% R = [w,w] ?;
% no
% 
% ?- convert([e,q,a,b,e,e],R).
% R = [q,w,w]?;
% no
% 
% ?- convert([e,a,e,e],R).
% R = [w]?;
% no
% 
% ?- convert([e,q,a,e,b,q,e,a,e],R).
% R = [q,a,e,b,q,w]? ;
% no
% 
% ?- convert([a,q,e,l,q,r,e,q,b,e],R).
% R = [w,q,e,l,q,w,q,w]? ;
% no
% 
% ?- convert([q,e,q,b,q,e,l,q,a,e],R).
% R = [q,e,q,w,q,e,l,q,w] ? ;
% no



% empty case
convert([], [], _).
% base case
convert(T,R) :- 
	convert(T, R, false).
% remove space if there's a space
convert([e|T], R, false) :-	
	convert(T, R, false).
% if a quote is found toggle the boolean to be true
convert([q|T], [q|R], false) :-	
	member(q, T), 
	convert(T, R, true).
% leave as is if its a quote and theres no more quotes
convert([q|T], [q|R], false):- 
	convert(T, R, false).
% change to a w if atom is not a quote or space
convert([_|T], [w|R], false) :- 
	convert(T, R, false).
% change th boolean to false when an end quote is reached
convert([q|T], [q|R], true) :- 
	convert(T, R, false).
% leave as is if atom isnt a quote but boolean is true
convert([A|T], [A|R], true) :- 
	convert(T, R, true).
