(in-package :cl-user)
(defpackage id3v2.limit-stream
  (:use #:cl)
  (:import-from #:trivial-gray-streams
                #:fundamental-binary-input-stream
                #:stream-element-type
                #:stream-read-byte
                #:stream-read-sequence)
  (:export #:limit-stream
           #:make-limit-stream))
(in-package :id3v2.limit-stream)

(defclass limit-stream (fundamental-binary-input-stream)
  ((real-stream :type stream
                :initarg :stream
                :initform (error ":stream is required")
                :accessor limit-stream-real-stream)
   (readable-bytes :type integer
                   :initarg :limit
                   :initform (error ":limit is required"))))

(defun make-limit-stream (stream limit)
  (make-instance 'limit-stream :stream stream :limit limit))

(defmethod stream-element-type ((stream limit-stream))
  '(unsigned-byte 8))

(defmethod stream-read-byte ((stream limit-stream))
  (with-slots (real-stream readable-bytes) stream
    (if (= 0 readable-bytes)
        :eof
        (progn
          (decf readable-bytes)
          (read-byte real-stream nil :eof)))))

(defmethod stream-read-sequence ((stream limit-stream) sequence start end &key)
  (with-slots (real-stream readable-bytes) stream
    (let ((to-read (min readable-bytes (- end start))))
      (read-sequence sequence real-stream :start start :end (+ start to-read)))))
