;QUESTION
;DOCUMENTATION
(defun xcount (L)
    (cond
      ((null L) 0)
      (t (+ (cond
              ((null (car L)) 0)
              ((atom (car L)) 1)
              (t (xcount (car L)))
              )
            (xcount (cdr L))))))

;(trace xcount)
;(print (xcount '(a (b c d (a (a () () (a)) d)) c)))


(defun flatten (x)
    (if (null x)
        nil
        (if (atom (car x))
            (cons (car x) (flatten (cdr x)))
            (append (flatten (car x)) (flatten (cdr x))))))

;(trace flatten)
;(print (flatten '(a (b (c (d) (e (1 (2 3 4 (5) 6))))))))
