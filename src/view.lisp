(in-package :cl-user)
(defpackage music-app.view
  (:use :cl :parenscript :caveman2)
  (:import-from :music-app.config
                :*template-directory*)
  (:import-from :caveman2
                :*response*
                :response-headers)
  (:import-from :djula
                :add-template-directory
                :compile-template*
                :render-template*
                :*djula-execute-package*)
  (:import-from :datafly
                :encode-json)
  (:import-from :spinneret
                :with-html-string
                :deftag
                :once-only)
  (:export :render
           :render-json

           :index-view
           :user-home-view
           :register-view
           :search-result-view
           :album-view
           :artist-view
           :play-view
           :my-list-view
           :create-playlist-view
           :playlist-view
           :other-user-view))
(in-package :music-app.view)

(djula:add-template-directory *template-directory*)

(defparameter *template-registry* (make-hash-table :test 'equal))

(defun render (template-path &optional env)
  (let ((template (gethash template-path *template-registry*)))
    (unless template
      (setf template (djula:compile-template* (princ-to-string template-path)))
      (setf (gethash template-path *template-registry*) template))
    (apply #'djula:render-template*
           template nil
           env)))

(defun render-json (object)
  (setf (getf (response-headers *response*) :content-type) "application/json")
  (encode-json object))


;;
;; Execute package definition

(defpackage music-app.djula
  (:use :cl)
  (:import-from :music-app.config
                :config
                :appenv
                :developmentp
                :productionp)
  (:import-from :caveman2
                :url-for))

(setf djula:*djula-execute-package* (find-package :music-app.djula))
