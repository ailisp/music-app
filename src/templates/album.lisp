(in-package :music-app.view)

(defun album-view (album-information)
  (let ((album-title (getf (getf album-information :album) :altitle))
        (tracks (getf album-information :tracks)))
    (with-page (:title "music-app")
      (:header
       (:h1 "Music App | Album"))
      (:section
       (user-panel-after-login))
      (:section
       (search-box))
      (:section
       (:h2 album-title)
       (track-list :result tracks)))))
