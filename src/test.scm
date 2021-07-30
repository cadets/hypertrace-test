(declare (unit hypertrace-test))

(import chicken.base)
(import srfi-1)
(import srfi-17)
(import fmt)

(import symbol-utils)

(import miscmacros)

;;
;; Record:
;;  name         : string; name of the test
;;  in-file      : string; path to input file (D script, etc)
;;  expected-out : string; path to output file to compare with
;;  cmp-method   : sexp function; function used to compare results
;;  run-method   : atom; run in 'separate-process or 'same-process?
;;
;; Note that all the fields can be #f as a nil value, which just means that
;; they are not currently set. The setters in this record are not meant to be
;; used directly. See mk-hypertrace-test below.
;;

(define-record-type hypertrace-test
  (make-hypertrace-test name in-file expected-out cmp-method run-method)
  hypertrace-test?
  (name hypertrace-test-name
	(setter hypertrace-test-name)) ;string
  
  (in-file hypertrace-test-in-file
	   (setter hypertrace-test-in-file)) ;string
  
  (expected-out hypertrace-test-expected-out
		(setter hypertrace-test-expected-out)) ;string
  
  (cmp-method hypertrace-test-cmp-method
	      (setter hypertrace-test-cmp-method)) ;sexp function
  
  (run-method hypertrace-test-run-method
	      (setter hypertrace-test-run-method)) ;(separate-process|same-process)
  )

;;
;; A function implementing a simple EDSL for test specification. Error reporting
;; could be vastly improved, but for now this is sensible enough for us to start
;; specifying tests.
;;
;; Example:
;;
;; (mk-hypertrace-test
;;  '((name "test-interesting-stuff")
;;    (in-file "/path/to/in-file")
;;    (expected-out "/path/to/expected-out")
;;    (cmp-method 'some-function)
;;    (run-method 'separate-process)))
;;
;;
;; This function can return two things:
;;   (1) A runnable test;
;;   (2) A list of two things (#f err-msg).
;;
;; The caller should take care to check these values, however if the error is
;; not handled and only the internal procedures are used to manipulate the test,
;; things will continue to behave correctly and propagate the error gracefully.
;;

(define (mk-hypertrace-test spec-list)
  (let* ((test
	  (make-hypertrace-test
	   #f #f #f 'default-cmp-method 'default-run-method))
	 (result
	  (fold
	   (lambda (spec result)
	     (let* ((field (car spec))
		    (value (cadr spec))
		    (full-field-name
		     (if (symbol? field)
			 (symbol-append 'hypertrace-test- field)
			 #f)))
	       (let/cc
		return 
		(when (eq? full-field-name #f)
		  (return
		   (list #f
			 (fmt #f
			      "Field " field " is not a symbol."))))
		(when (unbound? full-field-name)
		  (return
		   (list #f
			 (fmt #f
			      "Field " full-field-name " is not bound."))))
		(let ((proc (eval full-field-name)))
		  (when (not (procedure? proc))
		    (return
		     (list #f
			   (fmt #f
				"Field " full-field-name
				" is not a procedure in the environment."))))
		  (set! (proc test) value))
	        result)))
	   '(#t #f) spec-list)))
    (if (car result)
	test
	result)))
