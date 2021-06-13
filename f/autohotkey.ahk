;;
;; Based on https://pastebin.com/eRADkvuN
;;

#NoEnv
#Warn
#SingleInstance force
#Hotstring *?

SendMode Input
SetWorkingDir %A_ScriptDir%

PrintScreen::AppsKey

;;;;;;;;;;;;;;;;;;;;
;; Czech alphabet ;;
;;;;;;;;;;;;;;;;;;;;
; a
::a\'::á
; b
; c
::c\v::č
; d
::d\v::ď
; e
::e\'::é
::e\v::ě
; f
; g
; h
; ch
; i
::i\'::í
; j
; k
; l
; m
; n
::n\v::ň
; o
::o\'::ó
; p
; q
; r
::r\v::ř
; s
::s\v::š
; t
::t\v::ť
; u
::u\'::ú
::u\o::ů
; v
; w
; x
; y
::y\'::ý
; z
::z\v::ž

;;;;;;;;;;;;;;;;;;;
;; Pāli alphabet ;;
;;;;;;;;;;;;;;;;;;;
; a
::a\-::ā
; i
::i\-::ī
; u
::u\-::ū
; e
; ?
; o
; ?
; k
; kh
; g
; gh
::n\>::ṅ
; c
; ch
; j
; jh
::n\~::ñ
::t\.::ṭ
; ṭh
::d\.::ḍ
; ḍh
::n\.::ṇ
; t
; th
; d
; dh
; n
; p
; ph
; b
; bh
; m
; y
; r
; l
; v
; s
; h
::l\.::ḷ
::m\>::ṁ
::m\.::ṃ
