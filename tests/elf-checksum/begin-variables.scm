(list
 (mk-hypertrace-test
  '((name "BEGIN probe - global/thread-local/clause-local")
    (in-file "begin/threevars.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - self->x = 0xDEADBEEF")
    (in-file "begin/thread-local-var.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - this->x = 0xDEADBEEF")
    (in-file "begin/clause-local-var.sh")))
 
 (mk-hypertrace-test
  '((name "BEGIN probe - x[0] = 0xDEADBEEF")
    (in-file "begin/global-array.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - self->x[0] = 0xDEADBEEF")
    (in-file "begin/thread-local-array.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - x = 0xDEADBEEF")
    (in-file "begin/global-var.sh"))))

