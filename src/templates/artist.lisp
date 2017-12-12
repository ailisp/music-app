(in-package :music-app.view)

(defun artist-view (artist-information)
  (let* ((artist-name (getf (getf artist-information :artist) :aname))
         (tracks (getf artist-information :tracks))
         (artist-id (getf (getf artist-information :artist) :aid))
         (uid (getf (gethash :user *session*) :uid))
         (user-likes (music-app.model:user-likes uid)))
    (with-page (:title "music-app")
      (:header
       (:h1 "Music App | Artist"))
      (:section
       (user-panel-after-login))
      (:section
       (search-box))
      (:section
       (:h2 artist-name
            (if (member artist-id user-likes
                        :key (lambda (like)
                               (getf like :aid)))
                (:a :href (format nil "/unlike/~a" artist-id) :class "btn btn-default" "Unlike")
                (:a :href (format nil "/like/~a" artist-id) :class "btn btn-default" "Like")))
       (track-list :result tracks)))))
