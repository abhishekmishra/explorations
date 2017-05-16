#lang racket

;plotting library for 2d/3d plot procedures
(require plot)

(require "grid-sweep.rkt")

;Test if a given list of numbers are
;relative primes (i.e. they have only one
;common factor - 1)
;
;args: list of numbers (min 2)
;returns: flag indicating whether the numbers
;  are relative primes.
(define (relative-prime? . x)
  (eq? (apply gcd x) 1))

;create a list of points for all
;pairs of numbers which are relative primes
;counting upto 100.
;
;plot the numbers on a 2d graph
(plot (points
       (for/list ([xy (grid-sweep 100 2)]
                  #:when (relative-prime?
                          (car xy)
                          (cadr xy)))
         xy)
       #:sym 'dot
       #:color "black"))

;create a list of points for all
;triples of numbers which are relative primes
;counting upto 25.
;
;plot the numbers on a 3d graph
(plot3d (points3d
       (for/list ([xyz (grid-sweep 25 3)]
                  #:when (relative-prime?
                          (car xyz)
                          (cadr xyz)
                          (caddr xyz)))
         xyz)
       #:sym 'dot
       #:color "black"))
