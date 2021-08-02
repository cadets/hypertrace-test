(declare (unit hypertrace-option-parser))

(import scheme
	args)

(define hypertrace-options
  (list
   (args:make-option
    (b bare)    #:none              "bare run of tests"
    (display "Running tests in bare mode...\n"))
   
   (args:make-option
    (V verbose) (optional: "LEVEL") "verbosity level [default: 1]"
    (set! arg (string->number (or arg "1"))))))

