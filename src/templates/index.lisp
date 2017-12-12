(in-package :music-app.view)

(defun index-view (&key login-fail register-success)
  (with-page (:title "music-app")
    (:header
     (:h1 "Music App"))
    (:section
     (when login-fail
       (alert "Username or password incorrect!"))
     (when register-success
       (alert :class "success" "Register successfully. Please login"))
     (user-login-panel))))
