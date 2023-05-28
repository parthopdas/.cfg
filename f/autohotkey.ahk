;;
;; Based on https://pastebin.com/eRADkvuN + adapted for ahk v2
;;

#Warn
#SingleInstance force
#Hotstring *?

SendMode "Input"
SetWorkingDir A_InitialWorkingDir

PrintScreen::AppsKey

;;;;;;;;;;;;;;;;;;;;
;; Polish alphabet ;;
;;;;;;;;;;;;;;;;;;;;
; a
; A
; ą
::a\,::ą
; Ą
::A\,::Ą
; b
; B
; c
; C
; ć
::c\'::ć
; Ć
::C\'::Ć
; d
; D
; e
; E
; ę
::e\,::ę
; Ę
::E\,::Ę
; f
; F
; g
; G
; h
; H
; i
; I
; j
; J
; k
; K
; l
; L
; ł
::l\/::ł
; Ł
::L\/::Ł
; m
; M
; n
; N
; ń
::n\'::ń
; Ń
::N\'::Ń
; o
; O
; ó
::o\'::ó
; Ó
::O\'::Ó
; p
; P
; r
; R
; s
; S
; ś
::s\'::ś
; Ś
::S\'::Ś
; t
; T
; u
; U
; w
; W
; y
; Y
; z
; Z
; ź
::z\'::ź
; Ź
::Z\'::Ź
; ż
::z\.::ż
; Ż
::Z\.::Ż

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
