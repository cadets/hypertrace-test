(declare (unit hypertrace-test-runner))

(declare (uses hypertrace-test))

(import scheme
	
	(chicken base)
	(chicken io)
	(chicken string)
	
	srfi-1
	
	test)

;;
;; Reads a file line by line and returns a string with the contents
;; of that file.
;;

(define (read-test-file filepath)
  (let ((fh (open-input-file filepath)))
    (reverse-string-append
     (let loop ((c (read-line fh))
		(lines (list)))
       (if (eof-object? c)
	   (begin
	     (close-input-port fh)
	     lines)
	   (loop (read-line fh) (cons* c "\n" lines)))))))


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
;; TODO(dstolfa):
;; Runs a test specified as a hypertrace-test record.
;;

(define (run-test test)
  (let* ((name         (hypertrace-test-name test))
	 (in-file      (hypertrace-test-in-file test))
	 (expected-out (hypertrace-test-expected-out test))
	 (cmp-method   (hypertrace-test-cmp-method test))
	 (run-method   (hypertrace-test-run-method test))
	 (expected-str (read-test-file expected-out)))
    (print expected-str)))
