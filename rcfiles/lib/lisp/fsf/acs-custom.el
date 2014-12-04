(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-timeout 960)
 '(balloon-help-background "LightYellow")
 '(c-hanging-comment-ender-p nil)
 '(c-indent-comments-syntactically-p t)
 '(c-macro-preprocessor "gcc -C -E -")
 '(c-macro-prompt-flag t)
 '(column-number-mode t)
 '(compilation-error-regexp-systems-list (quote (gnu comma)))
 '(compilation-mouse-motion-initiate-parsing t)
 '(desktop-save-mode t)
 '(enable-local-eval t)
 '(explicit-shell-file-name shell-file-name)
 '(find-file-compare-truenames t)
 '(gnus-expert-user t)
 '(gnus-novice-user nil)
 '(gnus-suppress-duplicates t)
 '(gnus-use-cache t)
 '(gnuserv-frame (quote gnuserv-visible-frame-function))
 '(grep-command
   "grep --line-number --with-filename --ignore-case --regexp=")
 '(indent-tabs-mode t)
 '(inhibit-startup-screen t)
 '(line-number-mode t)
 '(mail-user-agent (quote message-user-agent))
 '(modeline-click-swaps-buffers t)
 '(mouse-yank-at-point nil)
 '(next-line-add-newlines nil)
 '(query-replace-highlight t)
 '(query-user-mail-address nil)
 '(require-final-newline t)
 '(resize-minibuffer-frame-exactly t t)
 '(shell-file-name "zsh")
 '(shell-multiple-shells t)
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(truncate-lines nil)
 '(user-full-name "Vin Shelton")
 '(user-mail-address "acs@xemacs.org")
 '(vc-follow-symlinks nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil
		:stipple nil
		:background "Black"
		:foreground "LightYellow"
		:inverse-video nil
		:box nil
		:strike-through nil
		:overline nil
		:underline nil
		:slant normal
		:weight normal
		:height 105
		:width normal
		:family "ubuntu mono"))))
 '(fixed-pitch ((t (:inherit default))))
 '(font-lock-comment-face ((t (:foreground "DodgerBlue1"))))
 '(mode-line ((t (:background "LightSalmon"
		  :foreground "black"
		  :box (:line-width -1 :style released-button)
		  :height 1.0
		  :family "comic sans ms"))))
 '(mode-line-buffer-id ((t (:background "LightSalmon"
			    :foreground "black"
			    :weight bold
			    :height 1.0
			    :family "comic sans ms"))))
 '(mode-line-emphasis ((t (:background "LightSalmon"
			   :foreground "black"
			   :weight bold
			   :height 1.0
			   :family "comic sans ms"))))
 '(mode-line-highlight ((t (:inherit mode-line))))
 '(mode-line-inactive ((t (:inherit mode-line
			   :inverse-video t)))))
