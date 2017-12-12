(in-package :cl-user)
(defpackage :music-app.model
  (:use :cl :music-app.db :sxql :datafly)
  (:export :user-password-valid
           :create-user
           :search-track
           :album-information
           :artist-information
           :update-play-times
           :user-playlists
           :create-user-playlist
           :playlist-information
           :add-track-to-playlist
           :other-user-information
           :follow-information
           :follow-user
           :unfollow-user
           :user-public-play-list
           :user-likes
           :like-artist
           :unlike-artist
           :recent-songs-from-artist-you-like))

;;; Patch for raw, for using DEFAULT when insert in PostgreSQL
(in-package :sxql.operator)

(define-op (:~ infix-op))

(defmethod yield ((raw raw-op))
  (values
   (format nil "~A" ; was "(~A)"
           (etypecase (raw-op-var raw)
             (string (raw-op-var raw))
             (sql-variable (let ((*use-placeholder* nil))
                             (sql-variable-value (raw-op-var raw))))))
   nil))


(in-package :music-app.model)


(defun user-password-valid (user-name password)
  (with-music-app-db
    (retrieve-one
     (select :*
       (from :users)
       (where (:and (:= :uloginname user-name)
                    (:= :upassword (:raw (format nil "crypt('~a', upassword)" password)))))))))

(defun create-user (user-name password real-name city email)
  (with-music-app-db
    (let ((user-existp
           (retrieve-one
            (select :*
              (from :users)
              (where (:= :uloginname user-name))))))
      (when user-existp
        (return-from create-user nil))
      (execute
       (insert-into :users
         (set=
          :uid (:raw "DEFAULT")
          :uloginname user-name
          :upassword (:raw (format nil "crypt('~a', gen_salt('bf'))" password))
          :uname real-name
          :ucity city
          :uemail email)))
      t)))

(defun search-track (title album artist &key (limit 100) (offset 0))
  (with-music-app-db
    (let* ((from-clause (from :track :artists :album))
           (where-clause
            (where
             (:and
              (:= :track.aid :artists.aid)
              (:= :track.alurl :album.alurl)
              (:~ :track.ttitle title)
              (:~ :album.altitle album)
              (:~ :artists.aname artist))))
           (count
            (getf (retrieve-one
                   (select (fields (:count :*)) from-clause where-clause))
                  :count)))
      (values
       (retrieve-all
        (select :* from-clause where-clause (limit limit) (offset offset)))
       count
       (1+ (floor offset limit))
       (format nil "/search?title=~a&author=~a&album=~a"
               (if title title "")
               (if artist artist  "")
               (if album album ""))))))

(defun album-information (album-id)
  (with-music-app-db
    (let* ((album (retrieve-one (select :* (from :album) (where (:= album-id :alid)))))
           (tracks
            (when album
              (retrieve-all (select :* (from :track :artists :album)
                                    (where (:and (:= (getf album :alurl) :album.alurl)
                                                 (:= :track.alurl :album.alurl)
                                                 (:= :track.aid :artists.aid))))))))
      (list :album album :tracks tracks))))

(defun artist-information (artist-id)
  (with-music-app-db
    (let* ((artist (retrieve-one (select :* (from :artists) (where (:= artist-id :aid)))))
           (tracks
            (when artist
              (retrieve-all (select :* (from :track :artists :album)
                                    (where (:and (:= (getf artist :aid) :artists.aid)
                                                 (:= :track.alurl :album.alurl)
                                                 (:= :track.aid :artists.aid))))))))
      (list :artist artist :tracks tracks))))

(defun playlist-information (playlist-id)
  (with-music-app-db
    (let* ((playlist (retrieve-one (select :* (from :playlist) (where (:= playlist-id :pid)))))
           (tracks
            (when playlist
              (retrieve-all (select :* (from :track :playlist :playlisttrack :artists :album)
                                    (where (:and (:= playlist-id :playlist.pid)
                                                 (:= :playlist.pid :playlisttrack.pid)
                                                 (:= :track.tid :playlisttrack.tid)
                                                 (:= :track.alurl :album.alurl)
                                                 (:= :track.aid :artists.aid))))))))
      (list :playlist playlist :tracks tracks))))

(defun update-play-times (turl uid)
  (with-music-app-db
    (let* ((track (retrieve-one
                   (select :* (from :track)
                           (where (:= :turl turl)))))
           (previous-time (getf track :tplaytimes))
           (tid (getf track :tid)))
      (execute (update :track
                 (set= :tplaytimes (1+ previous-time))
                 (where (:= :turl turl))))
      (execute (insert-into :playtrack
                 (set= :uid uid
                       :tid tid
                       :playtime (:raw "DEFAULT")))))))

(defun user-playlists (user-id)
  (with-music-app-db
    (retrieve-all (select :* (from :playlist)
                          (where (:= user-id :uid))))))

(defun create-user-playlist (user-id playlist-title is-public)
  (with-music-app-db
    (execute (insert-into :playlist
               (set=
                :pid (:raw "DEFAULT")
                :ptitle playlist-title
                :uid user-id
                :pdate (:raw "DEFAULT")
                :pplaytimes 0
                :ispublic is-public)))))

(defun add-track-to-playlist (playlist-id track-id)
  (with-music-app-db
    (execute (insert-into :playlisttrack
               (set=
                :pid playlist-id
                :tid track-id)))))

(defun other-user-information (uid)
  (with-music-app-db
    (retrieve-all
     (select :* (from :users)
             (where (:!= :users.uid uid))))))

(defun follow-information (uid)
  (with-music-app-db
    (retrieve-all
     (select :* (from :follow)
             (where (:= :uid uid))))))

(defun follow-user (uid uidf)
  (with-music-app-db
    (execute
     (insert-into :follow
       (set= :uid uid
             :uidf uidf)))))

(defun unfollow-user (uid uidf)
  (with-music-app-db
    (execute
     (delete-from :follow
       (where (:and (:= :uid uid)
                    (:= :uidf uidf)))))))

(defun like-artist (uid aid)
  (with-music-app-db
    (execute
     (insert-into :userlike
       (set= :uid uid
             :aid aid)))))

(defun unlike-artist (uid aid)
  (with-music-app-db
    (execute
     (delete-from :follow
       (where (:add (:= aid :aid)
                    (:= uid :uid)))))))

(defun user-public-play-list (uid)
  (with-music-app-db
    (retrieve-all (select :* (from :playlist)
                          (where (:and (:= uid :uid)
                                       (:= "t" :ispublic)))))))

(defun user-likes (uid)
  (with-music-app-db
    (retrieve-all (select :* (from :userlike)
                          (where (:= uid :uid))))))

(defun recent-songs-from-artist-you-like (uid)
  (with-music-app-db
    (let ((user-likes (remove-duplicates (mapcar (lambda (userlike) (getf userlike :aid)) (user-likes uid)))))
     (mapcan (lambda (aid)
               (retrieve-all (select :* (from :track :artists :album)
                                     (where (:and
                                             (:= aid :track.aid)
                                             (:= :track.alurl :album.alurl)
                                             (:= :track.aid :artists.aid)))
                                     (limit 3)
                                     (order-by (:desc :album.aldate)))))
             user-likes))))
