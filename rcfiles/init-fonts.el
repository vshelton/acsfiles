
;; Use Cascadia Code as the default font.
;; (set-face-font 'default "-*-Cascadia Code-medium-r-normal-*-24-*-*-*-*-*-iso8859-*")
(set-frame-font "Cascadia Code-13" nil t)

;; Configure the mode-line, using Comic Sans.
(set-face-font 'mode-line "-*-Comic Sans ms-medium-r-normal-*-20-*-*-*-*-*-iso8859-*")
(set-face-background 'mode-line "LightSalmon")
(set-face-foreground 'mode-line "Black")
(set-face-foreground 'mode-line-inactive "LightSalmon")
(set-face-background 'mode-line-inactive "Black")
(set-face-foreground 'mode-line-buffer-id "DodgerBlue3")

;; Set miscellaneous font details.
(set-face-foreground 'font-lock-comment-face "DodgerBlue1")
(set-face-foreground 'scroll-bar "gainsboro")
(set-face-background 'scroll-bar "gray2")

(provide 'init-fonts)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:
