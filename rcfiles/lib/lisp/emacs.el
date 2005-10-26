;;
;; This initialization file is called for both FSF emacs and XEmacs.
;; It assumes we're running some version of emacs 19.
;; With the current versions (FSF 19.34 and XEmacs 19.16),
;; this file must be compiled by XEmacs in order to be loaded in both.
;;

;; Currently this is only required in FSF emacs 19.34
(when (not (fboundp 'custom-set-variables))
  (pushnew (expand-file-name "~/lib/lisp/fsf/custom")
	   load-path :test 'equal)
  (load "custom"))

;; Load different customizations for XEmacs and FSF emacs.
;; Load the customizations here so they can affect the
;; remainder of this file.
;;	1. .emacs
;;	2. first part of lib/lisp/emacs.el
;;	3. lib/lisp/[emacs-type]/acs-custom.el
;;	4. remainder of lib/lisp/emacs.el
;;	5. lib/lisp/[emacs-type]/default.el
;; after-init-hook is used to ensure that the custom file
;; is only loaded once.
(setq custom-file nil
      acs::custom-file (expand-file-name (concat "~/lib/lisp/"
						 (emacs-type)
						 "/acs-custom.el")))
(load acs::custom-file)
(add-hook 'after-init-hook
	  (lambda ()
	    (setq custom-file acs::custom-file)))

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
;(require 'iswitchb)
;(iswitchb-default-keybindings)
(require 'uniquify)

;; Starting with version 20 in both versions of emacs,
;; just loading the package is no longer sufficient
(when (fboundp 'auto-compression-mode)
  (setq uniquify-buffer-name-style 'post-forward)
  (auto-compression-mode 1))

;; Cut and paste is way slow under Motif
;;(when (boundp 'interprogram-cut-function)
;;	      (setq interprogram-cut-function nil
;;		    interprogram-paste-function nil))
(when (boundp 'x-selecton-strict-motif-ownership)
  (setq x-selection-strict-motif-ownership nil))

;; XEmacs supports mic-paren without X.
(when (or (featurep 'xemacs) window-system)
  (require 'mic-paren)
  (setq paren-sexp-mode t)
  (set (if (boundp 'paren-face) 'paren-face 'paren-match-face) 'underline)
  (and (fboundp 'paren-activate) (paren-activate)))

;; Simplify yes-no questions
(fset 'yes-or-no-p 'y-or-n-p)

;; Big brother database
(and (fboundp 'bbdb-initialize)
     (require 'bbdb)
     (bbdb-initialize 'gnus 'message))

;; Load popper
;(load "popper")
;(setq popper-inhibit-warnings	t
;      help-selects-help-window	nil
;      window-min-height		2
;      scroll-step		1
;      scroll-on-clipped-lines	nil
;      pop-up-frames		nil
;      pop-up-windows		t
;      temp-buffer-shrink-to-fit	t
;      split-window-keep-point	nil)
;(popper-install)

;; Map the menu key to the electric buffer list
(require 'ebuff-menu)
(define-key global-map			  '[menu] 'electric-buffer-list)
(define-key electric-buffer-menu-mode-map '[menu] 'Electric-buffer-menu-quit)

;; Under Exceed, the menu key shows up as shift f10
(define-key global-map                    [(shift f10)] 'electric-buffer-list)
(define-key electric-buffer-menu-mode-map [(shift f10)] 'Electric-buffer-menu-quit)

;; Stolen from XEmacs 21.0; used for M-z
(when (not (fboundp 'zap-up-to-char))
  (defun zap-up-to-char (arg char)
    "Kill up to ARG'th occurrence of CHAR.
Goes backward if ARG is negative; error if CHAR not found."
    (interactive "*p\ncZap up to char: ")
    (kill-region (point) (progn
			   (search-forward (char-to-string char) nil nil arg)
			   (goto-char (if (> arg 0) (1- (point)) (1+ (point))))
			   (point)))))

;;; 21.2 tabs only on WinDoze
(defmacro when-specifierp (specifier &rest form)
  `(when (and (boundp ',specifier)
	     (specifierp ,specifier))
    ,@form))
(put 'when-specifierp 'lisp-indent-function 1)

(unless (string-match "win32" system-configuration)
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
(defun emacs-term (program)
  "Start a terminal-emulator in a new buffer.
The buffer is in Term mode; see `term-mode' for the
commands to use in that buffer.

\\<term-raw-map>Type \\[switch-to-buffer] to switch to another buffer."
  (interactive (list (read-from-minibuffer "Run program: "
					   (or explicit-shell-file-name
					       (getenv "ESHELL")
					       (getenv "SHELL")
					       "/bin/sh"))))
  ;; Run the shell in login mode
  (set-buffer (make-term "terminal" program nil "-l"))
  (term-mode)
  (term-char-mode)
  (switch-to-buffer "*terminal*"))
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

(when (boundp 'focus-follows-mouse)			; new in 19.15
  (setq focus-follows-mouse t))

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
(define-key acs::keymap		"B"	(function
					 (lambda ()
					   (interactive)
					   (electric-buffer-list t))))
(define-key acs::keymap		"a"	'auto-fill-mode)
(define-key acs::keymap		"b"	'electric-buffer-list)
(define-key acs::keymap		"f"	'font-lock-mode)
(define-key acs::keymap		"g"	'grep)
(define-key acs::keymap		"m"	'compile)
(define-key acs::keymap		"o"	'occur)
(define-key acs::keymap		"t"	'toggle-tab-width)
(define-key acs::keymap		"w"	'what-line)
(define-key acs::keymap		"x"	'text-mode)

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
(setq-default font-lock-auto-fontify nil
	      font-lock-use-fonts '(or (mono) (grayscale))
	      font-lock-use-colors '(color)
	      font-lock-maximum-decoration '((c++-mode . 2) (c-mode . 2) (t . 1))
	      font-lock-maximum-size 256000
	      font-lock-mode-enable-list nil
	      font-lock-mode-disable-list '(makefile-mode compilation-mode))
(require 'font-lock)

;; Specify on-demand fontifying
(when (load "lazy-shot" t)
  (add-hook 'font-lock-mode-hook 'turn-on-lazy-shot)
  (setq-default font-lock-auto-fontify t
		lazy-shot-verbose nil
		lazy-shot-stealth-verbose nil))

;; Turn on auto-fill-mode in text mode
(add-hook 'text-mode-hook 'turn-on-auto-fill)

(setq ediff-window-setup-function 'ediff-setup-windows-plain)
(setq ediff-use-long-help-message nil)

(setq explicit-zsh-args '("-l"))
(setq html-helper-htmldtd-version
      "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 3.2 Final//EN\">\n")
(autoload 'cvs-update "pcl-cvs" nil t)

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

(when (string-match "win32" system-configuration)
;  (setq shell-command-switch "-c")
  (add-hook 'shell-mode-hook
	    '(lambda () (setq comint-completion-addsuffix '("/" . " ")))))

;; Allow grep to work with cmd.exe
(if (string-match "cmd\.exe" shell-file-name)
    (defadvice grep (around use-backslash)
      "Remap directory-sep-char to backslash before calling grep"
      (let ((directory-sep-char "\\"))
	ad-do-it)))

;; XEmacs-specific stuff
(cond ((featurep 'xemacs)

       ;; Make shift tab insert a tab character
       (define-key global-map	'iso-left-tab	(function
						 (lambda ()
						   (interactive)
						   (insert "\011"))))
       ;; Use the mouse wheel
       (mwheel-install)
       (setq mwheel-follow-mouse t)

       ;; Menubar-specific functions
       (when (featurep 'menubar)
	 (require 'detached-minibuf)
	 (cond ((getenv "USE_DETACHED_MINIBUFFER")
		(make-detached-minibuf)

		(defun autoraise-minibuffer-frame-hook ()
		  (if (frame-minibuffer-only-p (selected-frame))
		      (raise-frame)
		    (lower-frame default-minibuffer-frame)))
		(add-hook 'select-frame-hook 'autoraise-minibuffer-frame-hook)

		(setq default-frame-plist 
		      (plist-put default-frame-plist 'minibuffer nil))))

	 (require 'recent-files)
	 (setq recent-files-menu-path '("File")
	       recent-files-add-menu-before "Open..."
	       recent-files-non-permanent-submenu nil
	       recent-files-permanent-submenu nil
	       recent-files-permanent-first nil
	       recent-files-dont-include '("\.newsrc" "Mail/archive"))
	 (recent-files-initialize)

	 ;; In pre-21.2 XEmacs, add rectangle functions to
	 ;; the menubar under the 'Edit' menu.
	 ;; purecopy-menubar went away in XEmacs 21.2.
	 (cond ((fboundp 'purecopy-menubar)
		(let ((entry-name "Search..."))
		  (add-menu-button '("Edit")
				   ["Rectangle Cut" kill-rectangle (mark)]
				   entry-name)
		  (add-menu-button '("Edit")
				   ["Rectangle Paste" yank-rectangle t]
				   entry-name)
		  (add-menu-button '("Edit")
				   ["Rectangle Open" open-rectangle (mark)]
				   entry-name)
		  (add-menu-button '("Edit")
				   ["Rectangle Insert-String" string-rectangle (mark)]
				   entry-name)
		  (add-menu-button '("Edit")
				   ["Mouse Rectangle" track-rectangle
				    (not mouse-track-rectangle-p)]
				   entry-name)
		  (add-menu-button '("Edit")
				   ["Mouse Rectangle Off" track-rectangle
				    mouse-track-rectangle-p]
				   entry-name)
		  (add-menu-button '("Edit")
				   "----"
				   entry-name)))))

       ;; Emulate FSF emacs mouse bindings for extend and cut.
       ;; FSF emacs binds this to button 3, we'll bind it
       ;; to shift button 1
       (defun define-mouse-cut (key nclicks)
	 "Extend and cut a selection via a mouse key."
	 (interactive)

	 ;; Define the variables needed by the hook function
	 (let* ((modifiers (if (listp key)
			       (nreverse (copy-sequence key))
			     (list key)))
		(button (let
			    ((k (car modifiers)))
			  (cond ((equal k 'button1) 1)
				((equal k 'button2) 2)
				((equal k 'button3) 3)
				((equal k 'button4) 4)
				((equal k 'button5) 5)
				((error "Illegal mouse button %s" k)))))
		(modifiers (sort (cdr modifiers) 'string<)))

	   ;; Now make sure the key is defined
	   (define-key global-map key 'mouse-track-adjust)

	   ;; Now add the hook function
	   (add-hook 'mouse-track-click-hook
		     `(lambda (ev cnt)
			(and (= cnt ,nclicks)
			     (= (event-button ev) ,button)
			     (equal (sort (event-modifiers ev) 'string<)
				    ',modifiers)

			     ;; Since kill-region returns non-nil, this hook
			     ;; will prevent following hooks from executing
			     (kill-region (point) (mark)))))))

       (define-mouse-cut '(shift button1) 2)

       ;; This piece of advice forces the mouse adjustments to be relative
       ;; to point (like FSF emacs), rather than relative to the previous
       ;; mouse click.  This means that it's not possible to click with
       ;; button 1 and then scroll down a page or more and define a region
       ;; with shift button 1.
       (defadvice mouse-track-adjust (before acs::mouse-adjust activate compile)
	 "Force mouse tracking to use point rather than the previous mouse-click"
	 (setq default-mouse-track-previous-point (point)))

       ;; Use pending delete
       (if (fboundp 'turn-on-pending-delete)
	   (turn-on-pending-delete)
	 (require 'pending-del)
	 (pending-delete-on nil))
       (and (boundp 'pending-delete-modeline-string)
	    (setq pending-delete-modeline-string nil))
       (add-spec-list-to-specifier modeline-shadow-thickness
				   '((global (nil . 2))))

       ;; Delete deletes the current character.
       ;; Backspace deletes the previous character.
       ;; Use spiffy new mechanism for XEmacs 20.
       ;; Make M-Delete delete the previous word, because that's how zsh does it.
       (if (boundp 'delete-key-deletes-forward)
	   (progn
	     (setq delete-key-deletes-forward t)
	     (define-key global-map '(meta delete) 'backward-kill-word))

	 ;; Less-spiffy XEmacs 19 version
	 (keyboard-translate 'delete    'deletechar)
	 (keyboard-translate 'backspace 'delete)
	 (define-key global-map '(meta deletechar) 'backward-kill-word))

       (define-key global-map '(shift button2)	'mouse-track-do-rectangle)

       ;; Make the default frame smaller without a minibuffer
       ;; This has to be done as late as possible, after the initial
       ;; frame has been instantiated.
       (when (and (getenv "ONE_MINIBUFFER")
		  (console-on-window-system-p))
	 (defun acs::after-window-init ()
	   (setq default-frame-plist (plist-put default-frame-plist
						'minibuffer nil)))
	 (setq window-setup-hook 'acs::after-window-init))

       ;; Load the server to allow remote editing
       (require 'gnuserv)
       (when (gnuserv-start)
	 (and (fboundp 'gnuserv-special-frame-function)
	      (setq gnuserv-frame 'gnuserv-special-frame-function)))

       ;; Specials for text mode
       (require 'filladapt)
       (add-hook 'text-mode-hook 'turn-on-filladapt-mode)

       ;; These functions are automatically built into infodock
       (when (not (boundp 'infodock-version))

	 ;; Load func-menu to allow a display of a function menu
	 (require 'func-menu)

	 (setq fume-menubar-menu-location nil)
	 (setq-default fume-auto-rescan-buffer-p nil)
	 (add-hook 'find-file-hooks 'fume-add-menubar-entry)
	 (define-key acs::keymap "j" 'fume-prompt-function-goto)
	 (define-key acs::keymap "l" 'function-menu)
	 (define-key global-map '(shift button3) 'mouse-function-menu)))

      ;; FSF Emacs 19+
      (t

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

       ;; Load lazy-lock to make the pretty stuff fast
       (global-font-lock-mode t)
       (setq font-lock-support-mode 'lazy-lock-mode)

       (setq suggest-key-bindings 1)))

;; Local Variables:
;; eval: (setq tab-width 8)
;; eval: (setq indent-tabs-mode t)
;; End:
