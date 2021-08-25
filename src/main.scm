(import scheme
        (chicken process-context)
        (chicken pathname)
        test
        args
        srfi-1
        (hypertrace util)
        (hypertrace reporters))

(declare (uses hypertrace-util))
(declare (uses hypertrace-reporters))
(declare (uses hypertrace-test-runner))
(declare (uses hypertrace-test))
(declare (uses hypertrace-option-parser))
(declare (uses hypertrace-stager-loader))


;;
;; Global variable only used for testing error reporting of the test framework
;; itself.
;;

(define hypertrace-test-nonproc 'non-proc)


;;
;; Global variable describing the verbosity at which we will be reporting test
;; results and program actions to the user.
;;

(define hypertrace-test-verbosity 0)


;;
;; Directory containing all of the necessary HyperTrace stagers and tests.
;;

(define hypertrace-test-dir #f)


;;
;; Stager currently being processed. This variable can contain any information
;; in a stager that we wish to expose to consumers (e.g. macros or procedures).
;; Currently, it contains the directory path when loading stagers, and
;; the stager name when running tests.
;;

(define current-stager #f)


;;
;; Write report to /tmp? Default: no.
;;

(define hypertrace-test-tmp? #f)


;;
;; Default hypertrace report path.
;;

(define hypertrace-report-path #f)

;;
;; Main entry point of the program.
;;

(define (main args)
  ;;
  ;; If the user set HYPERTRACE_TESTPATH, we will use that. Otherwise, we set it
  ;; to a default value of /../libexec/hypertrace-test/tests/ assuming that both
  ;; the build path and the installed binary path will be in the correct
  ;; structure that our Makefile creates.
  ;;
  (with-environment-variable-if-not-f "HYPERTRACE_TESTPATH"
                                      (string-append
                                       (pathname-directory (executable-pathname))
                                       "/../libexec/hypertrace-test/tests/")
                                      (set! hypertrace-test-dir
                                        (get-environment-variable
                                         "HYPERTRACE_TESTPATH")))

  ;; Create a canonical path name.
  (set! hypertrace-test-dir (normalize-pathname hypertrace-test-dir))
  
  (receive (options operands)
      (args:parse (args) hypertrace-options)

    ;; Default to verbosity 1 (print all of the tests as they get executed).
    (set! hypertrace-test-verbosity
      (or (alist-ref 'verbose options) 1))

    (when (<= hypertrace-test-verbosity 0)
      (set! (current-test-verbosity) #f))
    
    (when (and (> hypertrace-test-verbosity 0)
               (alist-ref 'bare options))
      (print "Running tests in bare mode..."))

    (set! hypertrace-report-path
      (or (alist-ref 'report-path options) "hypertrace-test.report"))
    
    (set! hypertrace-test-tmp?
      (or (alist-ref 'use-tmpfs options) #f))

    (let* ((report      (alist-ref 'report options))
           (report-path hypertrace-report-path))
      (when report
        (with-loaded-contents report-path results
          (let* ((pass-and-fail
                  (fold
                   (lambda (result buckets)
                     (let ((stager (vector-ref result 0))
                           (name   (vector-ref result 1))
                           (p-or-f (vector-ref result 2)))
                       (case p-or-f
                         ;; Prepend to pass list.
                         ('pass `(,(cons `(,stager ,name) (car buckets))
                                  ,(cadr buckets)))
                         
                         ;; Prepend to fail list.
                         ('fail `(,(car buckets)
                                  ,(cons `(,stager ,name) (cadr buckets))))

                         ;; We hit some *really* weird case, so we just bail out
                         ;; of the program all together with an exit code of 1.
                         (else
                          (begin
                            (print "Expected 'pass' or 'fail', but got " p-or-f)
                            (exit 1))))))
                   (list '() '()) results))
                 (pass (car pass-and-fail))
                 (fail (cadr pass-and-fail)))
            (cond
             ((equal? report "html")  (report-html  pass fail))
             ((equal? report "json")  (report-json  pass fail))
             ((equal? report "junit") (report-junit pass fail))
             ((equal? report "text")  (report-text  pass fail ansi-support?)))
            (exit 0)))))
      
    (test-group "Field tests"
                (define test-test (mk-hypertrace-test '((name "Foo")
                                                        (expected-out "Bar"))))

                (test "Foo" (hypertrace-test-name test-test))
                (test "Bar" (hypertrace-test-expected-out test-test))
                (test #f (hypertrace-test-in-file test-test))
                (test 'default-cmp-method (hypertrace-test-cmp-method test-test))
                (test 'default-run-method (hypertrace-test-run-method test-test)))

    (test-group "Unbound inputs"
                (test-error (mk-hypertrace-test '((unbound-symbol "FAIL"))))
                (test-error (mk-hypertrace-test '((name "foo")
                                                  (unbound-symbol "FAIL"))))
                (test-error (mk-hypertrace-test '((unbound-symbol "FAIL")
                                                  (name "foo")))))

    (test-group "Non-symbols"
                (test-error (mk-hypertrace-test '(("string" "FAIL"))))
                (test-error (mk-hypertrace-test '((name "foo")
                                                  ("string" "FAIL"))))
                (test-error (mk-hypertrace-test '(("string" "FAIL")
                                                  (name "foo")))))

    (test-group "Non-procedures"
                (test-error (mk-hypertrace-test '((nonproc "FAIL"))))
                (test-error (mk-hypertrace-test '((name "foo")
                                                  (nonproc "FAIL"))))
                (test-error (mk-hypertrace-test '((nonproc "FAIL")
                                                  (name "foo")))))

    (bare-run-test (mk-hypertrace-test '((name "Bare-run test"))))

    (test-group "Stager fields"
                (define test-stager (mk-hypertrace-stager '((name "Foo")
                                                            (tests (1 2 3))
                                                            (directory-path "Bar"))))

                (test "Foo" (hypertrace-stager-name test-stager))
                (test '(1 2 3) (hypertrace-stager-tests test-stager))
                (test "Bar" (hypertrace-stager-directory-path test-stager)))

    (when (not (alist-ref 'no-stagers options))
      (let ((stagers (load-stagers hypertrace-test-dir)))
        (for-each
         (lambda (stager)
           (stage-tests stager))
         stagers)

        (let* ((runner (if (alist-ref 'bare options)
                           bare-run-test
                           run-test))
               (result (flatten (fold
                                 (lambda (stager result)
                                   (cons* (stager-run stager runner) result))
                                 '() stagers)))
               (report-file (if hypertrace-test-tmp?
                                "/tmp/hypertrace-test.report"
                                "hypertrace-test.report")))
          
          ;; Print a newline after we're done with all the stagers.
          (display "\n")
          (call-with-output-file report-file
            (lambda (port)
              (write result port)
              (when (>= hypertrace-test-verbosity 2)
                (print "Written report to " report-file)))
            #:binary))))))

(main command-line-arguments)
