(declare (unit hypertrace-util))

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

