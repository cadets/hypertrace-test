(list
 (mk-hypertrace-test
  '((name "BEGIN probe - rand()")
    (in-file "begin/subr-rand.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - mutex_owned()")
    (in-file "begin/subr-mutex-owned.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - mutex_owner()")
    (in-file "begin/subr-mutex-owner.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - mutex_type_adaptive()")
    (in-file "begin/subr-mutex-type-adaptive.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - mutex_type_spin()")
    (in-file "begin/subr-mutex-type-spin.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - rw_read_held()")
    (in-file "begin/subr-rw-read-held.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - rw_write_held()")
    (in-file "begin/subr-rw-write-held.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - rw_iswriter()")
    (in-file "begin/subr-rw-iswriter.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - copyin()")
    (in-file "begin/subr-copyin.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - copyinstr()")
    (in-file "begin/subr-copyinstr.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - progenyof()")
    (in-file "begin/subr-progenyof.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - strlen()")
    (in-file "begin/subr-strlen.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - copyout()")
    (in-file "begin/subr-copyout.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - copyoutstr()")
    (in-file "begin/subr-copyoutstr.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - alloca()")
    (in-file "begin/subr-alloca.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - bcopy()")
    (in-file "begin/subr-bcopy.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - copyinto()")
    (in-file "begin/subr-copyinto.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - ddi_pathname()")
    (in-file "begin/subr-ddi-pathname.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - strjoin()")
    (in-file "begin/subr-strjoin.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - lltostr()")
    (in-file "begin/subr-lltostr.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - basename()")
    (in-file "begin/subr-basename.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - dirname()")
    (in-file "begin/subr-dirname.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - cleanpath()")
    (in-file "begin/subr-cleanpath.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - strchr()")
    (in-file "begin/subr-strchr.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - strrchr()")
    (in-file "begin/subr-strrchr.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - strstr()")
    (in-file "begin/subr-strstr.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - strtok()")
    (in-file "begin/subr-strtok.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - substr()")
    (in-file "begin/subr-substr.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - index()")
    (in-file "begin/subr-index.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - rindex()")
    (in-file "begin/subr-rindex.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - htons()")
    (in-file "begin/subr-htons.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - htonl()")
    (in-file "begin/subr-htonl.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - htonll()")
    (in-file "begin/subr-htonll.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - ntohs()")
    (in-file "begin/subr-ntohs.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - ntohl()")
    (in-file "begin/subr-ntohl.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - ntohll()")
    (in-file "begin/subr-ntohll.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - inet_ntop()")
    (in-file "begin/subr-inet-ntop.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - inet_ntoa()")
    (in-file "begin/subr-inet-ntoa.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - inet_ntoa6()")
    (in-file "begin/subr-inet-ntoa6.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - toupper()")
    (in-file "begin/subr-toupper.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - tolower()")
    (in-file "begin/subr-tolower.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - memref()")
    (in-file "begin/subr-memref.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - sx_shared_held()")
    (in-file "begin/subr-sx-shared-held.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - sx_exclusive_held()")
    (in-file "begin/subr-sx-exclusive-held.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - sx_isexclusive()")
    (in-file "begin/subr-sx-isexclusive.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - memstr()")
    (in-file "begin/subr-memstr.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - getf()")
    (in-file "begin/subr-getf.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - json()")
    (in-file "begin/subr-json.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - strtoll()")
    (in-file "begin/subr-strtoll.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - random()")
    (in-file "begin/subr-random.sh")))

 (mk-hypertrace-test
  '((name "BEGIN probe - ptinfo()")
    (in-file "begin/subr-ptinfo.sh"))))
