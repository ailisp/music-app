(in-package :music-app.view)

(defun user-home-view (user-info)
  (with-page (:title "music-app")
    (:header
     (:h1 "Music App - User Home"))
    (:section
     (user-panel-after-login))
    (:section
     (search-box))
    (:section
     (let ((user-play-lists (music-app.model:user-playlists (getf (gethash :user *session*) :uid))))
       (when user-play-lists
         (:div :class "list-group"
               (dolist (play-list user-play-lists)
                 (:a :href "#" :class "list-group-item" :pid (getf play-list :pid) (getf play-list :ptitle)))))
       (:div
        (when (gethash :track-to-add *session*)
          (:a :id "add" :class "btn btn-default" :href "#" "Add to Selected Playlist"))
        (:a :class "btn btn-default" :href (url-for 'create-playlist-route) "Create New Playlist")
        (:a :id "see" :class "btn btn-default" :href "#" "See Selected Playlist"))
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
    (:section
     (:h2 "Users you followed:")
     (:table :class "table table-hover"
             (:tr (:th "User Name")
                  (:th "Follow"))
             (let* ((uid (getf (gethash :user *session*) :uid))
                    (other-user-information (music-app.model:other-user-information uid))
                    (user-follow (music-app.model:follow-information uid)))
               (dolist (row other-user-information)
                 (if (member (getf row :uid) user-follow :key (lambda (follow)
                                                                (getf follow :uidf)))
                     (:tr (:td (:a :href (format nil "/user/~a" (getf row :uid)) (getf row :uname)))
                          (:td (:a :href (format nil "/unfollow/~a" (getf row :uid)) :class "btn btn-default" "Unfollow"))))))))
    (:section
     (:h2 "Recent songs from artists you like:")
     (track-list :result (music-app.model:recent-songs-from-artist-you-like (getf (gethash :user *session*) :uid))))))
