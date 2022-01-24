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
    ((exists (car x) (cdr x)) (remove-duplicate (cdr x)))
    (t (cons (car x) (remove-duplicate (cdr x))))
    )
  )

;(trace exists)
;(print (remove-duplicate '(a b c a d b)))
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
       ((null (car L)) (list nil nil))
       (t (cons (branch L) (list (branch (cdr L))))))
)

(defun branch (L)
   (cond
       ((null (car L)) nil)
       (t (cons (car L) (branch (cdr (cdr L))))))
)

;(trace split)
;(print (split '(1 2 3 4 5 6 7 8)))

(defun allsubsets (L)
  (if (null L) L
    (if (null (cdr L)) (list nil L)
      (remove-duplicate (cons L (combinations (createSubsets L L))))))
  )


(defun createSubsets (L1 L2)
  (if (null (cdr L1))
  (list (deleteElement (car L1) L2))
  (cons (deleteElement (car L1) L2) (createSubsets (cdr L1) L2)))
  )

(defun deleteElement (a L)
  (cond 
    ((null L) nil)
    ((equal a (car L)) (deleteElement a (cdr L)))
    (t (cons (car L) (deleteElement a (cdr L)))))
  )

(defun combinations (L)
  (if (null (cdr L))
    (allsubsets (car L))
    (zip (allsubsets (car L)) (combinations (cdr L))))
  )

;(trace allsubsets)
;(allsubsets '(a b c))


(defun reached (x L)
  (cond
    ((null (nested x L)) nil)
    ((equal (car (nested x L)) (cdar L)) (cons (cdar L) (nested x (cdr L))))
    )
  )

(defun nested (x L)
  (cond 
    ((equal x (cdar L)) nil)    
    ((null L) nil)
    ((equal x (caar L)) (cons (cdar L) (nested x (cdr L)))))
  )

(trace reached)
;(reached 'google '( (google shopify) (google aircanada) (amazon aircanada)))
(print(reached 'google '( (google shopify) (google aircanada) (amazon aircanada) (aircanada delta) (google google) )) )
