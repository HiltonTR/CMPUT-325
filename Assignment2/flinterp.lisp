;; Hilton Truong
;; 1615505
;; CMPUT 325
;; Assignment 2

(defun fl-interp (Exp P)
"
This is the main function that is called. Clean is called on P as if it is a user defined program,
it will clean up the formatting so that it is easier to process below. The parameters it takes are
the expression and the program. The program will be nil if not using a user defined one.

Example:
  (fl-interp '(+ 1 2) nil)
  => 3
"
  (interp Exp (clean P)))

(defun interp (Exp P)
"
This function interprets all the allowed built in functions specified on eclass and takes user defined functions and
executes them.
"
    (cond
      ((atom Exp) 
        (cond 
          ((userDefined Exp P) (interp (getVariable Exp P) P)) ; this clause right here is needed as the way 
          ; it was formatted above will give an error otherwise
          (t Exp)))
      (t (let ((func (car Exp)) (argument (cdr Exp)))
        (cond
        ((eq func 'if) (if (interp (car argument) P) (interp (cadr argument) P) (interp (caddr argument) P)))
        ((eq func 'null) (null (interp (car argument) P)))
        ((eq func 'atom) (atom (interp (car argument) P)))
        ((eq func 'eq) (eq (interp (car argument) P) (interp (cadr argument) P)))

        ((eq func 'first) (car (interp (car argument) P)))
        ((eq func 'rest) (cdr (interp (car argument) P)))

        ((eq func 'cons) (cons (interp (car argument) P) (interp (cadr argument) P)))
        ((eq func 'equal) (equal (interp (car argument) P) (interp (cadr argument) P)))

        ((eq func 'number) (numberp (interp (car argument) P)))

        ((eq func '+) (+ (interp (car argument) P) (interp (cadr argument) P)))
        ((eq func '-) (- (interp (car argument) P) (interp (cadr argument) P)))
        ((eq func '*) (* (interp (car argument) P) (interp (cadr argument) P)))
        ((eq func '>) (> (interp (car argument) P) (interp (cadr argument) P)))
        ((eq func '<) (< (interp (car argument) P) (interp (cadr argument) P)))
        ((eq func '=) (= (interp (car argument) P) (interp (cadr argument) P)))

        ((eq func 'and) (bool (and (interp (car argument) P) (interp (cadr argument) P))))
        ((eq func 'or) (bool (or (interp (car argument) P) (interp (cadr argument) P))))
        ((eq func 'not) (bool (not (interp (car argument) P))))

        ((eq P nil) Exp)
        ((userDefined func P) (interp (getBody func P) (append (createList P (getVariable func P) argument) P))) ; 

        (t Exp))))))

(defun bool (num)
"
This is a helper function for interp. It just returns a boolean
for the logical operations instead of a number.

Example:
  (bool 1)
  => T
"
   (if num t nil))

(defun userDefined (Exp P)
"
This is a helper function for interp. This function
searches through P to see if there if it is a user defined 
function or not by seeing if Exp exists in P. If Exp exists, it
is a user defined function. If it does not exist, it is not 
a user defined function.

Example: 
  (userDefined '(greater 20 40) '((GREATER (X Y) (IF (> X Y) X (IF (< X Y) Y NIL)))))
  => nil
"
  (cond
  ((null Exp) nil)
  ((null P) nil)
  ((eq Exp (car (car P))) t)
  (t (userDefined Exp (cdr P)))))


(defun clean (P)
"
This helper function is used to help clean up the user defined function so that
car and cdr and be more used more easily to get the arguments. The first thing it 
does is that it takes the values after the function name and wraps them in parenthesis
so that car and cdr can be called on them later on. It achieves this through the use of
mapcar which allows us to grab the successive elements and make a list which will be 
the new input P. 

The use of mapcar was seen through the two following links:
https://stackoverflow.com/questions/67640501/is-there-a-way-to-implement-mapcar-in-common-lisp-using-only-applicative-program 
http://www.lispworks.com/documentation/lw50/CLHS/Body/f_mapc_.htm 

Example:
  P = (add (x y) = (+ x y))
  (clean P) => (add (x y) (+ x y))
"
  (cond
  ((null P) nil)
  (t (mapcar (lambda (x) (list (car x) (beforeEqual (cdr x)) (afterEqual x))) P))))

(defun beforeEqual (function)
" 
This is a helper function for clean. It takes all elements before the = sign
so clean can make it into a list.

Example:
  (add (x y) = (+ x y))
  => (add x y)
"
  (cond
  ((eq '= (car function)) nil)
  (t (flatten (cons (car function) (beforeEqual (cdr function)))))))


(defun afterEqual (function)
" 
This is a helper function for clean. It takes all elements after the = sign
so clean can make it into a list.

Example:
  (add x y = (+ x y))
  => (+ x y)
"
  (cond
  ((null function) nil)
  ((eq '= (car function)) (car (cdr function)))
  (t (afterEqual (cdr function)))))

(defun flatten (x)
  "This function takes a list x where there may be many nested lists
   and flattens the list to one level in the same order. Taken from assignment 1

  Example:
    (flatten '(a (b c) d)) => (a b c d)

    (flatten '((((a))))) => (a)

    (flatten '(a (b c) (d ((e)) f))) => (a b c d e f)
   "
    (if (null x)
        nil ; if the list is empty then return nil
        (if (atom (car x)) ; otherwise if there is an atom, create a list and recursively call it
            (cons (car x) (flatten (cdr x)))
            (append (flatten (car x)) (flatten (cdr x))))))

(defun getVariable (func L)
"
This is a helper function for interp as it finds the given variables for the function.
As we have previously cleaned up the function, it becomes a lot easier to find as it
is already in the format of a list, eliminating the need to process it further.
"
  (cond
  ((null func) nil)
  ((null L) nil)
  ((eq func (caar L)) (car (cdar L)))
  (t (getVariable func (cdr L)))))

(defun getBody (func L)
"
This is a helper function for interp as it finds the function definition.
As we have previously cleaned up the function, it becomes a lot easier to find as it
is already in the format of a list and we won't need to process it further.
"
  (cond
  ((null func) nil)
  ((null L) nil)
  ((eq func (caar L)) (car (cddr (car L))))
  (t (getBody func (cdr L)))))

(defun createList (P argument input)
"
This function is a helper function that creates a list from the variables and bodies.
"
  (cond
  ((null P) nil)
  ((null argument) nil)
  ((null input) nil)
  (T (cons (list (car argument) (interp (car input) P))
       (createList P (cdr argument) (cdr input))))))


;Useful trace for debugging.
;(trace interp)
