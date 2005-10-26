;; This is my home-specific initialization file
;; (FSF-emacs version)

(defvar grep-command "egrep -n ")

(setq te-stty-string "stty -nl erase '^h' kill '^u' intr '^c' echo")

(and (fboundp 'set-scroll-bar-mode) (set-scroll-bar-mode 'right))

(and (fboundp 'fringe-mode) (fringe-mode 0))
