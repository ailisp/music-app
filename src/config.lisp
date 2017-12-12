(in-package :cl-user)
(defpackage music-app.config
  (:use :cl)
  (:import-from :envy
                :config-env-var
                :defconfig)
  (:export :config
           :*application-root*
           :*static-directory*
           :*template-directory*
           :appenv
           :developmentp
           :productionp))
(in-package :music-app.config)

(setf (config-env-var) "APP_ENV")

(defparameter *application-root*   (asdf:system-source-directory :music-app))
(defparameter *static-directory*   (merge-pathnames #P"static/" *application-root*))
(defparameter *template-directory* (merge-pathnames #P"templates/" *application-root*))

(defconfig :common
    '())

(defconfig |development|
    '(:debug t
      :databases
      ((:maindb :postgres :database-name "cs6083" :username "cs6083"))))

(defconfig |production|
  '())

(defconfig |test|
  '())

(defun config (&optional key)
  (envy:config #.(package-name *package*) key))

(defun appenv ()
  (uiop:getenv (config-env-var #.(package-name *package*))))

(defun developmentp ()
  (string= (appenv) "development"))

(defun productionp ()
  (string= (appenv) "production"))

(defun (setf appenv) (env)
  (setf (osicat:environment-variable "APP_ENV") env))
