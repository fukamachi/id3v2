#|
  This file is a part of id3v2 project.
  Copyright (c) 2015 Eitaro Fukamachi (e.arrows@gmail.com)
|#

#|
  ID3v2 parser

  Author: Eitaro Fukamachi (e.arrows@gmail.com)
|#

(in-package :cl-user)
(defpackage id3v2-asd
  (:use :cl :asdf))
(in-package :id3v2-asd)

(defsystem id3v2
  :version "0.1"
  :author "Eitaro Fukamachi"
  :license "BSD 2-Clause"
  :depends-on (:trivial-gray-streams
               :babel)
  :components ((:module "src"
                :components
                ((:file "id3v2" :depends-on ("id3v22" "id3v23" "id3v24" "limit-stream" "mp3"))
                 (:file "id3v22" :depends-on ("mp3" "util"))
                 (:file "id3v23" :depends-on ("mp3" "util"))
                 (:file "id3v24" :depends-on ("mp3" "util"))
                 (:file "limit-stream")
                 (:file "mp3")
                 (:file "util"))))
  :description "ID3v2 parser"
  :long-description
  #.(with-open-file (stream (merge-pathnames
                             #p"README.markdown"
                             (or *load-pathname* *compile-file-pathname*))
                            :if-does-not-exist nil
                            :direction :input
                            :element-type #+lispworks :default #-lispworks 'character
                            :external-format #+clisp charset:utf-8 #-clisp :utf-8)
      (when stream
        (let ((seq (make-array (file-length stream)
                               :element-type 'character
                               :fill-pointer t)))
          (setf (fill-pointer seq) (read-sequence seq stream))
          seq)))
  :in-order-to ((test-op (test-op id3v2-test))))
