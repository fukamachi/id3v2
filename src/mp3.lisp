(in-package :cl-user)
(defpackage id3v2.mp3
  (:use #:cl)
  (:export #:mp3
           #:make-mp3
           #:mp3-header
           #:mp3-name
           #:mp3-artist
           #:mp3-album
           #:mp3-year
           #:mp3-track
           #:mp3-disc
           #:mp3-genre
           #:mp3-length
           #:mp3-comments))
(in-package :id3v2.mp3)

(defstruct mp3
  header

  name
  artist
  album
  year
  track
  disc
  genre
  length
  comments)
