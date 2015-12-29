#|
  This file is a part of id3v2 project.
  Copyright (c) 2015 Eitaro Fukamachi (e.arrows@gmail.com)
|#

(in-package :cl-user)
(defpackage id3v2-test-asd
  (:use :cl :asdf))
(in-package :id3v2-test-asd)

(defsystem id3v2-test
  :author "Eitaro Fukamachi"
  :license "BSD 2-Clause"
  :depends-on (:id3v2
               :prove
               :flexi-streams)
  :components ((:module "t"
                :components
                ((:test-file "id3v2")
                 (:test-file "limit-stream"))))
  :description "Test system for id3v2"

  :defsystem-depends-on (:prove-asdf)
  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run-test-system) :prove-asdf) c)
                    (asdf:clear-system c)))
