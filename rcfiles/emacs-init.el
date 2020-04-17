;; Use ttf-hack as the default font.
;; Use comic sans ms for the modeline.
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal family "Hack"))))
 '(fixed-pitch ((t (:inherit default))))
 '(font-lock-comment-face ((t (:foreground "DodgerBlue1"))))
 '(mode-line ((t (:background "LightSalmon" :foreground "black" :box (:line-width -1 :style released-button) :height 1.0 :family "comic sans ms"))))
 '(mode-line-buffer-id ((t (:background "LightSalmon" :foreground "black" :weight bold :height 1.0 :family "comic sans ms"))))
 '(mode-line-emphasis ((t (:background "LightSalmon" :foreground "black" :weight bold :height 1.0 :family "comic sans ms"))))
 '(mode-line-highlight ((t (:inherit mode-line))))
 '(mode-line-inactive ((t (:inherit mode-line :inverse-video t)))))

;; Start up the emacsclient server.
(server-start)

;;; We require emacs >= 24!

;;; See melpa.org.
;(require 'package)
;(add-to-list 'package-archives
;             '("melpa" . "https://melpa.org/packages/") t)
;(package-initialize)
;(package-refresh-contents)

;; Use the solarized theme.
(add-to-list 'custom-theme-load-path (concat (getenv "SCMROOT") "/emacs-color-theme-solarized"))
(load-theme 'solarized t)

;; Save the session for next time.
(desktop-save-mode 1)

;; Turn off the tool bar.
(tool-bar-mode -1)

;; Show matching parentheses.
(show-paren-mode 1)
(eldoc-mode 1)

;; I've been using gnus for a long time; I guess that makes me an expert.
(setq gnus-expert-user t)
(setq gnus-novice-user nil)
 
;; Track the column number in the modeline.
(setq column-number-mode t)

;; Put the scroolbar on the right
(set-scroll-bar-mode 'right)

;; Set transparency of emacs
(set-frame-parameter (selected-frame) 'alpha '(92 88))
(add-to-list 'default-frame-alist '(alpha 92 88))

;; Local Variables: ***
;; End: ***
