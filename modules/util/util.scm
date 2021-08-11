(declare (unit hypertrace-util))

(module (hypertrace util) (with-environment-variable
                           with-environment-variable-if-not-f
                           with-loaded-contents
                           with-item)
  (import scheme)
  (import-for-syntax (chicken process-context))


  ;;
  ;; Run the specified command with an environment variable set to value.
  ;; After finishing, the environment variable is restored to what it was before
  ;; thus giving a declarative way to set environment variables.
  ;;
  
  (define-syntax with-environment-variable
    (er-macro-transformer
     (lambda (exp r c)
       (let ((variable (cadr  exp))
             (value    (caddr exp))
             (body     (cdddr exp)))
         `(,(r 'let) ((current (,(r 'get-environment-variable) ,variable)))
           (,(r 'set-environment-variable!) ,variable ,value)
           ,@body
           (,(r 'if) current
            (,(r 'set-environment-variable!) ,variable current)
            (,(r 'unset-environment-variable!) ,variable)))))))


  ;;
  ;; Similar to with-environment-variable, however it only sets the variable if
  ;; it hasn't been set already (either by the environment or the user) calling
  ;; the program.
  ;;

  (define-syntax with-environment-variable-if-not-f
    (er-macro-transformer
     (lambda (exp r c)
       (let ((variable (cadr  exp))
             (value    (caddr exp))
             (body     (cdddr exp)))
         `(,(r 'if) (,(r 'get-environment-variable) ,variable)
           ,@body
           (,(r 'with-environment-variable) ,variable ,value ,@body))))))


  ;;
  ;; A simple macro to avoid messy syntax when loading contents of a file.
  ;;
  ;; Example usage:
  ;;
  ;;  (with-loaded-contents "/path/to/foo.scm" variable-name
  ;;    (call-something-on variable-name))
  ;;

  (define-syntax with-loaded-contents
    (er-macro-transformer
     (lambda (exp r c)
       (let ((test-path (cadr  exp))
             (var-name  (caddr exp))
             (body      (cdddr exp)))
         `(,(r 'let) ((,var-name #f))
           (,(r 'load) ,test-path
            (,(r 'lambda) (x) (,(r 'set!) ,var-name x)))
           ,@body)))))


  ;;
  ;; A macro that lets us seamlessly accept both lists of tests and individual
  ;; items without needing to do a bunch of manual checks. It essentially loops
  ;; over the list for us if we have an item list, and otherwise simply binds
  ;; the variable the user asked for to the one item that was passed in.
  ;;
  ;; Example usage:
  ;;
  ;;  (with-item some-quoted-expr variable-name
  ;;    (do-stuff-with variable-name))
  ;;

  (define-syntax with-item
    (er-macro-transformer
     (lambda (exp r c)
       (let ((exp-to-eval (cadr  exp))
             (var-name    (caddr exp))
             (body        (cdddr exp)))
         `(,(r 'let) ((items (,(r 'eval) ,exp-to-eval)))
           (,(r 'if) (,(r 'list?) items)
            (,(r 'for-each)
             (,(r 'lambda) (item)
              (,(r 'let) ((,var-name item))
               ,@body))
             items)
            (,(r 'let) ((,var-name items))
             ,@body)))))))

  )
