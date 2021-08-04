(declare (unit hypertrace-stager-loader))

(import scheme
	fmt
	srfi-1
	(chicken file)
	(chicken pathname))

(declare (uses hypertrace-stager))


;;
;; This procedure takes a (relative) path and loads all of the *.scm files
;; present in that directory. It then loads what it assumes to be an expression
;; of form (mk-hypertrace-stager ...) and loads it into the runtime of the test
;; framework as a stager record.
;;

(define (load-stagers rel-path)
  (when (not (directory-exists? rel-path))
    (list #f (fmt #f rel-path " is not a valid directory.")))
  
  (let ((stager-files (glob (string-append rel-path "*.scm"))))
    (let loop ((stager-file (car stager-files))
	       (rest (cdr stager-files))
	       (stagers (list)))
      (when (and (file-exists? stager-file)
		 (file-readable? stager-file))
	(let ((loaded-contents #f))
	  (load stager-file (lambda (x) (set! loaded-contents x)))
	  (let ((stager (eval loaded-contents)))
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
