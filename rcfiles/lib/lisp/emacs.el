;;
;; This initialization file is called for both FSF emacs and XEmacs.

;; Load different customizations for XEmacs and FSF emacs.
;; Load the customizations here so they can affect the
;; remainder of this file.  Here's the execution order:
;;	1. .emacs
;;	2. lib/lisp/[emacs-type]/acs-custom.el
;;	3. lib/lisp/emacs.el
;;	4. lib/lisp/[emacs-type]/default.el
;; after-init-hook is used to ensure that the custom file
;; is only loaded once.
(setq custom-file nil
      acs::custom-file (locate-library "acs-custom.el"))
(load acs::custom-file)
(add-hook 'after-init-hook
	  (lambda ()
	    (setq custom-file acs::custom-file)))

;; Set faces and colors
;; I'm using set-face-font here rather than customize-face because:
;; (set-face-font 'default "-*-dejavu sans mono-medium-r-normal--12-*-*-*-m-*-iso8859-1")
;;   ==> -misc-dejavu sans mono-medium-r-normal--12-87-100-100-m-0-iso8859-1
;; customize-face 'default "dejavu sans mono" "12px"
;;   ==> -*-dejavu sans mono-medium-r-*-*-*-90-*-*-*-*-iso8859-*
;; customize-face 'default "dejavu sans mono" "11.9px"
;;   ==> -*-dejavu sans mono-medium-r-*-*-*-80-*-*-*-*-iso8859-*
;; I don't know any way to get the -87- font using customize.
(and (featurep 'xemacs)
     (set-face-font 'default "-*-dejavu sans mono-medium-r-normal--12-*-*-*-m-*-iso8859-1")
     (set-face-foreground 'default "LightYellow")
     (set-face-background 'default "Black"))

(put 'narrow-to-region 'disabled nil)
(put 'eval-expression 'disabled nil)
(setq frame-title-format			; set titlebar title
      (concat (if (featurep 'xemacs) "XEmacs" "emacs")
	      "@" (let ((node (string-match "[^.]*" (system-name))))
		    (match-string 0 (system-name)))
	      " ["
	      (if (not (featurep 'xemacs)) "FSF ")
	      (format "%d.%d" emacs-major-version emacs-minor-version)
	      (if (string-match "\\( (beta *[0-9]+)\\)" emacs-version)
		  (substring emacs-version
			     (match-beginning 1) (match-end 1)))
	      "]  %b"))

;; Load various modes
(autoload 'tar-mode "tar-mode")			; before jka-compr
(require 'jka-compr)
(require 'uniquify)

;; Starting with version 20 in both versions of emacs,
;; just loading the package is no longer sufficient
(when (fboundp 'auto-compression-mode)
  (setq uniquify-buffer-name-style 'post-forward)
  (auto-compression-mode 1))

;; Cut and paste is way slow under Motif
(when (boundp 'x-selecton-strict-motif-ownership)
  (setq x-selection-strict-motif-ownership nil))

;; XEmacs supports mic-paren without X.
(when (or
       (featurep 'xemacs)
       window-system)
  (require 'mic-paren)
  (setq paren-sexp-mode t)
  (set (if (boundp 'paren-face) 'paren-face 'paren-match-face) 'underline)
  (and (fboundp 'paren-activate) (paren-activate)))

;; Simplify yes-no questions
(fset 'yes-or-no-p 'y-or-n-p)

;; Load the electric buffer support
(require 'ebuff-menu)

;;; Buffer tabs only on Windows
(defmacro when-specifierp (specifier &rest form)
  `(when (and (boundp ',specifier)
	     (specifierp ,specifier))
     ,@form))
(put 'when-specifierp 'lisp-indent-function 1)

(unless (string-match "win32\\|cygwin" system-configuration)
  (when-specifierp default-gutter-visible-p
    (set-specifier default-gutter-visible-p nil)
    (setq gutter-visible-p nil)))

(when-specifierp default-toolbar-visible-p
  (set-specifier default-toolbar-visible-p nil))

; Make shift-insert work as in an XTerm.  This allows mouse selection
; and pasting to work in a terminal window as it does in an XTerm.
(if (fboundp 'insert-selection)
    (define-key global-map [(shift insert)] 'insert-selection)
  (define-key global-map [(shift insert)] 'clipboard-yank))

;;
;; Utility functions
;;
(defun match-paren (arg)
  "Go to the matching parenthesis if on parenthesis otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(")
	 (forward-list 1)
	 (backward-char 1))
	((looking-at "\\s\)")
	 (forward-char 1)
	 (backward-list 1))
	(t (self-insert-command (or arg 1)))))
(defun scroll-one-line-down (&optional arg)
  "Scroll the selected window down (backward in the text) one line (or N lines)."
  (interactive "p")
  (scroll-down (or arg 1)))
(defun scroll-one-line-up (&optional arg)
  "Scroll the selected window up (forward in the text) one line (or N lines)."
  (interactive "p")
  (scroll-up (or arg 1)))
(defun set-tab-width (&optional arg)
  "Set the width of a tab character to the specified number of spaces"
  (interactive "NEnter new tab width: ")
  (setq tab-width arg)
  (redraw-frame (selected-frame)))
(defun toggle-tab-width ()
  "Toggle tab width between 4 and 8 spaces"
  (interactive)
  (if (eq tab-width 8)
      (set-tab-width 4)
    (set-tab-width 8)))
(defun tabs-4 ()
  (interactive)
  (set-tab-width 4))
(defun tabs-8 ()
  (interactive)
  (set-tab-width 8))

;; Original code from badii@psi.ch (since modified)
(defun end-key ()
  "Move the cursor to the end of the line.
If the cursor is already at eol, move to eol on the next line.
Extends the region if it exists."
  (interactive)
  (and (boundp 'zmacs-region-stays)
       (setq zmacs-region-stays t))
  (if (not (eobp))
      (if (eolp)
	  (progn
	    (forward-line)
	    (end-of-line))
	(end-of-line))))
(defun home-key ()
  "Move the cursor to the beginning of the line.
If the cursor is already at bol, move to bol on the previous line.
Extends the region if it exists."
  (interactive)
  (and (boundp 'zmacs-region-stays)
       (setq zmacs-region-stays t))
  (if (not (bobp))
      (if (bolp)
	  (forward-line -1)
	(beginning-of-line))))

(defun track-rectangle ()
  "Toggles the state of the mouse-track-rectangle-p"
  (interactive)
  (setq mouse-track-rectangle-p (not mouse-track-rectangle-p)))

;;
;; Key bindings
;;
(define-key global-map	"%"		'match-paren)	; % like vi
(define-key global-map	[(meta up)]	'scroll-one-line-up)
(define-key global-map	[(meta down)]	'scroll-one-line-down)
(define-key global-map	[end]		'end-key)
(define-key global-map	[home]		'home-key)
(define-key global-map	[(meta z)]	'zap-up-to-char)
(define-key global-map	[(shift prior)]	'scroll-other-window-down)
(define-key global-map	[(shift next)]	'scroll-other-window)

;; Build my own prefix and attach it to f2
(setq acs::keymap (make-sparse-keymap))
(define-key global-map	[f2]	acs::keymap)

(define-key acs::keymap		"%"	'query-replace-regexp)
(define-key acs::keymap		"4"	'tabs-4)
(define-key acs::keymap		"8"	'tabs-8)
; f2 B brings up a narrowed electric buffer list
(define-key acs::keymap		"B"	(function
					 (lambda ()
					   (interactive)
					   (electric-buffer-list t))))
(define-key acs::keymap		"a"	'auto-fill-mode)
; f2 b brings up an electric buffer list
(define-key acs::keymap		"b"	'electric-buffer-list)
(define-key acs::keymap		"f"	'font-lock-mode)
(define-key acs::keymap		"g"	'grep)
(define-key acs::keymap		"m"	'compile)
(define-key acs::keymap		"o"	'occur)
(define-key acs::keymap		"t"	'toggle-tab-width)
(define-key acs::keymap		"w"	'what-line)
(define-key acs::keymap		"x"	'text-mode)
;(define-key global-map			  '[menu] 'electric-buffer-list)
;(define-key electric-buffer-menu-mode-map '[menu] 'Electric-buffer-menu-quit)

(define-key electric-buffer-menu-mode-map [f2 b] 'Electric-buffer-menu-quit)

;; If not under X, make sure the backspace key deletes the previous character.
(and (not window-system)
     (define-key global-map "\C-h" 'backward-delete-char-untabify))

;;
;; Searching stuff
;;  - make all searches case-insensitive by default
;;
(define-key isearch-mode-map [(meta s)]	'isearch-toggle-regexp)
(define-key isearch-mode-map [(meta i)]	'isearch-toggle-case-fold)
(setq case-fold-search t
      case-replace t)

;: Make electric buffer swap top buffers by default
(setq electric-buffer-menu-mode-hook
      (function
       (lambda ()
	 (interactive)
	 (forward-line))))

;;
;; Customizations for both c-mode and c++-mode
;;
(defconst acs::c-style
  '("PERSONAL"
    (c-basic-offset . 4)
    (c-comment-only-line-offset . 0)
    (c-tab-always-indent . nil)
    (c-hanging-braces-alist . ((substatement-open after)
			       (brace-list-open)))
    (c-hanging-colons-alist . ((member-init-intro before)
			       (inher-intro)
			       (case-label after)
			       (label after)
			       (access-label after)))
    (c-cleanup-list . (scope-operator
		       empty-defun-braces
		       defun-close-semi))
    (c-offsets-alist . ((arglist-close . c-lineup-arglist)
			(statement-cont . c-lineup-math)
			(statement-block-intro . +)
			(knr-argdecl-intro . +)
			(substatement-open . 0)
			(label . -)
			(case-label . 0)
			(block-open . 0)
			))
    (c-echo-syntactic-information-p . nil))
  "My C Programming Style")

(defun acs::c-mode-hook ()
  ;; set up for my perferred indentation style, but only do it once
  (let ((my-style "PERSONAL"))
    (or (assoc my-style c-style-alist)
	(setq c-style-alist (cons acs::c-style c-style-alist)))
    (c-set-style my-style))

  ;; keybindings for C, C++, and Objective-C.  We can put these in
  ;; c-mode-map because c++-mode-map and objc-mode-map inherit it
  (define-key c-mode-map "\C-m" 'newline-and-indent)

  (setq tab-width 8))
(add-hook 'c-mode-common-hook 'acs::c-mode-hook)

;;
;; Perl mode
;;
(autoload 'perl-mode "cperl-mode" "alternate mode for editing Perl programs" t)
(defun acs::perl-mode-hook ()
  "My Perl-mode hook"
  (setq cperl-electric-keywords t
	cperl-indent-level 4
	cperl-label-offset 0
	cperl-min-label-indent 0
	cperl-continued-statement-offset 4
	tab-width 8))
(add-hook 'cperl-mode-hook 'acs::perl-mode-hook)

;;
;; Load font-lock to make source code look nice
;;
(setq font-lock-auto-fontify t
      font-lock-maximum-decoration '((c++-mode . 2) (c-mode . 2) (t . 1))
      font-lock-mode-enable-list nil
      font-lock-mode-disable-list '(makefile-mode compilation-mode))
(require 'font-lock)

;; Turn on auto-fill-mode in text mode
(add-hook 'text-mode-hook 'turn-on-auto-fill)

(setq ediff-window-setup-function 'ediff-setup-windows-plain)
(setq ediff-use-long-help-message nil)

(setq html-helper-htmldtd-version
      "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 3.2 Final//EN\">\n")

;; Customize patcher
(and (fboundp 'patcher-version)
     (setq patcher-default-mail-method 'fake
	   patcher-projects
	   '(("21.4"
	      "~/scmroot/xemacs-21.4"
	      :to-address "xemacs-patches@xemacs.org"
	      :themes (mercurial)
	      :diff-command "hg diff"
	      :change-logs-updating manual)
	     ("21.5"
	      "~/scmroot/xemacs-21.5"
	      :inheritance "21.4")
	     ("packages"
	      "~/scmroot/xemacs-packages"
	      :inheritance "21.4"))))

;; Local Variables:
;; eval: (setq tab-width 8)
;; eval: (setq indent-tabs-mode t)
;; End:
