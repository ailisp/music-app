(defsystem "music-app-test"
  :defsystem-depends-on ("prove-asdf")
  :author "Bo Yao"
  :license ""
  :depends-on ("music-app"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "music-app"))))
  :description "Test system for music-app"
  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
