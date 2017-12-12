 (defsystem "music-app"
  :version "0.1.0"
  :author "Bo Yao"
  :license ""
  :depends-on ("clack"
               "lack"
               "caveman2"
               "envy"
               "cl-ppcre"
               "uiop"
               "osicat"

               ;; for @route annotation
               "cl-syntax-annot"

               ;; HTML Template
               "djula"
               "spinneret"

               ;; JavaScript
               "parenscript"

               ;; for DB
               "datafly"
               "sxql")
  :components ((:module "src"
                :components
                ((:file "main" :depends-on ("config" "view" "db"))
                 (:file "web" :depends-on ("view" "controller"))
                 (:file "controller" :depends-on ("config" "model" "view"))
                 (:file "view" :depends-on ("config"))
                 (:file "model" :depends-on ("config" "db"))
                 (:file "db" :depends-on ("config"))
                 (:file "config")
                 (:module "templates"
                          :depends-on ("view")
                          :components
                          ((:file "component")
                           (:file "common" :depends-on ("component"))
                           (:file "index" :depends-on ("common"))
                           (:file "register" :depends-on ("common"))
                           (:file "user-home" :depends-on ("common"))
                           (:file "search-result" :depends-on ("common"))
                           (:file "album" :depends-on ("common"))
                           (:file "artist" :depends-on ("common"))
                           (:file "play" :depends-on ("common"))
                           (:file "my-list" :depends-on ("common"))
                           (:file "create-playlist" :depends-on ("common"))
                           (:file "playlist" :depends-on ("common"))
                           (:file "other-user" :depends-on ("common")))))))
  :description ""
  :in-order-to ((test-op (test-op "music-app-test"))))
