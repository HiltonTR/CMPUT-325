;; Hilton Truong
;; 1615505
;; CMPUT 325
;; Assignment 2



(defun fl-interp (E P)
    (cond
        ((atom E) E)
        (t
        (let ((func (car E)) (argument (cdr E)))
            (cond

		    ((eq func 'if) (if (fl-interp (car argument) P) (fl-interp (cadr argument) P) (fl-interp (caddr argument) P)))
		    ((eq func 'null) (null (fl-interp (car argument) P)))
		    ((eq func 'atom) (atom (fl-interp (car argument) P)))
            ((eq func 'eq) (eq (fl-interp (car argument) P) (fl-interp (cadr argument) P)))

            ((eq func 'first) (car (fl-interp (car argument) P)))
            ((eq func 'rest) (cdr (fl-interp (car argument) P)))

		    ((eq func 'cons) (cons (fl-interp (car argument) P) (fl-interp (cadr argument) P)))
            ((eq func 'equal) (equal (fl-interp (car argument) P) (fl-interp (cadr argument) P)))

            ((eq func 'number) (numberp (fl-interp (car argument) P)))

            ((eq func '+) (+ (fl-interp (car argument) P) (fl-interp (cadr argument) P)))
            ((eq func '-) (- (fl-interp (car argument) P) (fl-interp (cadr argument) P)))
            ((eq func '*) (* (fl-interp (car argument) P) (fl-interp (cadr argument) P)))
            ((eq func '>) (> (fl-interp (car argument) P) (fl-interp (cadr argument) P)))
            ((eq func '<) (< (fl-interp (car argument) P) (fl-interp (cadr argument) P)))
            ((eq func '=) (= (fl-interp (car argument) P) (fl-interp (cadr argument) P)))

            ((eq func 'and) (bool (and (fl-interp (car argument) P) (fl-interp (cadr argument) P))))
		    ((eq func 'or) (bool (or (fl-interp (car argument) P) (fl-interp (cadr argument) P))))
		    ((eq func 'not) (bool (not (fl-interp (car argument) P))))


            ((eq P nil) E)

            (t (fl-interp (getFunction func P) (append (createList (getArgument func P) argument P) P)))
            ;(t (cons (fl-interp (car E) P) (fl-interp (cdr E) P))) ; checks if it is a user defined function

            )
        )
        )
    )
)


(defun bool (num)
   (if num t nil)
)

(defun getArgument (func L)
  (cond
  ((null L) nil)
  ((eq func (caar L)) (cadar L))
  (T (getArgument func (cdr L)))))

(defun getFunction (func L)
  (cond
  ((null L) nil)
  ((eq func (caar L)) (caddar L))
  (T (getFunction func (cdr L)))))

(defun createList (argument input P)
  (cond
  ((null argument) nil)
  (T (cons (list (car argument) (fl-interp (car input) P))
       (createList (cdr argument) (cdr input) P)))))


;(trace fl-interp)



(defun ta-tests () 
"Reformatted tests provided by TA on eclass forum"
; built-in evaluation tests
(assert (eq (fl-interp '(+ 10 5) nil) '15) () 'P1-error)
(assert (eq (fl-interp '(- 12 8) nil) '4) () 'P2-error)
(assert (eq (fl-interp '(* 5 9) nil) '45) () 'P3-error)
(assert (not (fl-interp '(> 2 3) nil)) () 'P4-error)
(assert (fl-interp '(< 1 131) nil) () 'P5-error)
(assert (fl-interp '(= 88 88) nil) () 'P6-error)
(assert (not(fl-interp '(and nil true) nil)) () 'P7-error)
(assert (fl-interp '(or true nil) nil) () 'P8-error)
(assert (not(fl-interp '(not true) nil)) () 'P9-error)
(assert (fl-interp '(number 354) nil) () 'P10-error)
(assert (fl-interp '(equal (3 4 1) (3 4 1)) nil) () 'P11-error)
(assert (eq (fl-interp '(if nil 2 3) nil) '3) () 'P12-error)
(assert (fl-interp '(null ()) nil) () 'P13-error)
(assert (not(fl-interp '(atom (3)) nil)) () 'P14-error)
(assert (fl-interp '(eq x x) nil) () 'P15-error)
(assert (eq (fl-interp '(first (8 5 16)) nil) '8) () 'P16-error)
(assert (equal (fl-interp '(rest (8 5 16)) nil) '(5 16)) () 'P17-error)
(assert (equal (fl-interp '(cons 6 3) nil) (cons 6 3)) () 'P18-error)
(assert (eq (fl-interp '(+ (* 2 2) (* 2 (- (+ 2 (+ 1 (- 7 4))) 2))) nil) '12) () 'P19-error)
(assert (fl-interp '(and (> (+ 3 2) (- 4 2)) (or (< 3 (* 2 2)) (not (= 3 2)))) nil) () 'P20-error)
(assert (not (fl-interp '(or (= 5 (- 4 2)) (and (not (> 2 2)) (< 3 2))) nil)) () 'P21-error)
(assert (equal (fl-interp '(if (not (null (first (a c e)))) (if (number (first (a c e))) (first (a c e)) (cons (a c e) d)) (rest (a c e))) nil) (cons '(a c e) 'd)) () 'P22-error)

; More complicated tests that include user defined functions
(assert (eq (fl-interp '(greater 3 5) '((greater x y = (if (> x y) x (if (< x y) y nil)))) ) '5) () 'U1-error)
(assert (eq (fl-interp '(square 4) '((square x = (* x x)))) '16) () 'U2-OK 'U2-error)
(assert (eq (fl-interp '(simpleinterest 4 2 5) '((simpleinterest x y z = (* x (* y z))))) '40) () 'U3-error)
(assert (fl-interp '(xor true nil) '((xor x y = (if (equal x y) nil true)))) () 'U4-error)
(assert (eq (fl-interp '(cadr (5 1 2 7)) '((cadr x = (first (rest x))))) '1) () 'U5-error)
(assert (eq (fl-interp '(last (s u p)) '((last x = (if (null (rest x)) (first x) (last (rest x)))))) 'p) () 'U6-error)
(assert (equal (fl-interp '(push (1 2 3) 4) '((push x y = (if (null x) (cons y nil) (cons (first x) (push (rest x) y)))))) '(1 2 3 4)) () 'U7-error)
(assert (equal (fl-interp '(pop (1 2 3)) '((pop x = (if (atom (rest (rest x))) (cons (first x) nil) (cons (first x)(pop (rest x))))))) '(1 2)) () 'U8-error)
(assert (eq (fl-interp '(power 4 2) '((power x y = (if (= y 1) x (power (* x x) (- y 1)))))) '16) () 'U9-error)
(assert (eq (fl-interp '(factorial 4) '((factorial x = (if (= x 1) 1 (* x (factorial (- x 1))))))) '24) () 'U10-error)
(assert (eq (fl-interp '(divide 24 4) '((divide x y = (div x y 0)) (div x y z = (if (> (* y z) x) (- z 1) (div x y (+ z 1)))))) '6) () 'U11-error)
"All TA tests passed"
)

(defun eclass-tests ()
"Tests adapted from samples provided on elcass."
(assert (equal (fl-interp '(rest (1 2 (3))) nil) '(2 (3))) () "eclass 1 error")
(assert (equal (fl-interp '(rest (p 1 2 (3))) nil) '(1 2 (3))) () "eclass 2 error")
(assert (equal (fl-interp '(first (rest (1 (2 3)))) nil) '(2 3)) () "eclass 3 error")
(assert (equal (fl-interp '(eq (< 3 4) (eq (+ 3 4) (- 2 3))) nil) nil) () "eclass 4 error")
(assert (equal (fl-interp '(if (> 1 0) (+ 1 2) (+ 2 3)) nil) 3) () "eclass 5 error")
(assert (equal (fl-interp '(if (> 1 0) (if (eq 1 2) 3 4) 5)  nil) 4) () "eclass 6 error")
(assert (equal (fl-interp '(cons (first (1 2 3))  (cons a nil)) nil) '(1 a)) () "eclass 7 error")
(assert (equal (fl-interp '(and (or true  nil) (> 3 4)) nil) nil) () "eclass 8 error")
(assert (equal (fl-interp '(equal (1 2 3) (1 2 3)) nil) T) () "eclass 9 error")
"Eclass Tests Passed!"
)

(defun if-and-or-tests ()
"Tests to ensure that the special functions, 'if', 'and' and 'or' work correctly. Unlike
most functions these cannot execute their extra parameters unless the first parameter indicates
that they should. These tests ensure the the result is both correct and that code that shouldn't
exectue doesn't. Ie. if should not evaluate both code paths and the boolean operators should
short circuit correctly."
(assert (fl-interp '(if (null (first nil)) T (assert nil "If-test 1.0 failed!")) nil) () "If-test 1.1 failed!")
(assert (fl-interp '(if (not (null (first nil))) (assert nil "If-test 2.0 failed!") T) nil) () "If-test 2.1 failed!")

(assert (fl-interp '(or T (assert nil "Or-test 1.0 failed!")) nil) () "Or-test 1.1 failed!")
(assert (fl-interp '(or nil (null (first nil))) nil) () "Or-test 2 failed!")
(assert (not (fl-interp '(or nil (not (null (first nil)))) nil)) () "Or-test 3 failed!")
(assert (equal (fl-interp '(or nil (first (1 2 3))) nil) 1) () "Or-test 4 failed")

(assert (not (fl-interp '(and nil (assert nil "And-test 1.0 failed!")) nil)) () "And-test 1.1 failed!")
(assert (fl-interp '(and T (null (first nil))) nil) () "And-test 2 failed!")
(assert (not (fl-interp '(and T (not (null (first nil)))) nil)) () "And-test 3 failed!")
(assert (equal (fl-interp '(and T (first (1 2 3))) nil) 1) () "And-test 4 failed")
"If, And, Or all tests passed!"
)

(defun complex-prog-tests ()
"Test a 'complex' program. In this case implement a function to remove duplicates from
a list. Tests recursive calls, multiple function definitions and evaluation of sub-parameters in a list."
(let ((prg '((contains v l =
        (if (null l)
            nil
            (if (equal (first l) v)
            v
            (contains v (rest l)))))
    (remove-dups l =
        (if (null l)
            nil
            (if (contains (first l) (rest l))
                (remove-dups (rest l))
                (cons (first l) (remove-dups (rest l)))))))))
(assert (equal (fl-interp '(remove-dups (1 2 3 3 2 1)) prg) '(3 2 1)) () "Complex test 1 failed!")
(assert (equal (fl-interp '(remove-dups ((first (1 2 3)) 1 (1 1) (1 1) nil (null (first nil)))) prg) '(1 (1 1) nil T)) () "Complex test 2 failed"))
"Complex Program Tests Passed!"
)

(defun all-tests ()
"Run all tests"
(print '1)
(ta-tests)
(print '2)
(eclass-tests)
(print '3)
(if-and-or-tests)
(print '4)
(complex-prog-tests)
"All Tests Passed!"
)

(all-tests)