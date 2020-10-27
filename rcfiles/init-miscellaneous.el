(require 'init-elpa)

(require-package 'company)
(require 'company)

(setq company-tooltip-align-annotations t)
(add-hook 'prog-mode-hook 'company-mode)

;; Changes all yes/no questions to y/n type
(fset 'yes-or-no-p 'y-or-n-p)

;; No need for ~ files when editing
(setq create-lockfiles nil)

;; I've been using gnus for a long time; I guess that makes me an expert.
(setq gnus-expert-user t)
(setq gnus-novice-user nil)

;; Track the column number in the modeline.
(setq column-number-mode t)

;; Version control customizations.
(setq vc-follow-symlinks t)

;; Use active regions.
(when (fboundp 'delete-selection-mode)
  (delete-selection-mode t))
(when (fboundp 'transient-mark-mode)
  (transient-mark-mode t))

;; Turn on line number mode and provide a way to toggle it.
;; (global-display-line-numbers-mode)
(global-set-key (kbd "C-M-$") 'display-line-numbers-mode)

(provide 'init-miscellaneous)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:
