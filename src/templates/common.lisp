(in-package :music-app.view)

(defmacro with-page ((&key title) &body body)
  `(let ((*print-pretty* t))
     (with-html-string
       (:doctype)
       (:html
        (:head
         (load-css "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css")
         (load-js "https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js")
         (load-js "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js")
         (:title ,title))
        (:body ,@body)))))
