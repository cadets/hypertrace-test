(declare (unit hypertrace-util))

(module (hypertrace util) (with-environment-variable
			   with-environment-variable-if-not-f)
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
       (let ((variable (cadr exp))
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
       (let ((variable (cadr exp))
	     (value    (caddr exp))
	     (body     (cdddr exp)))
	 `(,(r 'if) (,(r 'get-environment-variable) ,variable)
	   ,@body
	   (,(r 'with-environment-variable) ,variable ,value ,@body))))))

  )
