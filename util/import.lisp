(with-music-app-db
         (cl-csv:read-csv #P"/home/boyao/quicklisp/local-projects/music-app/src/tracks.csv"
                          :skip-first-p t
                          :map-fn
                          #'(lambda (row)
                              (let ((artist (retrieve-one
                                             (select :* (from :artists)
                                                     (where (:= :aname (nth 3 row)))))))
                                (if artist
                                    (let ((album (retrieve-one
                                                  (select :* (from :album)
                                                          (where (:= (nth 4 row) :alurl)))))
                                          (artist-id (getf artist :aid)))
                                      (execute (insert-into :track
                                                 (set=
                                                  :tid (:raw "DEFAULT")
                                                  :ttitle (nth 1 row)
                                                  :tduration (nth 2 row)
                                                  :turl (nth 0 row)
                                                  :tplaytimes 0
                                                  :alurl (getf album :alurl)
                                                  :aid artist-id)))
                                      (print (nth 0 row))))))))
(with-music-app-db
         (cl-csv:read-csv #P"/home/boyao/quicklisp/local-projects/music-app/src/artists.csv"
                          :skip-first-p t
                          :map-fn
                          #'(lambda (row)
                              (execute (insert-into :artists
                                         (set=
                                          :aid (:raw "DEFAULT")
                                          :aname (nth 1 row)
                                          :adesc (nth 2 row)
                                          :aurl (nth 0 row)))))))
(with-music-app-db
         (execute
          (create-index "album_url"
                        :unique t
                        :on '(:album :alurl))))

(with-music-app-db
         (cl-csv:read-csv #P"/home/boyao/quicklisp/local-projects/music-app/src/albums.csv"
                          :skip-first-p t
                          :map-fn
                          #'(lambda (row)
                              (if (search "/" (nth 2 row))
                              (execute (insert-into :album
                                         (set=
                                          :alid (:raw "DEFAULT")
                                          :altitle (nth 1 row)
                                          :aldate (nth 2 row)
                                          :alurl (nth 0 row))))))))
