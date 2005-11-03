
;; This file gets executed after acs-custom.el
;(message "Entering default.el")

(when (string-match "win32" system-configuration)
  ;; Set up a left margin
  (set-specifier left-margin-width 1)
  (setq explicit-shell-file-name (executable-find "bash")
	shell-file-name explicit-shell-file-name
	shell-command-switch "-c"
	selection-sets-clipboard t
	ispell-program-name (executable-find "aspell")
	nt-fake-unix-uid 1)

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

(defun xemacs-source-directory ()
  "Return the path to the root of the XEmacs source tree."

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

(setq tag-table-alist
      '(("\\.emacs$" . (xemacs-source-directory))
	("/lisp" . (xemacs-source-directory))))

;(message "Leaving default.el")
