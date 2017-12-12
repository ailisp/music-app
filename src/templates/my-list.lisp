(in-package :music-app.view)

(defun my-list-view (user-play-lists)
  (with-page (:title "music-app")
    (:header
     (:h1 "Music App | Playlist"))
    (:section
     (user-panel-after-login))
    (:section
     (search-box))
    (:section
     (when user-play-lists
       (:div :class "list-group"
            (dolist (play-list user-play-lists)
              (:a :href "#" :class "list-group-item" :pid (getf play-list :pid) (getf play-list :ptitle)))))
     (:div
      (when (gethash :track-to-add *session*)
        (:a :id "add" :class "btn btn-default" :href "#" "Add to Selected Playlist"))
      (:a :class "btn btn-default" :href (url-for 'create-playlist-route) "Create New Playlist")
      (:a :id "see" :class "btn btn-default" :href "#" "See Selected Playlist")))
    (:script
     (ps
       ((@ ($ document) ready)
        (lambda ()
          ((@ ($ ".list-group a") click)
           (lambda ()
             ((@ ($ ".list-group a") remove-class) "active")
             ((@ ($ this) add-class) "active")))

          ((@ ($ "#add") click)
           (lambda ()
             (setf (@ window location href)
                   (concatenate 'string "/playlist/add/" ((@ ($ ".active") attr) "pid")))))

          ((@ ($ "#see") click)
           (lambda ()
             (setf (@ window location href)
                   (concatenate 'string "/playlist/view/" ((@ ($ ".active") attr) "pid")))))

          nil))))))
