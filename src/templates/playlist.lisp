(in-package :music-app.view)

(defun playlist-view (playlist-information)
  (let ((playlist-title (getf (getf playlist-information :album) :ptitle))
        (tracks (getf playlist-information :tracks)))
    (with-page (:title "music-app")
      (:header
       (:h1 "Music App | Playlist"))
      (:section
       (user-panel-after-login))
      (:section
       (search-box))
      (:section
       (:h2 playlist-title)
       (track-list :result tracks)))))
