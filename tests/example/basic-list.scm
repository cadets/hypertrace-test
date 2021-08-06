(list
 (mk-hypertrace-test
  '((name "example test")
    (in-file "basic/basic.sh")
    (expected-out "basic/basic.sh.out")))

 (mk-hypertrace-test
  '((name "example test two")
    (in-file "basic/basic2.sh"))))
