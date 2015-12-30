(in-package :cl-user)
(defpackage id3v2.util
  (:use #:cl)
  (:import-from #:babel
                #:string-to-octets
                #:octets-to-string)
  (:export #:read-id
           #:read-frame-size
           #:read-string
           #:read-comment-string
           #:skip-bytes))
(in-package :id3v2.util)

(defun read-id (stream &optional count)
  (let ((id (make-string count)))
    ;; Check if the first byte is 0
    (let ((byte (read-byte stream)))
      (when (= byte 0)
        (error 'end-of-file))
      (setf (aref id 0) (code-char byte))
      (dotimes (i (1- count))
        (setf (aref id (1+ i)) (code-char (read-byte stream)))))
    id))

(defun read-frame-size (stream &optional count)
  (loop for i from (1- count) downto 0
        collect (ash (read-byte stream) (* 8 i)) into res
        finally
           (return (apply #'logxor res))))

(defun read-string (stream size)
  (let ((data (make-array size :element-type '(unsigned-byte 8))))
    (read-sequence data stream)
    (string-trim
     '(#\Nul #\ZERO_WIDTH_NO-BREAK_SPACE)
     (babel:octets-to-string
      data
      :start 1
      :encoding
      (case (aref data 0)
        ;; ISO-8859-1
        (0 :iso-8859-1)
        ;; UTF-16 with BOM
        (1 :utf-16le)
        ;; UTF-16BE without BOM
        (2 :utf-16be)
        ;; UTF-8
        (3 :utf-8)
        ;; Unknown encoding. Assuming ISO-8859-1 text.
        (otherwise :iso-8859-1))))))

(defun read-comment-string (stream size)
  (let ((data (make-array size :element-type '(unsigned-byte 8))))
    (read-sequence data stream)
    (let* ((null-string (make-string 1 :initial-element #\Nul))
           (encoding
             (case (aref data 0)
               (0 :iso-8859-1)
               (1 :utf-16le)
               (2 :utf-16be)
               (3 :utf-8)
               (otherwise :iso-8859-1)))
           (delimiter
             (babel:string-to-octets null-string :encoding encoding))
           (end-of-description (search delimiter data :start2 4)))
      (list
       (let ((lang (make-string 3)))
         (setf (aref lang 0) (code-char (aref data 1))
               (aref lang 1) (code-char (aref data 2))
               (aref lang 2) (code-char (aref data 3)))
         lang)
       (babel:octets-to-string data :start 4 :end end-of-description
                                    :encoding encoding)
       (string-trim
        '(#\Nul #\ZERO_WIDTH_NO-BREAK_SPACE)
        (babel:octets-to-string data :start (+ end-of-description (length delimiter))
                                     :encoding encoding))))))

(defun skip-bytes (stream size)
  (dotimes (i size) (read-byte stream)))
