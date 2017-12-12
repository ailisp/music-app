(in-package :cl-user)
(defpackage music-app.web
  (:use :cl
        :caveman2
        :music-app.config
        :music-app.model
        :music-app.view
        :music-app.controller
        :music-app.db
        :datafly
        :sxql)
  (:export :*web*))
(in-package :music-app.web)

;; for @route annotation
(syntax:use-syntax :annot)

;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)

;;
;; Routing rules

(defroute "/" ()
  ;;  (render #P"index.html")
  (index-view))

(defroute "/register" ()
  (register-view))

(defroute ("/register" :method :post) (&key |user-name| |password| |real-name|
                                            |city| |email|)
  (register |user-name| |password| |real-name| |city| |email|))

(defroute ("/login" :method :post) (&key |user-name| |password|)
  (login |user-name| |password|))

(defroute "/home" ()
  (if (gethash :user *session*)
      (user-home-view (gethash :user *session*))
      (redirect "/")))

(defroute "/search" (&key |title| |album| |author| |page|)
  (do-search |title| |album| |author| |page|))

(defroute "/album/:id" (&key id)
  (album-view (album-information id)))

(defroute "/artist/:id" (&key id)
  (artist-view (artist-information id)))

(defroute "/logout" ()
  (when (gethash :user *session*)
    (remhash :user *session*))
  (redirect "/"))

(defroute play-route "/play" (&key turl)
          (when (gethash :user *session*)
            (update-play-times turl (getf (gethash :user *session*) :uid)))
          (play-view turl))

(defroute choose-list-route "/choose-list" (&key turl tid)
          (setf (gethash :track-to-add *session*) tid)
          (my-list-view (user-playlists (getf (gethash :user *session*) :uid))))

(defroute my-list-route "/my-list" ()
          (my-list-view (user-playlists (getf (gethash :user *session*) :uid))))

(defroute create-playlist-route "/playlist/new" ()
          (create-playlist-view))

(defroute ("/playlist/new" :method :post) (&key |playlist-title| |is-public| )
  (create-playlist |playlist-title| |is-public|))

(defroute "/playlist/view/:id" (&key id)
  (playlist-view (playlist-information id)))

(defroute "/playlist/add/:id" (&key id)
  (when (gethash :track-to-add *session*)
    (add-track-to-playlist id (gethash :track-to-add *session*))
    (remhash :track-to-add *session*))
  (redirect (format nil "/playlist/view/~a" id)))

(defroute "/users" ()
  (let ((uid (getf (gethash :user *session*) :uid)))
    (other-user-view uid (other-user-information uid) (follow-information uid))))

(defroute "/follow/:id" (&key id)
  (let ((uid (getf (gethash :user *session*) :uid)))
    (follow-user uid id)
    (redirect "/users")))

(defroute "/unfollow/:id" (&key id)
  (let ((uid (getf (gethash :user *session*) :uid)))
    (Unfollow-user uid id)
    (redirect "/users")))

(defroute "/user/:id" (&key id)
  (my-list-view (user-public-play-list id)))

(defroute "/like/:id" (&key id)
  (let ((uid (getf (gethash :user *session*) :uid)))
    (like-artist uid id)
    (redirect (format nil "/artist/~a" id))))

(defroute "/unlike/:id" (&key id)
  (let ((uid (getf (gethash :user *session*) :uid)))
    (unlike-artist uid id)
    (redirect (format nil "/artist/~a" id))))

;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
