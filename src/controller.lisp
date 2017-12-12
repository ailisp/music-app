(in-package :cl-user)
(defpackage music-app.controller
  (:use :cl :music-app.model :music-app.view :caveman2)
  (:export :login
           :register
           :do-search
           :create-playlist))
(in-package :music-app.controller)

(defparameter *a* *standard-output*)
(defun print-hash-table (h)
  (loop for value being the hash-values of h
     using (hash-key key)
     do (format *a* "~&~A -> ~A" key value)))

(defun login (user-name password)
  (let ((user-info (user-password-valid user-name password)))
    (if user-info
        (progn
          (setf (gethash :user *session*) user-info)
          (redirect "/home"))
        (index-view :login-fail t))))

(defun register (user-name password real-name city email)
  (if (create-user user-name password real-name city email)
      (index-view :register-success t)
      (register-view :user-already-exist t)))

(defun do-search (title album artist page)
  (multiple-value-call
      'search-result-view
    (search-track title album artist :offset
                  (if page
                      (* 100 (1- (parse-integer page)))
                      0))))

(defun create-playlist (playlist-title is-public)
  (let ((uid (getf (gethash :user *session*) :uid)))
    (if uid
        (progn
          (create-user-playlist uid playlist-title is-public)
          (redirect "/my-list"))
        (redirect "/index"))))
