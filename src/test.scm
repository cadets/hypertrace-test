(declare (unit hypertrace-test))
(declare (uses hypertrace-edsl))

(import chicken.base
	srfi-1
	srfi-17
	fmt)

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
;; Make a HyperTrace test record initializer out of the record with the
;; following default values:
;;  name         : #f
;;  in-file      : #f
;;  expected-out : #f
;;  cmp-method   : 'default-cmp-method
;;  run-method   : 'default-run-method
;;

(make-record
 'hypertrace-test
 '(#f #f #f 'default-cmp-method 'default-run-method))

