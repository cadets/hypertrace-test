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
  '((name "BEGIN probe - uregs")
    (in-file "begin/uregs.sh")))
 
 (mk-hypertrace-test
  '((name "BEGIN probe - curthread")
    (in-file "begin/curthread.sh")))
 
 (mk-hypertrace-test
  '((name "BEGIN probe - timestamp")
    (in-file "begin/timestamp.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - vtimestamp")
    (in-file "begin/vtimestamp.sh")))
 
 (mk-hypertrace-test
  '((name "BEGIN probe - ipl")
    (in-file "begin/ipl.sh")))
 
 (mk-hypertrace-test
  '((name "BEGIN probe - epid")
    (in-file "begin/epid.sh")))
 
 (mk-hypertrace-test
  '((name "BEGIN probe - id")
    (in-file "begin/id.sh")))
 
 (mk-hypertrace-test
  '((name "BEGIN probe - stackdepth")
    (in-file "begin/stackdepth.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - caller")
    (in-file "begin/caller.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - probeprov")
    (in-file "begin/probeprov.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - probemod")
    (in-file "begin/probemod.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - probefunc")
    (in-file "begin/probefunc.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - probename")
    (in-file "begin/probename.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - pid")
    (in-file "begin/pid.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - tid")
    (in-file "begin/tid.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - execname")
    (in-file "begin/execname.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - zonename")
    (in-file "begin/zonename.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - walltimestamp")
    (in-file "begin/walltimestamp.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - ustackdepth")
    (in-file "begin/ustackdepth.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - ucaller")
    (in-file "begin/ucaller.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - ppid")
    (in-file "begin/ppid.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - uid")
    (in-file "begin/uid.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - gid")
    (in-file "begin/gid.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - errno")
    (in-file "begin/errno.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - execargs")
    (in-file "begin/execargs.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - jid")
    (in-file "begin/jid.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - jailname")
    (in-file "begin/jailname.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - vmname")
    (in-file "begin/vmname.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - cpu")
    (in-file "begin/cpu.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - x = 0xDEADBEEF")
    (in-file "begin/global-var.sh"))))

