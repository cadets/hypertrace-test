(import scheme
        fmt
        fmt-color
        srfi-1)

(define (generate-text-report passed failed ansi-colors?)
  ;; Report passed tests.
  (when (not (equal? passed '()))
    (if ansi-colors?
        (fmt #t (fmt-bold (fmt-green "PASSED tests"))
             nl (fmt-green (make-string 78 #\-)) nl)
        (fmt #t "PASSED tests"
             nl (make-string 78 #\-) nl)))

  ;;
  ;; Traverse the passed tests, reporting each one and accumulating the time
  ;; spent. If passed is '(), we won't actually do anything here.
  ;;
  (let ((passed-time
         (fold
          (lambda (test-p total-time)
            (let ((stager (car test-p))
                  (test   (cadr test-p))
                  (time   (caddr test-p)))
              (fmt #t stager ":  " test " [  " time "s  ]" nl)
              (+ time total-time)))
          0 passed)))

    ;; Only print the time spent if we actually have tests that passed.
    (when (not (equal? passed '()))
      (if ansi-colors?
          (fmt #t (fmt-green (make-string 78 #\-)) nl
               (fmt-green "[PASSED]  ") "Time spent:  " passed-time "s" nl)
          (fmt #t (make-string 78 #\-) nl
               "[PASSED]  Time spent:  " passed-time "s" nl)))
    
    ;; Report failed tests.
    (when (not (equal? failed '()))
      (if ansi-colors?
          (fmt #t (fmt-bold (fmt-red "FAILED tests"))
               nl (fmt-red (make-string 78 #\-)) nl)
          (fmt #t "FAILED tests"
               nl (make-string 78 #\-) nl)))

    ;;
    ;; Traverse the failed tests, reporting each one and accumulating the time
    ;; spent. If failed is '(), we won't actually do anything here.
    ;;
    (let ((failed-time
           (fold
            (lambda (test-f total-time)
              (let ((stager (car test-f))
                    (test   (cadr test-f))
                    (time   (caddr test-f)))
                (fmt #t stager ":  " test " [  " time "s  ]" nl)
                (+ time total-time)))
            0 failed)))
      
      ;; Only print the time spent if we actually have tests that failed.
      (when (not (equal? failed '()))
        (if ansi-colors?
            (fmt #t (fmt-red (make-string 78 #\-)) nl
                 (fmt-red "[FAILED]  ") "Time spent:  " failed-time "s" nl)
            (fmt #t (make-string 78 #\-) nl
                 "[FAILED]  Time spent:  " failed-time "s" nl)))
      (fmt #t nl "Total time spent:  " (+ failed-time passed-time) "s" nl))))
