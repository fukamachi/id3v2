(in-package :cl-user)
(defpackage id3v2-test.limit-stream
  (:use #:cl
        #:prove
        #:id3v2.limit-stream))
(in-package :id3v2-test.limit-stream)

(plan 2)

(subtest "normal case"
  (let ((stream (make-limit-stream (flex:make-in-memory-input-stream (flex:string-to-octets "aiueo"))
                                   3)))
    (is-type stream 'limit-stream)
    (is (read-byte stream) (char-code #\a))
    (is (read-byte stream) (char-code #\i))
    (is (read-byte stream) (char-code #\u))
    (is (read-byte stream nil :eof) :eof)))

(subtest "short stream"
  (let ((stream (make-limit-stream (flex:make-in-memory-input-stream (flex:string-to-octets "a"))
                                   3)))
    (is-type stream 'limit-stream)
    (is (read-byte stream) (char-code #\a))
    (is (read-byte stream nil :eof) :eof)))

(finalize)
