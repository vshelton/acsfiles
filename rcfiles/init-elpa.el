(require 'package)

(defun require-package (package)
  "Install given PACKAGE if it was not installed before."
  (if (package-installed-p package)
      t
    (progn
      (unless (assoc package package-archive-contents)
        (package-refresh-contents))
      (package-install package))))

;; See melpa.org.
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
;(package-refresh-contents)

(provide 'init-elpa)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:
