
;; This file gets executed after acs-custom.el
;(message "Entering default.el")

(defun call-cygpath (&optional args)
  "Call cygwin's cygpath function and strip the linefeed"
  (interactive)
  (let ((p (shell-command-to-string (concat "cygpath " args))))
    (if (equal (substring p -1) "\n")
	(substring p 0 -1)
      p)))

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

;; At this point, directory-sep-char is a slash,
;; but it will need to be reset if we're using (ugh!) cmd.exe
(if (executable-find "bash")
    (progn
      (setq shell-file-name (executable-find "bash")
	    shell-command-switch "-c"))
  (setq directory-sep-char ?\\))

;; Set up exec-path under cygwin
(when (string-match "cygwin" system-configuration)
  (setq exec-path (list
		   (expand-file-name "~/bin")
		   "/usr/local/bin"
		   "/usr/bin"
		   (call-cygpath "--sysdir")
		   (call-cygpath "--windir")
		   exec-directory))
  (setq efs-ftp-program-name "ftp"))

;; Under Windows, if cygpath can't be found, use the default exec-path
(when (and (string-match "win32" system-configuration)
	   (executable-find "cygpath"))
  (setq exec-path (list
		   (expand-file-name "~/bin")
		   (call-cygpath "--mixed /usr/local/bin")
		   (call-cygpath "--mixed /usr/bin")
		   (call-cygpath "--mixed --sysdir")
		   (call-cygpath "--mixed --windir")
		   exec-directory)))

(and (executable-find "zsh")
     (setq grep-command "zsh -c \"egrep -n \""))

(when (string-match "win32\\|cygwin" system-configuration)

  ;; Set up a left margin
  (set-specifier left-margin-width 1)
  (setq ispell-program-name (executable-find "aspell")
	nt-fake-unix-uid 1)

  ;; Add /usr/share/info to the info path
  (let* ((ipath "/usr/share/info")
	 (info-dir
	  (if (string-match "cygwin" system-configuration)
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
      (set-face-background 'default "wheat")
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
					  size encoding)))))

  (let* ((family "Bodoni MT")
	 (size 9)
	 (encoding "Western")
	 (spec (format "%s:%s:%d::%s" family "Regular" size encoding)))
    (progn
      (set-face-font 'buffers-tab spec)
      (set-face-font 'modeline spec)))

(setq tag-table-alist
      '(("\\.emacs$" . (xemacs-source-directory))
	("/lisp" . (xemacs-source-directory))))

;(message "Leaving default.el")

;; Local Variables:
;; eval: (setq tab-width 8)
;; eval: (setq indent-tabs-mode t)
;; End:
