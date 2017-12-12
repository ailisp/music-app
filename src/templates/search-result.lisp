(in-package :music-app.view)

(defun format-tduration (tms)
  (let* ((tduration-int (parse-integer tms :junk-allowed t))
         (ts (floor tduration-int 1000)))
    (multiple-value-bind (tm ts)
        (floor ts 60)
      (format nil "~2,d:~2,'0d" tm ts))))

(defun search-result-view (search-result count page search-url)
  (with-page (:title "music-app")
    (:header
     (:h1 "Music App - Search Result"))
    (:section
     (search-box))
    (:section
     (:p (format nil "Totally ~a record found" count))
     (track-list :result search-result)
     (when (> count 100)
       (:ul :class "pagination"
            (loop for i below (ceiling count 100)
               do (progn
                    (:li :class (if (= (1+ i) page)
                                    "active"
                                    "")
                         (:a :href (format nil "~a&page=~a" search-url (1+ i))
                             (princ-to-string (1+ i)))))))))))
