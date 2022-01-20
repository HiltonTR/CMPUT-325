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

(defun exists (a L)
  (cond 
    ((null L) nil)
    ((equal a (car L)) L)
    (t (exists a (cdr L)))
    )
  )

;(trace exists)
;(print (exists 'a '(a b c e a e f e)))


(defun remove-duplicate (x)
  (cond
    ((null x) nil)
    ((exists (car x) (cdr x)) (cons (car x) (remove-duplicate (cdr x))))
    (t (cons (car x) (cdr x)))
    )
  )

(trace exists)
(print (remove-duplicate '(a b c e d e a e)))
;(print (remove-duplicate '(1 1 2 2 3 3 3 4 5 1)))


(defun zip (L1 L2)
   (cond
         ((null L1) L2)
         (t (cons (car L1) (zip L2 (cdr L1))))
    )
  )

;(trace zip)
;(print (zip '(1 2 3) '(a b c d e f g)))



(defun split (L)
  (cond
    ((null L) nil)
    ((eq 1 (length L)) (list (car L)))
    (t (cons (cons (car L)
                   (split (cdr (cdr L))))
              (car (cdr L))))
    )
  )

;(trace split)
;(print (split '(1 2)))

