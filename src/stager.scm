(declare (unit hypertrace-stager))

(import scheme
	(chicken file))

;;
;; Record:
;;  name           : string; name of stager
;;  test-list      : list; list of staged tests
;;  directory-path : string; relative path to test directory
;;

(define-record-type hypertrace-stager
  (make-hypertrace-stager name test-list directory-path)
  hypertrace-stager?
  (name hypertrace-stager-name
	(setter hypertrace-stager-name)) ;string

  (test-list hypertrace-stager-test-list
	     (setter hypertrace-stager-test-list)) ;list

  (directory-path hypertrace-stager-directory-path
		  (setter hypertrace-stager-directory-path)) ;string
  )


;;
;; Stages a test into a stager.
;;

(define (stage stager test)
  (set! (hypertrace-stager-test-list stager)
    (cons test (hypertrace-stager-tests stager))))


;;
;; The stage-tests procedure goes through each of the *.scm files in 'path'. For
;; each file it encounters, it loads it into the current environment as a quoted
;; expression. The expectation is that tests are specified using
;; mk-hypertrace-test and will return a hypertrace-test record once 'eval' is
;; called on the loaded expression. See the 'test/' directory in the root
;; checkout of this repository for sample tests.
;;
;; NOTE: It doesn't actually have to be (mk-hypertrace-test ...). In fact, it
;; can be any valid scheme code, as long as calling (eval ...) on the file
;; returns a hypertrace-test record.
;;

(define (stage-tests stager)
  (let ((path (hypertrace-stager-directory-path stager)))
    (when (not (directory-exists? path))
      (print path " is not a valid directory."))

    (let* ((test-files (glob (string-append path "*.scm"))))
      (for-each
       (lambda (test-file)
	 (when (and (file-exists?   test-file)
		    (file-readable? test-file))
	   (let ((loaded-contents #f))
	     (load test-file (lambda (x) (set! loaded-contents x)))
	     (when (>= hypertrace-test-verbosity 2)
	       (print "Staging " test-file))
	     (stage stager (eval loaded-contents)))))
       test-files))))


;;
;; Make a HyperTrace stager record initializer out of the record with the
;; following default values:
;;  name           : #f
;;  test-list      : empty list
;;  directory-path : #f
;;

(make-record 'hypertrace-stager '(#f (list) #f))
