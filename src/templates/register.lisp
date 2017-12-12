(in-package :music-app.view)

(defun register-view (&key user-already-exist)
  (with-page (:title "Register | music-app")
    (:script
     (ps
       ((@ ($ document) ready)
        (lambda ()
          ((@ ($ "#password-not-match-alert") hide))
          nil))))
    (:header
     (:h1 "Music App")
     (:h2 "Register New User"))
    (:section
     (alert :id "password-not-match-alert" "Password doesn't match")
     (when user-already-exist
       (alert "Username already exists, please chhose another one."))
     (:form :class "form" :action "/register" :method "POST"
            :onsubmit (ps-inline
                       (when (not (equal password.value password2.value))
                         ((@ ($ "#password-not-match-alert") show))
                         (return false)))
            (input :name "user-name" :label "User Name: " :required t)
            (input :name "password"  :type "password" :label "Password: " :required t)
            (input :name "password2" :type "password" :label "Confirm Password: " :required t)
            (input :name "city" :label "City: ")
            (input :name "real-name" :label "Real Name: ")
            (input :name "email" :type "email" :label "Email: ")
            (:button :type "submit" :class "btn btn-default" "Register")))))
