(list
 (mk-hypertrace-test
  '((name "BEGIN probe - trace(0)")
    (in-file "begin/tracezero.sh")))
 
 (mk-hypertrace-test
  '((name "BEGIN probe - trace(curthread->td_tid)")
    (in-file "begin/trace-deref-curthread.sh")))
 
 (mk-hypertrace-test
  '((name "BEGIN probe - trace(curthread->td_proc->p_ucred->cr_uid)")
    (in-file "begin/trace-deref-curthread-multiple.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - trace D struct (non-pointer)")
    (in-file "begin/trace-deref-dstruct-np.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - trace D struct (pointer)")
    (in-file "begin/trace-deref-dstruct-p.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - trace D struct (both pointer and non-pointer)")
    (in-file "begin/trace-deref-dstruct-both.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - trace D struct (array, size 10)")
    (in-file "begin/trace-deref-dstruct-array.sh"))))
