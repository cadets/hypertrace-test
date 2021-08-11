;;
;; Generate the same tests that we have for BEGIN, but for END and ERROR
;; probes.
;;
;; CREATES:
;;  - end/   : directory under current stager
;;  - error/ : directory under current stager
;;  - tests  : same as begin/ under both directories.
;;

(begin
  (import (chicken file)
          (chicken pathname)
          (chicken string)
          (chicken io)
          (chicken.irregex)
          (chicken file posix)
          (hypertrace util))
  ;;
  ;; Flatten so we don't have to deal with lists of lists of lists of lists...
  ;;
  (flatten
   (let* ((files      (glob (string-append current-stager "/begin-*.scm")))
          (test-lists (map (lambda (file)
                             (let ((loaded-contents #f))
                               (load file (lambda (x)
                                            (set! loaded-contents x)))
                               (eval loaded-contents)))
                           files)))
     ;;
     ;; XXX: Perhaps we can move this to the framework as a library if it gets
     ;; repetitive in the future?
     ;;
     (let ((generate-tests
            (lambda (test-lists dest-dir prefix)
              (let ((final-dir (string-append current-stager dest-dir)))
                (when (not (directory-exists? final-dir))
                  (create-directory final-dir)))
              ;;
              ;; This is a little bit complicated, but the jist of it is that we are mapping
              ;; over all the test lists that we've loaded, and mapping it into a list of
              ;; lists that contains the new tests.
              ;;
              (map
               (lambda (test-list)
                 (map
                  ;;
                  ;; Prepare all of the names, load the contents and replace
                  ;; them with a regular expression.
                  ;;
                  (lambda (test)
                    (let* ((name       (hypertrace-test-name    test))
                           (in-file    (string-append current-stager
                                                      (hypertrace-test-in-file test)))
                           (split-name (string-split name))
                           (new-name   (string-append "GENERATED:  "
                                                      prefix " - "
                                                      (string-intersperse
                                                       (cdddr split-name))))
                           (new-file   (irregex-replace "begin/" in-file dest-dir))
                           (in-file-contents (read-file in-file))
                           (new-contents     (irregex-replace "BEGIN"
                                                              in-file-contents
                                                              prefix)))

                      ;; Create the file. We overwrite it if it exists.
                      (let ((fh (open-output-file new-file)))
                        (write-string new-contents #f fh)
                        (close-output-port fh))

                      ;;
                      ;; Make it executable
                      ;;
                      ;; TODO: Windows -- this is not portable!
                      ;;
                      (set-file-permissions! new-file #o770)

                      ;; Make a new test with all the new things we need.
                      (mk-hypertrace-test
                       `((name    ,new-name)
                         (in-file
                          ,(irregex-replace current-stager
                                            new-file ""))))))
                  ;;
                  ;; We might get a #<hypertrace-test> record, not a list. This
                  ;; check simply ensures that we are always calling map with a
                  ;; list.
                  ;;
                  (if (list? test-list)
                      test-list
                      (list test-list))))
               test-lists))))

       ;; Generate END and ERROR tests.
       `(,(generate-tests test-lists "end/" "END")
         ,(generate-tests test-lists "error/" "ERROR"))))))
