(in-package :cl-user)
(defpackage id3v2.2
  (:use #:cl
        #:id3v2.mp3
        #:id3v2.util)
  (:export #:parse-id3v22))
(in-package :id3v2.2)

(defun parse-id3v22 (file stream)
  (handler-case
      (loop for id = (read-id stream 3)
            for size = (read-frame-size stream 3)
            do
               (cond
                 ((string= id "TAL")
                  (setf (mp3-album file) (read-string stream size)))
                 ((string= id "TRK")
                  (setf (mp3-track file) (read-string stream size)))
                 ((string= id "TP1")
                  (setf (mp3-artist file) (read-string stream size)))
                 ((string= id "TT2")
                  (setf (mp3-name file) (read-string stream size)))
                 ((string= id "TYE")
                  (setf (mp3-year file) (read-string stream size)))
                 ((string= id "TPA")
                  (setf (mp3-disc file) (read-string stream size)))
                 ((string= id "TCO")
                  (setf (mp3-genre file) (read-string stream size)))
                 ((string= id "COM")
                  (push (read-comment-string stream size) (mp3-comments file)))
                 (t (skip-bytes stream size))))
    (end-of-file ()))
  (setf (mp3-comments file)
        (nreverse (mp3-comments file)))
  file)
