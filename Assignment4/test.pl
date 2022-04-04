:- use_module(library(clpfd)).

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


xdifferent([]).
xdifferent([L|Rest]) :- 
    \+ (append(_,[X|R],L), memberchk(X,R)),
    xdifferent(Rest).


test(P):-
    problem(P),
    write('                                                         '),
    maplist(xdifferent(P), P).
    write('sdf').


