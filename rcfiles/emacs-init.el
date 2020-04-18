;;;
;;; Emacs initialization file
;;;
;;; Emacs version >= 24 required!
;;;

;; Start up the emacsclient server.
(server-start)

;; Save the session for next time.
(desktop-save-mode 1)

;; Turn off the tool bar.
(tool-bar-mode -1)

;; Put the scrollbar on the right.
(set-scroll-bar-mode 'right)

;; Show matching parentheses.
(show-paren-mode 1)
(eldoc-mode 1)

;; I've been using gnus for a long time; I guess that makes me an expert.
(setq gnus-expert-user t)
(setq gnus-novice-user nil)
 
;; Track the column number in the modeline.
(setq column-number-mode t)

;; Version control customizations.
(setq vc-follow-symlinks t)

;; Use active regions.
(delete-selection-mode t)
(transient-mark-mode t)

;; Set the transparency of emacs.
(set-frame-parameter (selected-frame) 'alpha '(92 88))
(add-to-list 'default-frame-alist '(alpha 92 88))

;; See melpa.org.
(require 'package)
;(add-to-list 'package-archives
;             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
;(package-refresh-contents)

;; Use a solarized color scheme.
;; This scheme came from https://github.com/bbatsov/solarized-emacs.
;; The solarized homepage is https://ethanschoonover.com/solarized.
;(load-theme 'solarized-light t)
(load-theme 'solarized-dark t)

;; Use Cascadia Code as the default font.
;; Use comic sans ms for the modeline.
;; If there is more than one custom-set-faces call, they won't work right.
(custom-set-faces
 '(default ((t (:family "Cascadia Code" :foundry "microsoft" :height 120))))
 '(fixed-pitch ((t (:inherit default))))
 '(font-lock-comment-face ((t (:foreground "DodgerBlue1"))))
 '(scroll-bar ((t (:foreground "gainsboro" :background "gray2"))))
 '(mode-line ((t (:background "LightSalmon" :foreground "black" :family "comic sans ms"))))
 '(mode-line-inactive ((t (:foreground "LightSalmon" :background "black" :family "comic sans ms"))))
 '(mode-line-buffer-id ((t (:foreground "black")))))

;; Local Variables: ***
;; End: ***
