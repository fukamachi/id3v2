(in-package :cl-user)
(defpackage id3v2
  (:use #:cl
        #:id3v2.2
        #:id3v2.3
        #:id3v2.4
        #:id3v2.mp3
        #:id3v2.limit-stream)
  (:export #:mp3
           #:mp3-header
           #:mp3-name
           #:mp3-artist
           #:mp3-album
           #:mp3-year
           #:mp3-track
           #:mp3-disc
           #:mp3-genre
           #:mp3-length
           #:mp3-comments
           #:id3v2-header
           #:id3v2-header-version
           #:id3v2-header-revision
           #:id3v2-header-flags
           #:id3v2-header-size
           #:read-mp3-file))
(in-package :id3v2)

(defstruct id3v2-header
  version
  revision
  flags
  size)

(defun read-mp3-file (path)
  (with-open-file (in path :element-type '(unsigned-byte 8))
    (unless (has-id3-tag-p in)
      (return-from read-mp3-file nil))

    (let* ((header (read-id3v2-header in))
           (mp3 (make-mp3 :header header)))
      (case (id3v2-header-version header)
        (2 (parse-id3v22
            mp3
            (make-limit-stream in (id3v2-header-size header))))
        (3 (parse-id3v23
            mp3
            (make-limit-stream in (id3v2-header-size header))))
        (4 (parse-id3v24
            mp3
            (make-limit-stream in (id3v2-header-size header))))
        (otherwise (error "Unrecognized ID3v2 version: ~A" (id3v2-header-version header)))))))

(defun has-id3-tag-p (stream)
  (and (= (char-code #\I) (read-byte stream nil 0))
       (= (char-code #\D) (read-byte stream nil 0))
       (= (char-code #\3) (read-byte stream nil 0))))

(defun read-id3v2-header (stream)
  (let ((data (make-array 7 :element-type '(unsigned-byte 8))))
    (read-sequence data stream)
    (make-id3v2-header
     :version (aref data 0)
     :revision (aref data 1)
     :flags (aref data 2)
     :size (+ (ash (aref data 3) 21)
              (ash (aref data 4) 14)
              (ash (aref data 5) 7)
              (aref data 6)))))
