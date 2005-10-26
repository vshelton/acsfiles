;;
;; Original code from pbreton@i-kinetics.com
;; Adapted to IMAGE environment by Vin Shelton acs@acm.org.
;;
;; Interface to the glimpse command
(require 'compile)

(defvar glimpse-command "glimpse"
  "*The glimpse executable program ")

(defvar glimpse-options "-n -i -y -H $IMAGEBIN/index"
  "*Options to the glimpse command")

(defun glimpse-cmdline()
  "The command line used by the glimpse function"
  (concat glimpse-command " " glimpse-options " " ))

(defvar glimpse-history-list nil
  "The history list used by the glimpse command")

;; Copped from the grep command
;; Note that emacs 19.28 (?) and earlier hard-coded the use of /dev/null in
;; the grep command
(defun glimpse (command-args)
  "Run glimpse, with user-specified args, and collect output in a buffer.
While glimpse runs asynchronously, you can use the \\[next-error] command
to find the text that glimpse hits refer to.

This command uses a special history list for its arguments, so you can
easily repeat a glimpse command."
  (interactive
   (list (read-from-minibuffer "Run glimpse (like this): "
           (glimpse-cmdline)
	      nil nil 'glimpse-history-list)))
  (compile-internal (concat command-args)
		    "No more glimpse hits" "glimpse"
		    ;; Give it a simpler regexp to match.
		    nil grep-regexp-alist))

;; Shell Quotes on both file pattern and search pattern
(defun glimpse-in-files (file-pattern needle)
  "Run glimpse only on the files which match pattern"
  (interactive "sFile Pattern: \nsGlimpse: ")
  (let ((glimpse-cmdline 
        (concat glimpse-command
		" -F '" file-pattern "' "
		glimpse-options " '" needle "' ")))
     (glimpse glimpse-cmdline)))

(provide 'glimpse)
