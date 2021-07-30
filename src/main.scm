(import test)

(declare (uses hypertrace-test-runner))
(declare (uses hypertrace-test))


(test-group "Field tests"
	    (define test-test (mk-hypertrace-test
			       '((name "Foo")
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
		  (mk-hypertrace-test
		   '((name "foo")
		     (unbound-symbol "FAIL"))))
	    (test '(#f "Field hypertrace-test-unbound-symbol is not bound.")
		  (mk-hypertrace-test
		   '((unbound-symbol "FAIL")
		     (name "foo")))))

(test-group "Non-symbols"
	    (test '(#f "Field string is not a symbol.")
		  (mk-hypertrace-test '(("string" "FAIL"))))
	    (test '(#f "Field string is not a symbol.")
		  (mk-hypertrace-test
		   '((name "foo")
		     ("string" "FAIL"))))
	    (test '(#f "Field string is not a symbol.")
		  (mk-hypertrace-test
		   '(("string" "FAIL")
		     (name "foo")))))


(define hypertrace-test-nonproc 'non-proc)
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
