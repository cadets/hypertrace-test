(declare (unit hypertrace-option-parser))

(import scheme
        (chicken process-context)
        (chicken port)
        args)

;;
;; Display usage information about command-line options. These messages are
;; generated from hypertrace-options.
;;

(define (usage)
  (with-output-to-port (current-error-port)
    (lambda ()
      (print "Usage: " (car (argv)) " [options...]")
      (newline)
      (print (args:usage hypertrace-options))
      (print "Report bugs to <ds815@gmx.com> or <ds815@cam.ac.uk>")))
  (exit 1))

;;
;; Command line option parser.
;;
;; NOTE: When adding options, every option should have a long version, while
;; the short version of the command line option is optional.
;;

(define hypertrace-options
  (list
   (args:make-option
    (b bare)        #:none
    "Bare run of the test suite")
   
   (args:make-option
    (V verbose)  (optional: "LEVEL")
    "Verbosity level [default: 1]"
    (set! arg (string->number (or arg "1"))))

   (args:make-option
    (no-stagers)    #:none
    "Don't import any stagers.")

   (args:make-option
    (use-tmpfs)     #:none
    "Use tmpfs to save the report.")

   (args:make-option
    (R report)      (optional: "html|json|junit|text")
    "Report results from a previous run (default: text)."
    (set! arg (or arg "text")))

   (args:make-option
    (p report-path) (optional: "PATH")
    "Path to the report file."
    (set! arg (or arg "hypertrace-test.report")))

   (args:make-option
    (h help)        #:none
    "Display this help text"
    (usage))))

