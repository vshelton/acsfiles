;;
;; Emacs initialization file
;;
;; Emacs version >= 24 required!
;;

;; Use Cascadia Code as the default font.
;; Use comic sans ms for the modeline.
;; If there is more than one custom-set-faces call, they won't work right.
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Cascadia Code" :foundry "microsoft" :height 120))))
 '(fixed-pitch ((t (:inherit default))))
 '(font-lock-comment-face ((t (:foreground "DodgerBlue1"))))
 '(scroll-bar ((t (:foreground "gainsboro" :background "gray2")))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(flycheck-rust racer company smart-mode-line flycheck rainbow-delimiters solarized-theme)))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; The individual lisp files do all the work!
(require 'init-elpa)
(require 'init-ui)
(require 'init-editing)
(require 'init-miscellaneous)
(require 'init-rust)

(provide 'init)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:
