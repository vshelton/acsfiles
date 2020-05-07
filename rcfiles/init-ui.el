(require 'init-elpa)

;; (require-package 'golden-ratio)
;; (require 'golden-ratio)

(setq inhibit-startup-message t)
;; (menu-bar-mode -1)

;; Turn off the tool bar.
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

;; Put the scrollbar on the right.
(when (fboundp 'set-scroll-bar-mode)
  (set-scroll-bar-mode 'right))

(setq
      select-enable-clipboard t
      select-enable-primary t
      save-interprogram-paste-before-kill t
      apropos-do-all t)

(set-cursor-color "yellow3")

;; (golden-ratio-mode 1)

;; Set the transparency of emacs.
(set-frame-parameter (selected-frame) 'alpha '(92 88))
(add-to-list 'default-frame-alist '(alpha 92 88))

;; Use a solarized color scheme.
;; This scheme came from https://github.com/bbatsov/solarized-emacs.
;; The solarized homepage is https://ethanschoonover.com/solarized.
(require-package 'solarized-theme)
;; (load-theme 'solarized-light t)
(load-theme 'solarized-dark t)

;; Configure the mode-line.
(set-face-font 'mode-line "-*-comic sans ms-medium-r-normal-*-20-*-*-*-*-*-iso8859-*")
(set-face-background 'mode-line "LightSalmon")
(set-face-foreground 'mode-line "Black")
(set-face-foreground 'mode-line-inactive "LightSalmon")
(set-face-background 'mode-line-inactive "Black")
(set-face-foreground 'mode-line-buffer-id "DodgerBlue3")

(provide 'init-ui)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:
