(in-package :music-app.view)

(defun create-playlist-view ()
  (with-page (:title "music-app")
    (:header
     (:h1 "Music App | Create Playlist"))
    (:section
     (user-panel-after-login))
    (:section
     (:form :class "form" :action "/playlist/new" :method "POST"
      (input :name "playlist-title" :label "Playlist title: " :required t)
      (:div :class "checkbox"
            (:label (:input :type "checkbox" :name "is-public" "Public")))
      (:button :type "submit" :class "btn btn-default" "Create")))))
