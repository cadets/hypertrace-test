(import scheme
	(chicken process-context)
	test
	args)

(declare (uses hypertrace-test-runner))
(declare (uses hypertrace-test))
(declare (uses hypertrace-option-parser))


;;
;; Global variable only used for testing error reporting of the test framework
;; itself.
;;

(define hypertrace-test-nonproc 'non-proc)


;;
;; Global variable describing the verbosity at which we will be reporting test
;; results and program actions to the user.
;;

(define hypertrace-test-verbosity 0)


;;
;; Main entry point of the program.
;;

(define (main args)
  (receive (options operands)
      (args:parse (args) hypertrace-options)

    (set! hypertrace-test-verbosity
      (or (alist-ref 'verbose options) 0))

    (when (<= hypertrace-test-verbosity 0)
      (set! (current-test-verbosity) #f))
				     
    (when (and (> hypertrace-test-verbosity 0)
	       (alist-ref 'bare options))
      (print "Running tests in bare mode..."))

    (test-group "Field tests"
		(define test-test (mk-hypertrace-test '((name "Foo")
							(expected-out "Bar"))))

		(test "Foo" (hypertrace-test-name test-test))
		(test "Bar" (hypertrace-test-expected-out test-test))
		(test #f (hypertrace-test-in-file test-test))
		(test 'default-cmp-method (hypertrace-test-cmp-method test-test))
		(test 'default-run-method (hypertrace-test-run-method test-test)))

    (test-group "Unbound inputs"
		(test '(#f "Field hypertrace-test-unbound-symbol is not bound.")
		      (mk-hypertrace-test '((unbound-symbol "FAIL"))))
		(test '(#f "Field hypertrace-test-unbound-symbol is not bound.")
		      (mk-hypertrace-test '((name "foo")
					    (unbound-symbol "FAIL"))))
		(test '(#f "Field hypertrace-test-unbound-symbol is not bound.")
		      (mk-hypertrace-test '((unbound-symbol "FAIL")
					    (name "foo")))))

    (test-group "Non-symbols"
		(test '(#f "Field string is not a symbol.")
		      (mk-hypertrace-test '(("string" "FAIL"))))
		(test '(#f "Field string is not a symbol.")
		      (mk-hypertrace-test '((name "foo")
					    ("string" "FAIL"))))
		(test '(#f "Field string is not a symbol.")
		      (mk-hypertrace-test '(("string" "FAIL")
					    (name "foo")))))


    (test-group "Non-procedures"
		(test `(#f ,(eval (string-append "Field hypertrace-test-nonproc is "
						 "not a procedure in the environment.")))
		      (mk-hypertrace-test '((nonproc "FAIL"))))
		(test `(#f ,(eval (string-append "Field hypertrace-test-nonproc is "
						 "not a procedure in the environment.")))
		      (mk-hypertrace-test '((name "foo")
					    (nonproc "FAIL"))))
		(test `(#f ,(eval (string-append "Field hypertrace-test-nonproc is "
						 "not a procedure in the environment.")))
		      (mk-hypertrace-test '((nonproc "FAIL")
					    (name "foo")))))

    (bare-run-test (mk-hypertrace-test '((name "Bare-run test"))))))

(main command-line-arguments)
