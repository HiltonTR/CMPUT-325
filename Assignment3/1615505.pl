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

