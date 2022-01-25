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
  (deleteElement x (branch x L))
  )

(defun branch (x L)
  (cond
    ((null L) nil)
    ((equal x (caar L)) 
      (cond 
        ((equal x (cadar L)) (reached x (cdr L)))
        ((null (reached (cadar L) L)) (cons (cadar L) (reached x (cdr L))))
        (t (cons (cadar L) (reached (cadar L) L)))
        ))
    (t (reached x (cdr L))))
  )

;(trace reached)
;(print(reached 'google '( (google shopify) (google aircanada) (amazon aircanada))))
;(print(reached 'google '( (google shopify) (shopify amazon) (amazon google) ) ))
;(print(reached 'google '( (google shopify) (shopify amazon) (amazon indigo) (amazon amazon) )))
;(print(reached 'google '( (google shopify) (google aircanada) (amazon aircanada) (aircanada delta) (google google))))

(defun strip (L)
  (cond
    ((null L) nil)
    (t (cons (cadar L) (strip (cdr L))))
    )
  )

(defun strip-results (L)
  (cond
    ((null L) nil)
    (t (cons (caar L) (strip-results (cdr L))))
    )
  )

(defun counter (a L)
  (cond
    ((null L) 0)
    ((equal a (car L)) (+ 1 (counter a (cdr L))))
    (t (counter a (cdr L)))))

(defun rank (S L)
  (cond
    ((null S) nil)
    (t (cons (cons (car S) (counter (car S) (strip L))) (rank (cdr S) L)))
    )
  )

(defun mySort (L)
  (sort L 'greaterThan)
  )

(defun greaterThan (L1 L2)
  (>(cdr L1)(cdr L2))
  )

(defun test (S L)
  (strip-results(mySort(rank S L)))
  )

;(trace test)
(print(test '(google shopify aircanada amazon) '((google shopify) (google aircanada) (amazon aircanada))))
(print(test '(google shopify amazon) '((google shopify) (shopify amazon) (amazon google))))
(print(test '(google shopify amazon indigo) '((google shopify) (shopify amazon) (amazon indigo))))
(print(test '(google shopify aircanada amazon delta) '((google shopify) (google aircanada) (amazon aircanada) (aircanada delta) (google google))))
