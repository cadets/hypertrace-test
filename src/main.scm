(import test)

(declare (uses hypertrace-test-runner))
(declare (uses hypertrace-test))

(define test-test (mk-hypertrace-test
		   '((name "Hello world")
		     (expected-out "/home/ds815/test.txt"))))

(test-group "Field tests"
	    (test "Hello world"
		  (hypertrace-test-name test-test))
	    (test "/home/ds815/test.txt"
		  (hypertrace-test-expected-out test-test)))

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

