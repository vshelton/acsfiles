(require 'init-elpa)
(require-package 'rainbow-delimiters)
(require-package 'flycheck)

;; Start up the emacsclient server.
(server-start)

;; Save the session for next time.
(desktop-save-mode 1)

;; Highlights matching parenthesis
(show-paren-mode 1)

;; Highlight current line
;; (global-hl-line-mode 1)

(eldoc-mode 1)

(define-key global-map (kbd "RET") 'newline-and-indent)

(add-hook 'after-init-hook #'global-flycheck-mode)

;; When you visit a file, point goes to the last place where it
;; was when you previously visited the same file.
;; http://www.emacswiki.org/emacs/SavePlace

(setq-default save-place t)
;; keep track of saved places in ~/.emacs.d/places
(setq save-place-file (concat user-emacs-directory "places"))

;; Emacs can automatically create backup files. This tells Emacs to
;; put all backups in ~/.emacs.d/backups. More info:
;; http://www.gnu.org/software/emacs/manual/html_node/elisp/Backup-Files.html
(setq backup-directory-alist `(("." . ,(concat user-emacs-directory "backups"))))
(setq auto-save-default nil)

(defun toggle-comment-on-line ()
  "Comment or uncomment current line."
  (interactive)
  (comment-or-uncomment-region (line-beginning-position) (line-end-position)))
(global-set-key (kbd "C-;") 'toggle-comment-on-line)

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(provide 'init-editing)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:
