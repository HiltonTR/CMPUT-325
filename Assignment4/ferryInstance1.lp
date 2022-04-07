#const steps=16.

car(car1).
car(car2).
car(car3).
car(car4).

location(a).
location(b).
location(c).
location(d).
location(e).
location(f).
location(g).

at(car1,a,0).
at(car2,a,5).
at(car3,c,0).
at(car4,c,8).

at(ferry,g,0).

goal(T):-
at(car1,b,T),
at(car2,f,T),
at(car3,b,T),
at(car4,g,T).

