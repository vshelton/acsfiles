(require 'init-elpa)
(require 'ido)
(require-package 'ido-ubiquitous)

(ido-mode t)
(setq ido-enable-flex-matching t)
(setq ido-use-filename-at-point nil)
(setq ido-auto-merge-work-directories-length -1)
(setq ido-use-virtual-buffers t)

(ido-ubiquitous-mode 1)

;; Shows a list of buffers
(global-set-key (kbd "C-x C-b") 'ibuffer)

(provide 'init-navigation)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:
