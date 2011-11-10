;(message "Entering acs-custom.el")

;; Set these variables via custom
(custom-set-variables
 '(auto-save-timeout 960 t)
 '(bar-cursor nil)
 '(buffers-menu-grouping-function nil)
 '(buffers-menu-max-size 25)
 '(buffers-menu-sort-function nil)
 '(buffers-menu-submenus-for-groups-p nil)
 '(build-report-destination (quote ("XEmacs Build Reports List <xemacs-buildreports@xemacs.org>")))
 '(build-report-make-output-files (quote ("mk.out" "check.out" "inst.out")))
 '(c-hanging-comment-ender-p nil)
 '(c-indent-comments-syntactically-p t)
 '(c-macro-preprocessor "gcc -C -E -")
 '(c-macro-prompt-flag t)
 '(column-number-mode t)
 '(compilation-error-regexp-systems-list (quote (gnu comma)))
 '(compilation-mouse-motion-initiate-parsing t)
 '(complex-buffers-menu-p t)
 '(ediff-use-long-help-message nil t)
 '(ediff-window-setup-function (quote ediff-setup-windows-plain) t)
 '(enable-local-eval t)
 '(find-file-compare-truenames t)
 '(font-menu-ignore-scaled-fonts t t)
 '(font-menu-this-frame-only-p t t)
 '(gnus-expert-user t)
 '(gnus-novice-user nil)
 '(gnus-suppress-duplicates t)
 '(gnus-use-cache t)
 '(grep-command "egrep -n " t)
 '(indent-tabs-mode t)
 '(ispell-program-name "aspell")
 '(line-number-mode t)
 '(load-home-init-file t t)
 '(mail-user-agent (quote message-user-agent))
 '(minibuffer-confirm-incomplete t)
 '(modeline-click-swaps-buffers t)
 '(mouse-yank-at-point nil)
 '(next-line-add-newlines nil)
 '(patcher-projects (quote (("packages" "~/scmroot/xemacs-packages") ("web" "~/scmroot/xemacsweb") ("build" "~/scmroot/xemacs-builds") ("21.4" "~/scmroot/xemacs-21.4") ("21.5" "~/scmroot/xemacs-21.5"))))
 '(query-replace-highlight t)
 '(query-user-mail-address nil)
 '(require-final-newline t)
 '(resize-minibuffer-frame-exactly t)
 '(resize-minibuffer-mode t nil (rsz-minibuf))
 '(shell-multiple-shells t)
 '(tags-build-completion-table (quote ask))
 '(teach-extended-commands-p t)
 '(teach-extended-commands-timeout 1)
 '(temp-buffer-show-function (quote show-temp-buffer-in-current-frame))
 '(truncate-lines nil)
 '(user-full-name "Vin Shelton" t)
 '(user-mail-address "acs@xemacs.org")
 '(vc-follow-symlinks t)
 '(zmacs-regions t))

;(message "Leaving acs-custom.el")
(custom-set-faces
 '(font-lock-comment-face ((((class color) (background dark)) (:foreground "DodgerBlue1"))))
 '(zmacs-region ((t (:foreground "LightYellow" :background "gray47"))) t)
 '(isearch-secondary ((t (:background "gray47"))) t)
 '(modeline ((t (:foreground "Black" :background "light salmon" :size "11px" :family "comic sans ms"))) t))
