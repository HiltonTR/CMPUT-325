;Hilton Truong
;1615505
;CMPUT 325 B1
;Assignment 1
;DISCLAIMER EXAMPLES OF THE FUNCTIONS ARE TAKEN FROM THE GIVEN PAGE ON ECLASS



;QUESTION 1
(defun xcount (L)
  "This function takes a list of atoms and returns the number of atoms
   that appear in the list. The list may or may not be nested. If there
   is an occurence of nil, it is treated as an empty list.

  Example:
    (xcount '(a (a b) ((c) a))) => 5

    (xcount nil) => 0

    (xcount '(nil a b ())) => 2
   "
    (cond
      ((null L) 0) ; if the list is empty it'll return 0
      (t (+ (cond
              ((null (car L)) 0) ; checking for the case that L is nil
              ((atom (car L)) 1) ; add one if there's an atom
              (t (xcount (car L))) ; checks the nested list
              )
            (xcount (cdr L))))))


;QUESTION 2
(defun flatten (x)
  "This function takes a list x where there may be many nested lists
   and flattens the list to one level in the same order.

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


;QUESTION 3
(defun remove-duplicate (x)
  "This function takes a list and removes all the duplicated elements
   without rearranging the order.

   Example:
    (remove-duplicate '(a b c a d b)) => (c a d b)
   "
  (cond
    ((null x) nil)
    ((exists (car x) (cdr x)) (remove-duplicate (cdr x))) ; if it exists, skip over it
    (t (cons (car x) (remove-duplicate (cdr x)))))) ; if it doesn't exist add and continue

(defun exists (a L)
  "This is a helper function for remove-duplicate which ensures that the
   given atom a exists in the given lists L."
  (cond 
    ((null L) nil)
    ((equal a (car L)) L) ; if it is equal to the value in the list return the list
    (t (exists a (cdr L))))) ; continue going through the list


;QUESTION 4a
(defun zip (L1 L2)
  "This function takes two lists and merges them with their elements
   zipped in an alternating order and appends the remaining elements at the end

   Example

    (zip '(a b c) '(d e f)) => (a d b e c f)

    (zip '(1 2 3) '(a)) => (1 a 2 3)

    (zip '((a) (b c)) '(d e f g h)) => ((a) d (b c) e f g h)

    (zip '(1 2 3) nil) => (1 2 3)

    (zip '(1 2 3) '(nil)) => (1 nil 2 3)   
   "
   (cond
         ((null L1) L2)
         (t (cons (car L1) (zip L2 (cdr L1)))))) ; combines the list together with alternating atoms


;QUESTION 4b
(defun split (L)
  "This function takes a list and splits it's elements in an alternating
   pattern. The first list returns the elements at the odd positions and
   the second returns them at even positions.

   Example:
    (split '(1 2 3 4 5 6)) => ((1 3 5) (2 4 6))

    (split '((a) (b c) (d e f) g h)) => (((a) (d e f) h) ((b c) g))

    (split '()) => (nil nil) 
   "
   (cond
       ((null (car L)) (list nil nil)) ; if it's an empty list return a list of nil nil
       (t (cons (branch L) (list (branch (cdr L))))))) ; creates a nested list given list L


(defun branch (L)
  "This function is a helper function for split and creates a list for
   each of the given values"
   (cond
       ((null (car L)) nil)
       (t (cons (car L) (branch (cdr (cdr L))))))) ; adds to list for every 2nd element


;QUESTION 5
(defun allsubsets (L)
  "This function returns a list of all the possible subsets of L. The end result needs to 
   be cleaned up with remove-duplicate from above as it removes all the duplicate elements
   are created by calling the helper functions.

   Example:
    (allsubsets nil) => (nil)

    (allsubsets '(a)) => (nil (a)) 

    (allsubsets '(a b)) =>(nil (a) (b) (a b))
  "
  (if (null L) L
    (if (null (cdr L)) (list nil L) ; the only subset of L is L if there is only 1 element
      (remove-duplicate (cons L (combinations (createSubsets L L))))))) ; calls the function to generate the subset and cleans it up


(defun createSubsets (L1 L2)
  "This function is a helper function for allsubsets. It generates a list of all the possible
   number combinations from the primary function. The values can then be used to generate all
   possible combinations using combinations 

   Example:
   (createSubsets '(1 2 3) '(1 2 3)) => ((2 3) (1 3) (1 2))
   "
  (if (null (cdr L1))
  (list (deleteElement (car L1) L2)) ; remove the rest of the atoms found in the list if it is the last element
  (cons (deleteElement (car L1) L2) (createSubsets (cdr L1) L2)))) ; iterates through the list and creates n lists with each list being unique


(defun deleteElement (a L)
  "This function is a helper function for allsubsets. It deletes a given atom from a given list
   allowing create createSubsets to create a unique list."
  (cond 
    ((null L) nil)
    ((equal a (car L)) (deleteElement a (cdr L))) ; if the atom is the same remove and iterate
    (t (cons (car L) (deleteElement a (cdr L)))))) ; if atom is not the same iterate 


(defun combinations (L)
  "This function is a helper function for allsubsets. It generates all possible combinations
   of values from the given list."
  (if (null (cdr L))
    (allsubsets (car L)) ; if it is the last value append
    (zip (allsubsets (car L)) (combinations (cdr L))))) ; makes a list of the values in alternating order


;QUESTION 6a
(defun reached (x L)
  "This function takes a pair and returns all the nodes that can be reached from x from the list L. The
   return order is unimportant.

   Example:
    (reached 'google '( (google shopify) (google aircanada) (amazon aircanada))) => (SHOPIFY AIRCANADA)

    (reached 'google '( (google shopify) (shopify amazon) (amazon google) ) ) => (SHOPIFY AMAZON)

    (reached 'google '( (google shopify) (shopify amazon) (amazon indigo)  )) => (SHOPIFY AMAZON INDIGO)

    (reached 'google '( (google shopify) (google aircanada) (amazon aircanada) (aircanada delta) (google google) )) => (SHOPIFY AIRCANADA DELTA)
   "
  (deleteElement x (branch x L))) ; uses delete element from above to clean up the resulting list

(defun branch (x L)
  "This function is a help function for reached which does the computation. It goes through 
   the list and every time it finds a match, it will grab the 2nd element in the item and 
   use that as x to search through the list again to see all other elements it can reach from there.
   That will be called recursively and it will search until it finds all (or none) of the nodes it can reach."
  (cond
    ((null L) nil) ; if L is nil then nil
    ((equal x (caar L)) ; if x is equal to the first element of the first item
      (cond 
        ((equal x (cadar L)) (reached x (cdr L))) ; if the 2nd element is equal then it will call the function again skipping it, avoiding dupes
        ((null (reached (cadar L) L)) (cons (cadar L) (reached x (cdr L)))) ; if it finds a match it will recursively call it and find all possible nodes it can reach
        (t (cons (cadar L) (reached (cadar L) L))))) ; if there is no match, it will append the current element and move on 
    (t (reached x (cdr L))))) ; call the function for the rest of the list


;QUESTION 6b
(defun rank (S L)
  "This function takes a list S containing all the possible nodes and
   L which contains the paths to get to a specific node. 
   It will return the order of the node that can be accessed from
   the most locations.

   Example
    (rank '(google shopify aircanada amazon) '((google shopify) (google aircanada) (amazon aircanada))) => (AIRCANADA SHOPIFY GOOGLE AMAZON)

    (rank '(google shopify amazon) '((google shopify) (shopify amazon) (amazon google))) => (GOOGLE SHOPIFY AMAZON)

    (rank '(google shopify amazon indigo) '((google shopify) (shopify amazon) (amazon indigo))) => (SHOPIFY AMAZON INDIGO GOOGLE)

    (rank '(google shopify aircanada amazon delta) '((google shopify) (google aircanada) (amazon aircanada) (aircanada delta) (google google))) => (AIRCANADA SHOPIFY DELTA GOOGLE AMAZON)
   "
  (strip-results(mySort(lister S L)))) ; cleans up the results from the helper functions after organizing the list with the node and number of places it can be reached from

(defun strip (L)
  "This function is a helper function that takes a list L as an input
   and stripts it down to a simple list such as (a b c d) by
   taking the 2nd element of the pair."
  (cond
    ((null L) nil)
    (t (cons (cadar L) (strip (cdr L)))))) ; takes the 2nd element of the pair and makes it into a list

(defun strip-results (L)
  "This function is a helper function that takes a list L as an
   input and stripts it down to a simple list such as (a b c d) by
   taking the 1st element of the pair."
  (cond
    ((null L) nil)
    (t (cons (caar L) (strip-results (cdr L)))))) ; takes the first element of the pair then makes it into a list

(defun counter (a L)
  "This function is a helper function that counts the amount of
   times atom a appears in list L and returns the number"
  (cond
    ((null L) 0) ; if its empty then add 0
    ((equal a (car L)) (+ 1 (counter a (cdr L)))) ; add 1 if it appears in the list
    (t (counter a (cdr L))))) ; if it doesnt appear continue

(defun lister (S L)
  "This function is a helper function that lists the nodes and
   the amount of paths that can reach it."
  (cond
    ((null S) nil) ; if empty nil
    (t (cons (cons (car S) (counter (car S) (strip L))) (lister (cdr S) L))))) ; creates a nested list where the first element is the node followed by the number of nodes
                                                                               ; that can reach it with a cleaned up simplified list. It will be called recursively til the end

(defun mySort (L)
  "This function is a helper function that sorts the given list
   by largest to smallest."
  (sort L 'greaterThan))

(defun greaterThan (L1 L2)
  "This function is a helper function that helps determine which list is bigger
   and is used in mySort."
  (>(cdr L1)(cdr L2)))
