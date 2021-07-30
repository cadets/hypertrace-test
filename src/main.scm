(import test)

(declare (uses hypertrace-test-runner))
(declare (uses hypertrace-test))

(define test-test (mk-hypertrace-test
		   '((name "Foo")
		     (expected-out "Bar"))))

(test-group "Field tests"
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

