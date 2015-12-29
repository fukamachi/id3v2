# id3v2 - ID3v2 parser

## Usage

```common-lisp
(id3v2:read-mp3-file #P"Music/ピノキオP/ありふれたせかいせいふく.mp3")
;=> #S(ID3V2.MP3:MP3
;      :HEADER #S(ID3V2:ID3V2-HEADER :VERSION 4 :REVISION 0 :FLAGS 0 :SIZE 202227)
;      :NAME "ありふれたせかいせいふく"
;      :ARTIST "ピノキオP Feat. 初音ミク"
;      :ALBUM "Obscure Questions"
;      :YEAR "2012"
;      :TRACK NIL
;      :DISC NIL
;      :GENRE "Electronica"
;      :LENGTH NIL
;      :COMMENTS NIL)
```

## Author

* Eitaro Fukamachi (e.arrows@gmail.com)

## Copyright

Copyright (c) 2015 Eitaro Fukamachi (e.arrows@gmail.com)

## License

Licensed under the BSD 2-Clause License.
