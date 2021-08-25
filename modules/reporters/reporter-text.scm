(import scheme
        fmt
        fmt-color)

(define (generate-text-report passed failed ansi-colors?)
  ;; Report passed tests.
  (when (not (equal? passed '()))
    (if ansi-colors?
        (fmt #t (fmt-bold (fmt-green "PASSED tests"))
             nl (fmt-green (make-string 78 #\-)) nl)
        (fmt #t "PASSED tests"
             nl (make-string 78 #\-) nl))
    (for-each
     (lambda (test-p)
       (fmt #t (car test-p) ":  " (cadr test-p) nl))
     passed)
    (if ansi-colors?
        (fmt #t (fmt-green (make-string 78 #\-)) nl)
        (fmt #t (make-string 78 #\-) nl))
  
  ;; Report failed tests.
  (when (not (equal? failed '()))
    (if ansi-colors?
        (fmt #t (fmt-bold (fmt-red "FAILED tests"))
             nl (fmt-red (make-string 78 #\-)) nl)
        (fmt #t "FAILED tests"
             nl (make-string 78 #\-) nl))
    (for-each
     (lambda (test-f)
       (fmt #t (car test-f) ":  " (cadr test-f) nl))
     failed)
    (if ansi-colors?
        (fmt #t (fmt-red (make-string 78 #\-)) nl)
        (fmt #t (make-string 78 #\-) nl)))))
