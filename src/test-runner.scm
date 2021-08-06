(declare (unit hypertrace-test-runner))

(declare (uses hypertrace-test))

(import scheme
        
        (chicken base)
        (chicken io)
        (chicken string)
        (chicken process)
        
        srfi-1
        
        test)

;;
;; Reads a file line by line and returns a string with the contents
;; of that file.
;;

(define (read-test-file filepath)
  (let ((fh (open-input-file filepath)))
    ;;
    ;; Annoyingly, we have to do this manually instead of just using a procedure
    ;; called reverse-string-append because we need to plug in a cdr in there
    ;; in order to avoid a leading '\n' in our string. It however, is not too
    ;; bad.
    ;;
    (apply string-append
           (cdr
            (reverse
             (let loop ((c (read-line fh))
                        (lines (list)))
               (if (eof-object? c)
                   (begin
                     (close-input-port fh)
                     lines)
                   (loop (read-line fh) (cons* c "\n" lines)))))))))


;;
;; Do a bare run of a test. This is simply used to check that the test is
;; sensibly specified within a certain test suite and can be used on any
;; operating system. Running actual tests requires HyperTrace to be working
;; and thus can't be run on just any machine.
;;

(define (bare-run-test test)
  (let* ((name         (hypertrace-test-name test))
         (in-file      (hypertrace-test-in-file test))
         (expected-out (hypertrace-test-expected-out test))
         (cmp-method   (hypertrace-test-cmp-method test))
         (run-method   (hypertrace-test-run-method test)))
    (test-assert name #t)))


;;
;; Runs a test specified as a hypertrace-test record. We currently don't really
;; do anything with run-method and cmp-method, but it remains an option. When it
;; comes to run-method, we default to 'separate-process, which is what this
;; procedure currently does.
;;
;; TODO: Actually support different run-method and cmp-method.
;;

(define (run-test test-to-run)
  (let* ((name         (hypertrace-test-name test-to-run))
         (in-file      (hypertrace-test-in-file test-to-run))
         (expected-out (hypertrace-test-expected-out test-to-run))
         (cmp-method   (hypertrace-test-cmp-method test-to-run))
         (run-method   (hypertrace-test-run-method test-to-run))
         (expected-str (read-test-file expected-out)))
    ;; Spawn the process and grab its ports.
    (receive (stdout stdin pid stderr) (process* in-file)
      ;; Wait for the process to end.
      (receive (exit-pid success? status) (process-wait pid)
        ;;
        ;; If we get an exit of a pid that we weren't waiting for, this is
        ;; probably a bug in the library. We just want to hard fail here and
        ;; report a bug...
        ;;
        (when (not (= pid exit-pid))
          (print "ERROR: Waited on " pid " but got " exit-pid ". Exiting.")
          (exit 1))
        
        (if (not success?)
            ;; Fail the test and report and error if verbosity is >= 2.
            (begin
              (when (>= hypertrace-test-verbosity 2)
                (print "ERROR: Child process exited with exit code: " status)
                (let ((errors (read-buffered stderr)))
                  (when (not (equal? errors ""))
                    (print "stderr (" in-file "): " errors))))
              (test-assert name #f))
            
            ;; Check the process stdout with our expected output.
            (let ((contents (read-line stdout))
                  (errors   (read-buffered stderr)))
              (begin
                (test name expected-str contents)
                (when (and (>= hypertrace-test-verbosity 2)
                           (not (equal? errors "")))
                  (print "stderr (" in-file "): " errors)))))))))
