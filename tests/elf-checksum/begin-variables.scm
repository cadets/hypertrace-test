(list
 (mk-hypertrace-test
  '((name "BEGIN probe - self->x = 0xDEADBEEF")
    (in-file "begin/thread-local-var.sh")))

 (mk-hypertrace-test
 '((name "BEGIN probe - x = 0xDEADBEEF")
   (in-file "begin/global-var.sh"))))

