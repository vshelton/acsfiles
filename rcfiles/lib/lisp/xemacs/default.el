;; XEmacs-specific customizations.
;; Load different customizations for XEmacs and FSF emacs.
;; Load the customizations here so they can affect the
;; remainder of this file.  Here's the execution order:
;;	1. .emacs
;;	2. lib/lisp/[emacs-type]/acs-custom.el
;;	3. lib/lisp/emacs.el
;;	4. lib/lisp/[emacs-type]/default.el
;(message "Entering default.el")

(defun call-cygpath (&optional args)
  "Call cygwin's cygpath function and strip the linefeed"
  (interactive)
  (let ((p (shell-command-to-string (concat "cygpath " args))))
	(if (equal (substring p -1) "\n")
	    (substring p 0 -1)
	  p)))

;; Set up some convenience variables
(setq acs::win32 (string-match "win32" system-configuration)
      acs::cygwin (string-match "cygwin" system-configuration)
      acs::windows-platform (or acs::win32 acs::cygwin))

;; Set up exec-path under cygwin and Windows
(cond
 (acs::cygwin
  (setq exec-path (list
		   (expand-file-name "~/bin")
		   "/usr/local/bin"
		   "/bin"
		   (call-cygpath "--sysdir")
		   (call-cygpath "--windir")
		   exec-directory))
  (setq efs-ftp-program-name "ftp"))

((and acs::win32 (executable-find "cygpath"))
 (setq exec-path (list
; In my usual configuration, /usr/local/bin/zsh is a symlink
; to /usr/local/zsh-yyyy-mm-dd/bin/zsh.  Since cygwin symlinks
; don't work outside of cygwin, and since executable-find will
; find /usr/local/bin/zsh as an executable, a windows native XEmacs
; will get very confused when it tries to execute a shell command.
; Work around this by commenting out the problematic directories.
;		  (expand-file-name "~/bin")
;		  (call-cygpath "--mixed /usr/local/bin")
		  (call-cygpath "--mixed /bin")
		  (call-cygpath "--mixed --sysdir")
		  (call-cygpath "--mixed --windir")
		  exec-directory))))

;; Use a slash to separate directories, but use
;; a blackslash if we're using (ugh!) cmd.exe
(if (not acs::win32)
    (setq directory-sep-char ?/
	  shell-command-switch "-c"
	  shell-file-name (or (executable-find "zsh")
			      (executable-find "bash")
			      (executable-find "cmd")))
  (when (string-match "cmd" shell-file-name)
    (setq directory-sep-char ?\\
	  shell-command-switch "/c")))

;; Work around a specifier bug in modeline under Windows.
;; See http://article.gmane.org/gmane.emacs.xemacs.beta/27406
;(and (or acs::win32 acs::cygwin)
;     (set-face-background 'modeline (face-background-instance 'modeline)))

;; Load and enable version control
(require 'vc)

;; Preserve minibuffer history across sessions
(savehist-mode 1)

;; Use the mouse wheel
(mwheel-install)
(setq mwheel-follow-mouse t)

;; Menubar-specific functions
(when (featurep 'menubar)
  (require 'recent-files)
  (setq recent-files-add-menu-before "Edit"
	recent-files-menu-title "Recent"
	recent-files-dont-include '("\.newsrc" "Mail/archive"))
  (recent-files-initialize))

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

;; Make the default frame smaller without a minibuffer
;; This has to be done as late as possible, after the initial
;; frame has been instantiated.
(when (and (getenv "ONE_MINIBUFFER")
	   (console-on-window-system-p))
  (defun acs::after-window-init ()
    (setq default-frame-plist (plist-put default-frame-plist
					 'minibuffer nil)))
  (setq window-setup-hook 'acs::after-window-init))

;; Load the server to allow remote editing.
;; Under windows, this is handled by site-start.el.
(when (not acs::windows-platform)
  (gnuserv-start)
  (and (fboundp 'gnuserv-special-frame-function)
       (setq gnuserv-frame 'gnuserv-special-frame-function)))

;; Load func-menu to allow a display of a function menu
(require 'func-menu)

(setq fume-menubar-menu-location nil)
(setq-default fume-auto-rescan-buffer-p nil)
(add-hook 'find-file-hooks 'fume-add-menubar-entry)
(define-key acs::keymap "j" 'fume-prompt-function-goto)
(define-key acs::keymap "l" 'function-menu)

(when acs::windows-platform

  ;; Set up a left margin
  (set-specifier left-margin-width 1)
  (setq ispell-program-name (executable-find "aspell")
	nt-fake-unix-uid 1)

  ;; Add /usr/share/info to the info path
  (let* ((ipath "/usr/share/info")
	 (info-dir
	  (if acs::cygwin
	     ipath
	    (concat (call-cygpath "--mixed /") ipath))))
    (if (file-exists-p info-dir)
	(setq Info-directory-list (nconc Info-directory-list
					 (list info-dir)))))

  ;; I wish I could use 9 point, but there's some funky size
  ;; problem with the 9 point bold fonts that causes the
  ;; text on the screen to jump around when I change from
  ;; bold to regular and back.
  (let ((family "Courier New")
	(size 10)
	(encoding "Western"))
    (progn
      (set-face-font 'default (format "%s:%s:%d::%s"
				      family "Regular" size encoding))
;      (set-face-background 'default "wheat")
      ;; These resets are currently required if we're not using 10 point.
      (reset-face 'bold)
      (reset-face 'italic)
      (reset-face 'bold-italic)
      (set-face-font 'bold (format "%s:%s:%d::%s"
				   family "Bold" size encoding))
      (set-face-font 'italic (format "%s:%s:%d::%s"
				     family "Italic" size encoding))
      (set-face-font 'bold-italic (format "%s:%s:%d::%s"
					  family "Bold Italic"
					  size encoding))))

  (let* ((family "Bodoni MT")
	 (size 9)
	 (encoding "Western")
	 (spec (format "%s:%s:%d::%s" family "Regular" size encoding)))
    (progn
      (set-face-font 'buffers-tab spec)
      (set-face-font 'modeline spec))))

(setq tag-table-alist
      '(("\\.emacs$" . (xemacs-source-directory))
	("/lisp" . (xemacs-source-directory))))

(defun xemacs-source-directory ()
  "Return the path to the root of the XEmacs source tree."
  (interactive)

  ;; In older XEmacsen, source-directory was bound
  (if (boundp 'source-directory)
      (progn
	(if (string= (substring source-directory -5) "/lisp")
	    (substring source-directory 0 (- (length source-directory) 5))
	  source-directory))

    ;; Ever since XEmacs-21.0-b54, this method has been required
    (require 'config)
    (expand-file-name
     (or (gethash 'top_srcdir (config-value-hash-table))
	 (gethash 'blddir (config-value-hash-table))))))

; Fix a bug with emacs-internal face in current ediff
(setq ediff-coding-system-for-write 'raw-text)

; On windows, the I-beam mouse pointer is not visible
(set-glyph-image text-pointer-glyph "normal")

;(message "Leaving default.el")

;; Local Variables:
;; eval: (setq tab-width 8)
;; eval: (setq indent-tabs-mode t)
;; End:

