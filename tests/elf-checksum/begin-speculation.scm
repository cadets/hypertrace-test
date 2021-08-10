(list
 (mk-hypertrace-test
  '((name "BEGIN probe - create speculation")
    (in-file "begin/spec-create.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - speculate")
    (in-file "begin/spec-speculate.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - commit speculation")
    (in-file "begin/spec-commit.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - discard speculation")
    (in-file "begin/spec-discard.sh"))))
