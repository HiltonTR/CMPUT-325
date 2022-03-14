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
% https://stackoverflow.com/questions/46793293/get-elements-which-are-not-in-second-list 

setDifference([], _, []).
setDifference([A|S1], L, [A|S2]) :- \+ member(A, L), setDifference(S1, L, S2).
setDifference([A|S1], L, L2) :- member(A, L), setDifference(S1, L, L2).

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
swap([A, B |L1], [B, A |L2]) :- swap(L1, L2).


% 3. (1 mark)
% Define a predicate
%
% filter(+L,+OP,+N,-L1)
%
% where L is a possibly nested list of numbers; OP is one of the following words: equal, greaterThan, and lessThan; N is a number; and L1 is a flat list containing all the numbers in L such that the condition specified by OP and N is satisfied. E.g.
%
% ?- filter([3,4,[5,2],[1,7,3]],greaterThan,3,W).
% W= [4,5,7]
%
% ?- filter([3,4,[5,2],[1,7,3]],equal,3,W).
% W= [3,3]
%
% ?- filter([3,4,[5,2],[1,7,3]],lessThan,3,W).
% W= [2,1]



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

occurance(A, [], N, F) :-
	N = [A, F].
% If we've found an occurance of atom A, increase the frequency count and
% continue
occurance(A, [B|L], N, F) :-
	A == B,
	!,
	F1 is F + 1,
	occurance(A, L, N, F1).
% If we've found an atom that isn't A, continue
occurance(A, [_|L], N, F) :-
	!,
	occurance(A, L, N, F).

% Count iterates over the list, creating a list of the format
% [[Atom, Frequency], ...]
% Base case: return an empty list if the list is empty. Also return a list
% of all seen atoms so far.
count([], [], S, S).
% We've found an atom that we have already counted. Continue.
count([A|L], N, S, V) :-
	member(A, S),
	!,
	count(L, N, S, V).
% We've found a new atom. Count occurances of it, and append it to our list.
% Also append it to the list of seen atoms.
count([A|L], [X|N], S, V) :-
	!,
	occurance(A, L, X, 1),
	count(L, N, [A|S], V).
% countAll takes a list of atoms and returns a list of tuples with atom and
% frequency, sorted in descending order by frequency. As preserving the original
% structure of the list is unneccessary, we flatten the list first to ease
% the iterating. We also use a merge sort algorithm to sort the list.
countAll(L, R) :-
	count(L, N, [], _),
	merge_sort(N, R).

% Merge sort and halve were found here:
% http://kti.mff.cuni.cz/~bartak/prolog/sorting.html#merge
% Modified to sort tuples in the form of [Atom, Frequency]
% in descending order by frequency.
halve(L, A, B) :- hv(L, [], A, B).
hv(L, L, [], L). % for lists of even length
hv(L, [_|L], [], L).
hv([H|T], Acc, [H|L], B) :- !, hv(T, [_|Acc], L, B).

merge_sort([], []).
merge_sort([X], [X]).
merge_sort(L, S) :-
	L = [_, _ | _],
	halve(L, L1, L2),
	!,
	merge_sort(L1, S1),
	merge_sort(L2, S2),
	merge(S1, S2, S).
merge([], L, L).
merge(L, [], L) :- !, L \= [].
merge([[A1, F1]|T1], [[A2, F2]|T2], [[A1, F1]|T]) :-
	F1 =< F2,
	!,
	merge(T1, [[A2, F2]|T2], T).
merge([[A1, F1]|T1], [[A2, F2]|T2], [[A2, F2]|T]) :-
	F1 >= F2,
	!,
	merge([[A1, F1]|T1], T2, T).
% 5 (1 mark)
% Define a predicate
% 
% sub(+L,+S,-L1)
% 
% where L is a possibly nested list of atoms, S is a list of pairs in the form [[x1,e1],...,[xn,en]], and L1 is the same as L except that any occurrence of xi is replaced by ei. Assume xi's are atoms and ei's are arbitrary expressions. E.g. the goal sub([a,[a,d],[e,a]],[[a,2]],L) should return L= [2,[2,d],[e,2]].
% 
% Note: S is intended as a substitution. In this case, Xi's are distinct, and they do not occur in ei's.




% 6 (2 marks)
% The clique problem is a graph-theoretic problem of finding a subset of
% nodes where each is connected to every other node in the subset. In
% this problem, we assume that each node in a graph is connected to at
% least one another node, so a graph can just be represented by a
% collection of edges, edge(A,B). Assume edges are undirected, so that
% edge(A,B) implies edge(B,A). For example, the following Prolog facts
% represent a graph
% 
% edge(a,b).
% edge(b,c).
% edge(c,a).
% node(a).
% node(b).
% node(c).

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
% Cliques) will unify Cliques with a list containing all cliques. L should contain a single clique. The order that your predicate generates cliques does not matter.
% Your program must not contain definitions for edge/2 or node/1
% You can expect that facts for nodes edges will be appended to your
% program before it is run.