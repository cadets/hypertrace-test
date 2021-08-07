(declare (unit hypertrace-stager-loader))

(import scheme
        fmt
        srfi-1
        (chicken file)
        (chicken pathname)
        directory-utils)

(declare (uses hypertrace-stager))

;;
;; Checks if binary dependencies specified either as a full path (e.g. /bin/sh)
;; or just the binary name which exists in PATH (e.g. diff, find, etc.) exist
;; for a given stager.
;;
;; XXX: This might belong in util, as it really just takes a string list.
;;

(define (bindeps-satisfied? stager)
  (fold
   (lambda (dep satisfied?)
     (let ((pathname (which-command-pathname dep)))
       (if (and satisfied?
                (or (and (file-exists?     dep)
                         (file-executable? dep))
                    pathname))
           satisfied?
           (begin
             ;; Only warn on the first unsatisfied dependency.
             (when (and (>= hypertrace-test-verbosity 1)
                        satisfied?)
               (print "WARNING: '" dep "' is not satisfied for stager '"
                      (hypertrace-stager-name stager) "'. Skipping."))
             #f))))
     #t (hypertrace-stager-binary-dependencies stager)))

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

            ;;
            ;; Only load the stager if we can satisfy all of the dependencies
            ;; of the stager.
            ;;
            (if (bindeps-satisfied? stager)
                ;; Then, stage the stager and keep going.
                (begin
                  ;; Compute the absolute path of the test directory for this stager.
                  (set! (hypertrace-stager-directory-path stager)
                    (normalize-pathname (string-append
                                         hypertrace-test-dir
                                         (hypertrace-stager-directory-path stager))))
                  
                  (if (eq? '() rest)
                      (cons* stager stagers)
                      (loop (car rest)
                            (cdr rest)
                            (cons* stager stagers))))
                
                ;; Else, don't stage the stager and keep going.
                (if (eq? '() rest)
                    stagers
                    (loop (car rest)
                          (cdr rest)
                          stagers)))))))))
