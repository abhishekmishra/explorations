#lang racket

(provide grid-sweep)

;create a grid sweep of a variable number of params
;counting from 1 to max-n for each param.
(define (grid-sweep max-n num-params)
  (define (grid-sweep-acc n acc)
    (if (eq? n 0)
        acc
        (append acc
                (apply
                 cartesian-product
                 (for/list ([param-count (range num-params)])
                   (range n))))))
  (grid-sweep-acc max-n '()))

;(display (grid-sweep 3 2))
;(newline)
;(display (grid-sweep 3 5))
;(newline)
