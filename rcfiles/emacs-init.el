;;
;; Emacs initialization file
;;
;; Emacs version >= 24 required!
;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(magit flycheck-rust racer company smart-mode-line flycheck rainbow-delimiters solarized-theme)))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; The individual lisp files do all the work!
(require 'init-elpa)
(require 'init-ui)
(require 'init-editing)
(require 'init-navigation)
(require 'init-miscellaneous)
(require 'init-rust)
(require 'init-vc)

(provide 'init)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:
