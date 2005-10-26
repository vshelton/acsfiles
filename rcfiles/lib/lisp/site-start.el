;; find local info nodes
(defvar Info-directory-list
      (append Info-default-directory-list '("/pd/oslib/info/")))
 
(setq auto-mode-alist
      (append '(("\\.tl$"  . c-mode)) auto-mode-alist))

;; Calc autoloads added manually by Vin Shelton 1/7/97
(setq load-path (append load-path '("/pd/lib/share/emacs/site-lisp")))
(autoload 'calc-dispatch          "calc" "Calculator Options" t)
(autoload 'full-calc              "calc" "Full-screen Calculator" t)
(autoload 'full-calc-keypad       "calc" "Full-screen X Calculator" t)
(autoload 'calc-eval              "calc" "Use Calculator from Lisp")
(autoload 'defmath                "calc" nil t t)
(autoload 'calc                   "calc" "Calculator Mode" t)
(autoload 'quick-calc             "calc" "Quick Calculator" t)
(autoload 'calc-keypad            "calc" "X windows Calculator" t)
(autoload 'calc-embedded          "calc" "Use Calc from any buffer" t)
(autoload 'calc-embedded-activate "calc" "Activate =>'s in buffer" t)
(autoload 'calc-grab-region       "calc" "Grab region of Calc data" t)
(autoload 'calc-grab-rectangle    "calc" "Grab rectangle of data" t)
(define-key global-map [(meta \#)] 'calc-dispatch)
