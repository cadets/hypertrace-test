(declare (unit hypertrace-edsl))

(import chicken.base
	srfi-1
	srfi-17
	fmt

	symbol-utils)

;;
;; A simple wrapper around make-record-initializer that creates the procedure
;; with a given name for the caller. This is probably the procedure that you
;; want to call, unless you have a need for a quoted expression that
;; make-record-initializer returns.
;;

(define (make-record rec default)
  (eval (make-record-initializer rec default)))


;;
;; A procedure implementing a simple EDSL for record specification. Error
;; reporting could be vastly improved, but for now this is sensible enough
;; for us to start specifying various record initializers.
;;
;; An example of using a record created by the record initializer might be:
;;
;; (mk-hypertrace-test
;;  '((name "test-interesting-stuff")
;;    (in-file "/path/to/in-file")
;;    (expected-out "/path/to/expected-out")
;;    (cmp-method 'some-function)
;;    (run-method 'separate-process)))
;;
;; -- see src/test.scm
;;
;; Errors in the procedures generated by this procedure are not checked.
;; Instead, they are delegated to the error reporting of libchicken itself,
;; which is far more verbose and correct than any manual checks here. It also
;; keeps this procedure simple.
;;
;; Note that procedures generated by this procedure also accept arbitrary
;; procedures and will pass an argument that the field needs to be set to into
;; those procedures. If you wish to create an out-of-bound setter that
;; manipulates the arguments further, you can define a procedure called
;; rec-foo and pass in (foo "...") as one of the arguments. The end result is
;; that your procedure will get called, and you can extend the interface as
;; you wish.
;;

(define (make-record-initializer rec default)
  `(define (,(symbol-append 'mk- rec) spec-list)
     (let ((entry
	    (,(symbol-append 'make- rec) ,@default)))
       (for-each
	(lambda (spec)
	  (let* ((field (car spec))
		 (value (cadr spec))
		 (full-field-name
		  (if (symbol? field)
		      (,symbol-append
		       (,symbol-append (,->symbol ,rec) '-) field)
		      #f))
		 (proc (eval full-field-name)))
	    (set! (proc entry) value)))
	spec-list)
       entry)))
