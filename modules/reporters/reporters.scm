(declare (unit hypertrace-reporters))

(module (hypertrace reporters) (report-html
                                report-json
                                report-junit
                                report-text)

  (import scheme
          (chicken base))

  (include "reporter-html.scm")
  (include "reporter-json.scm")
  (include "reporter-junit.scm")
  (include "reporter-text.scm")

  (define (report-html passed failed)
    (generate-html-report passed failed))
  
  (define (report-json passed failed)
    (generate-json-report passed failed))

  (define (report-junit passed failed)
    (generate-junit-report passed failed))

  (define (report-text passed failed ansi-support?)
    (generate-text-report passed failed ansi-support?))

  )
