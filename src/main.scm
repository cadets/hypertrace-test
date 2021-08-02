(import scheme
	(chicken process-context)
	test
	args)

(declare (uses hypertrace-test-runner))
(declare (uses hypertrace-test))
(declare (uses hypertrace-option-parser))
(declare (uses hypertrace-stager-loader))


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
		(test-error (mk-hypertrace-test '((unbound-symbol "FAIL"))))
		(test-error (mk-hypertrace-test '((name "foo")
						  (unbound-symbol "FAIL"))))
		(test-error (mk-hypertrace-test '((unbound-symbol "FAIL")
						  (name "foo")))))

    (test-group "Non-symbols"
		(test-error (mk-hypertrace-test '(("string" "FAIL"))))
		(test-error (mk-hypertrace-test '((name "foo")
						  ("string" "FAIL"))))
		(test-error (mk-hypertrace-test '(("string" "FAIL")
						  (name "foo")))))

    (test-group "Non-procedures"
		(test-error (mk-hypertrace-test '((nonproc "FAIL"))))
		(test-error (mk-hypertrace-test '((name "foo")
						  (nonproc "FAIL"))))
		(test-error (mk-hypertrace-test '((nonproc "FAIL")
						  (name "foo")))))

    (bare-run-test (mk-hypertrace-test '((name "Bare-run test"))))

    (test-group "Stager fields"
		(define test-stager (mk-hypertrace-stager '((name "Foo")
							    (test-list (1 2 3))
							    (directory-path "Bar"))))

		(test "Foo" (hypertrace-stager-name test-stager))
		(test '(1 2 3) (hypertrace-stager-test-list test-stager))
		(test "Bar" (hypertrace-stager-directory-path test-stager)))

    ;; TODO: Process the stagers further than just printing them.
    (let ((stagers (load-stagers "../libexec/hypertrace-test/tests/")))
      (for-each
       (lambda (stager)
	 (print (hypertrace-stager-name stager))
	 (print (hypertrace-stager-test-list stager))
	 (print (hypertrace-stager-directory-path stager)))
       stagers))))

(main command-line-arguments)
