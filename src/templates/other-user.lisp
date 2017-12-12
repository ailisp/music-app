(in-package :music-app.view)

(defun other-user-view (uid other-user-information user-follow)
  (with-page (:title "music-app")
    (:header
     (:h1 "Music App | Users"))
    (:section
     (user-panel-after-login))
    (:section
     (search-box))
    (:section
     (:table :class "table table-hover"
             (:tr (:th "User Name")
                  (:th "Follow"))
             (dolist (row other-user-information)
               (:tr (:td (:a :href (format nil "/user/~a" (getf row :uid)) (getf row :uname)))
                    (:td (if (member (getf row :uid) user-follow
                                     :key (lambda (follow)
                                            (getf follow :uidf)))
                             (:a :href (format nil "/unfollow/~a" (getf row :uid)) :class "btn btn-default" "Unfollow")
                             (:a :href (format nil "/follow/~a" (getf row :uid)) :class "btn btn-default" "Follow")))))))))
