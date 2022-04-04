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
:- dynamic c325/8.
:- dynamic setup/4.

