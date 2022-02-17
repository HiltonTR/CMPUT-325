;; Hilton Truong
;; 1615505
;; CMPUT 325
;; Assignment 2

"""
(if x y z) !
(null x) !
(atom x) !
(eq x y) !

(first x) !
(rest x) !

(cons x y) !
(equal x y) !
(number x)  return T (true) if x is a number, NIL otherwise. 
       Same as (numberp x) in Lisp

(+ x y) !
(- x y) !
(* x y) !
(> x y) !
(< x y) !
(= x y) !

(and x y)?
(or x y)?
(not x)?
"""

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


            ((eq func 'and) (and (fl-interp (car argument)) (fl-interp (cadr argument) P)))
            ((eq func 'or) (or (fl-interp (car argument)) (fl-interp (cadr argument) P)))            
            ((eq func 'not) (not (fl-interp (car argument) P)))



            ((eq P nil) E)

            (t (cons (fl-interp (car argument) P) (fl-interp (cdr argument) P)))

            )
            )
        )
    )
)



;(trace fl-interp)
(print (fl-interp '(rest (1 2 (3))) nil))
(print (fl-interp '(eq (1 2 3) (1 2 3)) nil))
(print (fl-interp '(first (rest (1 (2 3)))) nil) )

(print (eq (fl-interp '(+ 10 5) nil) '15))
(print (eq (fl-interp '(- 12 8) nil) '4))
(print (eq (fl-interp '(* 5 9) nil) '45))

(print (fl-interp '(> 2 3) nil))
(print (fl-interp '(< 1 131) nil))
(print (fl-interp '(= 88 88) nil))

;(print (fl-interp '(and nil true) nil))
;;;;;(print (fl-interp '(and 1 0) nil))
;(print (fl-interp '(or true nil) nil))
;(print (fl-interp '(not true) nil))
