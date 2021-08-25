(declare (unit hypertrace-stager))

(import scheme
        test
        fmt
        fmt-color
        (chicken pathname)
        (chicken file)
        (hypertrace util))

(import-for-syntax (chicken file))

;;
;; Record:
;;  name                : string; name of stager
;;  tests               : list; list of staged tests
;;  directory-path      : string; relative path to test directory
;;  binary-dependencies : list; list of binary dependencies (e.g. /bin/sh)
;;

(define-record-type hypertrace-stager
  (make-hypertrace-stager name tests directory-path binary-dependencies)
  hypertrace-stager?
  (name hypertrace-stager-name
        (setter hypertrace-stager-name)) ;string

  (tests hypertrace-stager-tests
         (setter hypertrace-stager-tests)) ;list

  (directory-path hypertrace-stager-directory-path
                  (setter hypertrace-stager-directory-path)) ;string

  (binary-dependencies hypertrace-stager-binary-dependencies
                       (setter hypertrace-stager-binary-dependencies)) ;list
  )


;;
;; Stages a test into a stager.
;;

(define (stage stager test)
  (set! (hypertrace-stager-tests stager)
    (cons test (hypertrace-stager-tests stager))))


;;
;; The stage-tests procedure goes through each of the *.scm files in 'path'. For
;; each file it encounters, it loads it into the current environment as a quoted
;; expression. The expectation is that tests are specified using
;; mk-hypertrace-test and will return a hypertrace-test record once 'eval' is
;; called on the loaded expression. See the 'test/' directory in the root
;; checkout of this repository for sample tests. Note that each *.scm file can
;; also contain a list of tests, not just one test.
;;
;; NOTE: It doesn't actually have to be (mk-hypertrace-test ...). In fact, it
;; can be any valid scheme code, as long as calling (eval ...) on the file
;; returns a hypertrace-test record.
;;

(define (stage-tests stager)
  ;; Set the currently running stager. We might want to change this later.
  (set! current-stager (hypertrace-stager-directory-path stager))
  
  (let ((path (hypertrace-stager-directory-path stager)))
    (when (not (directory-exists? path))
      (print path " is not a valid directory."))

    (let* ((test-files (glob (string-append path "*.scm"))))
      (for-each
       (lambda (test-file)
         (when (and (file-exists?   test-file)
                    (file-readable? test-file))
           (with-loaded-contents test-file loaded-contents
             (when (>= hypertrace-test-verbosity 2)
               (print "Staging  " test-file))

             (with-item loaded-contents test
               (when (not (hypertrace-test? test))
                 (print "Expected #<hypertrace-test> record, but got: " test)
                 (exit 1))

               ;; Normalize the in-file path and make it absolute if needed.
               (set! (hypertrace-test-in-file test)
                 (normalize-pathname
                  (if (absolute-pathname? (hypertrace-test-in-file test))
                      (hypertrace-test-in-file test)
                      (string-append (hypertrace-stager-directory-path stager)
                                     (hypertrace-test-in-file test)))))

               ;; Normalize expected-out path and make it absolute if needed.
               (when (not (equal? (hypertrace-test-expected-out test) #f))
                 (set! (hypertrace-test-expected-out test)
                   (normalize-pathname
                    (if (absolute-pathname? (hypertrace-test-expected-out test))
                        (hypertrace-test-expected-out test)
                        (string-append (hypertrace-stager-directory-path stager)
                                       (hypertrace-test-expected-out test))))))

               ;;
               ;; In case that we can both read and execute the in-file (a shell
               ;; script or something similar), and we can read the expected-out
               ;; file, we simply stage the test for execution. However, in the
               ;; case that one of these things is not true, we need to do some
               ;; error reporting to the user in order to have a user-friendly
               ;; error *before* we start executing any staged tests that
               ;; something has gone wrong in the setup.
               ;;
               (if (and (file-exists?               (hypertrace-test-in-file test))
                        (file-executable?           (hypertrace-test-in-file test))
                        (or  (equal? #f             (hypertrace-test-expected-out test))
                             (and (file-exists?     (hypertrace-test-expected-out test))
                                  (file-readable?   (hypertrace-test-expected-out test)))))
                   ;; If we can execute this test, stage it.
                   (stage stager test)
                   (begin
                     ;; in-file does not exist.
                     (when (not (file-exists? (hypertrace-test-in-file test)))
                       (print "ERROR: File " (hypertrace-test-in-file test)
                              " does not exist. Exiting.")
                       (exit 1))

                     ;; in-file is not executable.
                     (when (not (file-executable?
                                 (hypertrace-test-in-file test)))
                       (print "ERROR: Cannot execute "
                              (hypertrace-test-in-file test) ". Exiting.")
                       (exit 1))

                     ;; expected-out does not exist.
                     (when (not (file-exists?
                                 (hypertrace-test-expected-out test)))
                       (print "ERROR: File " (hypertrace-test-expected-out test)
                              " does not exist. Exiting.")
                       (exit 1))

                     ;; expected-out is not readable.
                     (when (not (file-readable?
                                 (hypertrace-test-expected-out test)))
                       (print "ERROR: Cannot read "
                              (hypertrace-test-expected-out test) ". Exiting.")
                       (exit 1))))))))
       test-files))))



;;
;; Run all of the staged tests in a particular stager with a specific
;; runner procedure. By default, this is 'run-test'.
;;

(define (stager-run stager runner)
  ;; Pass the stager name down with current-stager.
  (set! current-stager (hypertrace-stager-name stager))

  ;; Report the current stager.
  (fmt #t
       nl (fmt-bold
           (fmt-underline
            (hypertrace-stager-name stager)))
       nl (make-string 78 #\-) nl)

  ;; Run all of the staged tests for the current stager.
  (for-each
   (lambda (test)
     (runner test))
   (hypertrace-stager-tests stager)))


;;
;; Make a HyperTrace stager record initializer out of the record with the
;; following default values:
;;  name                : #f
;;  tests               : empty list
;;  directory-path      : #f
;;  binary-dependencies : empty list
;;

(make-record 'hypertrace-stager '(#f (list) #f (list)))
