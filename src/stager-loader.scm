(declare (unit hypertrace-stager-loader))

(import scheme
        fmt
        srfi-1
        (chicken file)
        (chicken pathname))

(declare (uses hypertrace-stager))


;;
;; This procedure takes a path and loads all of the *.scm files present in that
;; directory. It then loads what it assumes to be an expression of form
;; (mk-hypertrace-stager ...) and loads it into the runtime of the test
;; framework as a stager record.
;;
;; NOTE: It doesn't actually have to be (mk-hypertrace-stager ...). In fact, it
;; can be any valid scheme code, as long as calling (eval ...) on the file
;; returns a hypertrace-stager record.
;;

(define (load-stagers path)
  (when (not (directory-exists? path))
    (list #f (fmt #f path " is not a valid directory.")))
  
  (let ((stager-files (glob (string-append path "*.scm"))))
    (let loop ((stager-file (car stager-files))
               (rest (cdr stager-files))
               (stagers (list)))
      (when (and (file-exists? stager-file)
                 (file-readable? stager-file))
        (let ((loaded-contents #f))
          (when (>= hypertrace-test-verbosity 2)
            (print "Loading  " stager-file))
          
          (load stager-file (lambda (x) (set! loaded-contents x)))
          (let ((stager (eval loaded-contents)))
            ;; Make sure we're loading an actual stager.
            (when (not (hypertrace-stager? stager))
              (print "Expected a stager, but got: " loaded-contents)
              (exit 1))
            
            ;; Compute the absolute path of the test directory for this stager.
            (set! (hypertrace-stager-directory-path stager)
              (normalize-pathname (string-append
                                   hypertrace-test-dir
                                   (hypertrace-stager-directory-path stager))))
            
            (if (eq? '() rest)
                (cons* stager stagers)
                (loop (car rest)
                      (cdr rest)
                      (cons* stager stagers)))))))))
