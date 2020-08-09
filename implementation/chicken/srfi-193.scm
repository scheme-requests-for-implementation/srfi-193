(module srfi-193
    (command-line command-name command-args script-file script-directory)

  (import scheme)
  (cond-expand
    (chicken-4
     (import chicken)
     (use files posix))
    (chicken-5
     (import (chicken base) (chicken module) (chicken pathname))
     (import (chicken process-context))))

  ;; Chicken's native parameters: command-line-arguments program-name

  ;;; Fundamental

  (define script-file
    (make-parameter
     (cond-expand
       (chicken-script
        (normalize-pathname
         (let ((file (program-name)))
           (if (absolute-pathname? file) file
               (make-absolute-pathname (current-directory) file)))))
       (else #f))))

  (define command-line
    (make-parameter
     (cond-expand
       ((and csi (not chicken-script)) '(""))
       (else (cons (program-name) (command-line-arguments))))))

  ;;; Derived

  (define (command-name)
    (let ((file (car (command-line))))
      (and (not (equal? "" file))
           (pathname-file file))))

  (define (command-args)
    (cdr (command-line)))

  (define (script-directory)
    (let ((file (script-file)))
      (and file (make-pathname (pathname-directory file) "")))))
