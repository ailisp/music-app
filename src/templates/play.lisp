(in-package :music-app.view)

(defun play-view (turl)
  (with-page (:title "music-app")
    (:header
     (:h1 "Music App | Play"))
    (:section
     (user-panel-after-login))
    (:section
     (search-box))
    (:section
     (:iframe :src (format nil "https://open.spotify.com/embed?uri=spotify:track:~a&view=coverart&theme=white" turl)
              :frameborder "0"
              :allowtransparency "true"))))
