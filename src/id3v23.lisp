(in-package :cl-user)
(defpackage id3v2.3
  (:use #:cl
        #:id3v2.mp3
        #:id3v2.util)
  (:export #:parse-id3v23))
(in-package :id3v2.3)

(defun parse-id3v23 (file stream)
  (handler-case
      (loop for id = (read-id stream 4)
            for size = (read-frame-size stream 4)
            do
               ;; Skip over frame flags
               (dotimes (i 2) (read-byte stream))
               (cond
                 ((string= id "TALB")
                  (setf (mp3-album file) (read-string stream size)))
                 ((string= id "TRCK")
                  (setf (mp3-track file) (read-string stream size)))
                 ((string= id "TPE1")
                  (setf (mp3-artist file) (read-string stream size)))
                 ((string= id "TCON")
                  (setf (mp3-genre file) (read-string stream size)))
                 ((string= id "TIT2")
                  (setf (mp3-name file) (read-string stream size)))
                 ((string= id "TYER")
                  (setf (mp3-year file) (read-string stream size)))
                 ((string= id "TPOS")
                  (setf (mp3-disc file) (read-string stream size)))
                 ((string= id "TLEN")
                  (setf (mp3-length file)
                        (parse-integer (read-string stream size))))
                 ((string= id "CONN")
                  (push (read-comment-string stream size)
                        (mp3-comments file)))
                 (t (skip-bytes stream size))))
    (end-of-file ()))
  (setf (mp3-comments file)
        (nreverse (mp3-comments file)))
  file)
