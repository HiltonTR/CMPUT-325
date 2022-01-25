
(defun flatten (x)
    (if (null x)
        nil
        (if (atom (car x))
            (cons (car x) (flatten (cdr x)))
            (append (flatten (car x)) (flatten (cdr x))))))


(defun reached (x L)
  (let ((x (nested x L)))
  	(print(nest)))
  )


(defun nested (x L)
  (cond 
    ((equal x (cdar L)) nil)    
    ((null L) nil)
    ((equal x (caar L)) (flatten(cons (cdar L) (nested x (cdr L))))))
  )


(trace reached)
;(reached 'google '( (google shopify) (google aircanada) (amazon aircanada)))
(print(reached 'google '( (google shopify) (google aircanada) (amazon aircanada) (aircanada delta) (google google))))


