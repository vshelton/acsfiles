;; FSF emacs-specific customizations.
;; This file gets executed after acs-custom.el
;(message "Entering default.el")

;; Start up the emacsclient server
(server-start)

;; Delete removes character under point
(define-key global-map [delete]			'delete-char)

;; Make shift tab insert a tab character
(define-key global-map [(shift iso-lefttab)]	(function
						 (lambda ()
						   (interactive)
						   (insert "\011"))))

;; Use the nifty mouse tracking stuff
(and (not window-system)
     (equal (getenv "TERM") "xterm")
     (xterm-mouse-mode 1))

;; Use "active" regions
(delete-selection-mode t)
(transient-mark-mode t)

(global-font-lock-mode t)
(or
 (and (fboundp 'jit-lock-mode)
      (setq font-lock-support-mode 'jit-lock-mode))
 (setq font-lock-support-mode 'lazy-lock-mode))

(setq suggest-key-bindings 1)

(setq te-stty-string "stty -nl erase '^h' kill '^u' intr '^c' echo")

(and (fboundp 'set-scroll-bar-mode) (set-scroll-bar-mode 'right))

(and (fboundp 'fringe-mode) (fringe-mode '(1 . 1)))

(defun emacs-term (program)
  "Start a terminal-emulator in a new buffer.
The buffer is in Term mode; see `term-mode' for the
commands to use in that buffer.

\\<term-raw-map>Type \\[switch-to-buffer] to switch to another buffer."
  (interactive (list (read-from-minibuffer
		      "Run program: "
		      (or (and
			   (boundp 'explicit-shell-file-name)
			   explicit-shell-file-name)
			  shell-file-name
			  (getenv "ESHELL")
			  (getenv "SHELL")
			  "/bin/sh"))))
  ;; Run the shell in login mode
  (set-buffer (make-term "terminal" program nil "-l"))
  (term-mode)
  (term-char-mode)
  (switch-to-buffer "*terminal*"))
; Configure term.el
(setq term-buffer-maximum-size 0
      ansi-term-color-vector
      [nil "black" "red" "green" "yellow" "steel blue"
	   "magenta" "cyan" "white"])

(defun acs::term-mode-hook ()
  "My hook for terminal mode"
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")
  (make-local-variable 'mouse-yank-at-point)
  (make-local-variable 'transient-mark-mode)
  (setq mouse-yank-at-point t)
  (setq transient-mark-mode nil)
  (auto-fill-mode -1)
  (setq tab-width 8)
  ; Make '.', '-' and '/' part of words for mouse highlighting
  (modify-syntax-entry ?. "w")
  (modify-syntax-entry ?- "w")
  (modify-syntax-entry ?/ "w"))
(add-hook 'term-mode-hook 'acs::term-mode-hook)

;; Set transparency of emacs
(set-frame-parameter (selected-frame) 'alpha '(85 50))
(add-to-list 'default-frame-alist '(alpha 85 50))
(defun acs::frame-transparency (value)
  "Sets the transparency of the frame window. 0=transparent/100=opaque"
  (interactive "nTransparency Value 0 - 100 opaque:")
  (set-frame-parameter (selected-frame) 'alpha value))

;(message "Leaving default.el")

;; Local Variables:
;; eval: (setq tab-width 8)
;; eval: (setq indent-tabs-mode t)
;; End:
