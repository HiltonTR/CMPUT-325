1. [1 mark] Reduce the following λ-expression to its normal form. Show two sequences
of reductions, one of which is based on normal order reduction and the other based on
applicative order reduction. Show all the reduction steps.
(λxy | xx(yy)) (λx | xy) (λx | x)

Normal Order (outermost first)
(Lxy | xx(yy)) (Lx | xy) x
(Lxy | xx) (Lx | xy)
xyxy 
xxyy

Applicative order (innermost first)
(Lxy | xx(yy)) (Lx | xy) x
(Lxy | xxyy) xy
xxyy



2. [1.5 marks] Recall in lambda calculus, logic connectives NOT and OR can be defined as:
NOT = (λx | xF T) OR = (λxy | xT y)
where T = (λxy | x) and F = (λxy | y).
In logic, that “x implies y” is written x ⊃ y (or in some textbooks, x → y or x ⇒ y).
Denote this function by IMP
(a) Give a lambda expression that defines IMP, i.e., write what is missing at the right hand
side of the vertical bar below.
IMP = (λxy | ......)
Make sure that your answer is a normal form, i.e., it cannot contain expressions that are
still reducible.
Hint: In logic, we know x ⊃ y ≡ ¬x ∨ y.

IMP = (λxy | xF y)


(b) Using your definition, for each expression below, reduce it to a normal form. Here, the
order of reduction is unimportant.
- IMP T F

(λxy | xF y) T F
(λx | (λy | xF y)) T F
(λy | F y) T
T

- IMP F T

(λxy | xF y) F T
(λx | (λy | xF y)) F T
(λy | F y) F
F




3. [1.5 marks] In this question, we consider the interpreter based on context and closure.
Notationally, we will use {x1 → v1, ..., xm → vm} for context and [F n, CT] for closure,
where F n is a lambda function and CT is a context. We assume that the initial context is
CT0.
Consider the following λ-expression:
(((lambda (x y) (lambda (z) (if (> x y) (+ x z) (+ x y)))) 4 5) 10)
 What is the result of evaluating this expression?
 What is the last context created during this evaluation? Please provide some sketches
of how you arrived at your answer.

(((Lx | (Ly | (Lz | (if (> x y) (+ x z) (+ x y))))) 4 5) 10) 
(Ly | (Lz | (if (> 10 y) (+ 10 z) (+ 10 y))) 4 5)
((Lz | (if (> 10 5) (+ 10 z) (+ 10 5))) 4)
(if (> 10 5) (+ 10 4) (+ 10 5))
(if (T) (14) (15))
14