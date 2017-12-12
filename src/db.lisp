(in-package :cl-user)
(defpackage music-app.db
  (:use :cl)
  (:import-from :music-app.config
                :config)
  (:import-from :datafly
                :*connection*)
  (:import-from :cl-dbi
                :connect-cached)
  (:export :connection-settings
           :db
           :with-connection
           :with-music-app-db))
(in-package :music-app.db)

(defun connection-settings (&optional (db :maindb))
  (cdr (assoc db (config :databases))))

(defun db (&optional (db :maindb))
  (apply #'connect-cached (connection-settings db)))

(defmacro with-connection (conn &body body)
  `(let ((*connection* ,conn))
     ,@body))

(defmacro with-music-app-db (&body body)
  (let ((set-search-path-query (gensym)))
    `(with-connection (db)
       (let ((,set-search-path-query
              (dbi:prepare *connection*
                           "SET search_path = 'music'")))
         (dbi:execute ,set-search-path-query)
         ,@body))))
