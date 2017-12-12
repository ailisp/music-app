(in-package :music-app.view)

(deftag load-css (href attrs)
  `(:link :rel "stylesheet" :href ,@href))

(deftag load-js (src attrs)
  `(:script :src ,@src))

(deftag input (default attrs &key name label (type "text"))
  (once-only (name)
    `(:div :class "form-group"
           (:label :for ,name ,label)
           (:input :name ,name :id ,name :type ,type
                   ,@attrs
                   :class "form-control"
                   :value (progn ,@default)))))

(deftag user-login-panel (default attrs)
  `(:form :class "form-inline" :action "/login" :method "POST"
          (input :name "user-name" :label "User Name: " :required t)
          (input :name "password" :type "password" :label "Password: " :required t)
          (:button :type "submit" :class "btn btn-default" "Login")
          (:a :href "/register" :class "btn btn-default" "Register")))

(deftag user-panel-after-login (default attrs)
  `(:div :class "panel panel-default"
         (format nil "Now login as ~a" (getf (gethash :user *session*) :uloginname))
         (:a :class "btn btn-default" :href "/logout" "Logout")
         (:a :class "btn btn-default" :href "/home" "Home")
         (:a :class "btn btn-default" :href "/users" "Users")))

;; (deftag user-panel (default attrs)
;;   `(if (getf (gethash :user *session*) :uloginname)
;;        (user-panel-after-login)
;;        (user-login-panel)))

(deftag alert (text attrs &key (class "danger"))
  `(:div :class ,(format nil "alert alert-~a" class) ,@attrs
         (:strong ,text)))

(deftag search-box (default attrs)
  `(:form :class "form-inline" :action "/search"
          (input :name "title" :label "Title: ")
          (input :name "author" :label "Author: ")
          (input :name "album" :label "Album: ")
          (:button :type "submit" :class "btn btn-default" "Search")))

(deftag track-list (default attrs &key result)
  `(when ,result
     (:table :class "table table-hover"
             (:tr (:th "Title")
                  (:th "Duration")
                  (:th "Album")
                  (:th "Artist")
                  (:th "Play Times")
                  (:th "Actions"))
             (dolist (row ,result)
               (:tr (:td (getf row :ttitle))
                    (:td (format-tduration (getf row :tduration)))
                    (:td (:a :href (format nil "/album/~a" (getf row :alid)) (getf row :altitle)))
                    (:td (:a :href (format nil "/artist/~a" (getf row :aid)) (getf row :aname)))
                    (:td (getf row :tplaytimes))
                    (:td (:a :href (url-for 'play-route :turl (getf row :turl))
                             :class "btn btn-default" "Play")
                         (:a :href (url-for 'choose-list-route :turl (getf row :turl) :tid (getf row :tid))
                             :class "btn btn-default" "Add to Playlist")))))))
