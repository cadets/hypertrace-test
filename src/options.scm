(declare (unit hypertrace-option-parser))

(import scheme
	(chicken process-context)
	(chicken port)
	args)

(define (usage)
  (with-output-to-port (current-error-port)
    (lambda ()
      (print "Usage: " (car (argv)) " [options...]")
      (newline)
      (print (args:usage hypertrace-options))
      (print "Report bugs to <ds815@gmx.com> or <ds815@cam.ac.uk>")))
  (exit 1))

(define hypertrace-options
  (list
   (args:make-option
    (b bare)    #:none              "Bare run of the test suite"
    (display "Running tests in bare mode...\n"))
   
   (args:make-option
    (V verbose) (optional: "LEVEL") "Verbosity level [default: 1]"
    (set! arg (string->number (or arg "1"))))

   (args:make-option
    (h help) #:none                 "Display this help text"
    (usage))))

