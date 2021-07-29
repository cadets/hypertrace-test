(declare (unit hypertrace-test-runner))

(declare (uses hypertrace-test))

(import scheme)
(import chicken.base)
(import chicken.io)
(import chicken.string)

(import srfi-1)

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
