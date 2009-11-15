:; Set up system-dependent defaults
(setq acs::mailaddress (or (getenv "MAILADDRESS") "acs@alumni.princeton.edu")
      acs::mailspool (or (getenv "MAILSPOOL") "/var/spool/mail/acs")
      acs::organization (or (getenv "ORGANIZATION") "EtherSoft, Inc"))

;; Ding gnus initialization stuff
(setq gnus-interactive-catchup nil
      gnus-interactive-exit nil
      gnus-thread-sort-functions '(gnus-thread-sort-by-number
				   gnus-thread-sort-by-date)
      ;gnus-select-method '(nntp "news.isp.giganews.com")
;      gnus-select-method '(nntp "news.rcn.com")
      gnus-select-method '(nntp "news")
      gnus-check-new-newsgroups nil
      gnus-read-active-file 'some
      gnus-save-killed-list nil
;      browse-url-browser-function 'browse-url-galeon
      browse-url-browser-function 'browse-url-mozilla
      browse-url-mozilla-program "firefox"
      browse-url-new-window-flag t
;      browse-url-galeon-new-window-is-tab t
      browse-url-mozilla-new-window-is-tab t
      gnus-options-not-subscribe "^de\..*|^uiuc\..*|^fi\..*"
      gnus-group-default-list-level 3
      gnus-auto-select-first nil
      nnmail-crosspost nil
      gnus-agent nil
      gnus-agent-cache nil
      gnus-use-correct-string-widths nil
      gnus-make-format-preserve-properties nil)

;; Mail setup
(setq nnfolder-directory "~/Mail/archive")
(setq gnus-parameters
      '(("nnfolder:xemacs.*"
	 ; Setting gnus-visible-headers has no effect.
	 ; Ideally, we would just add Message-id to gnus-visible-headers,
	 ; so I can use 'msgid' to save the message.
	 ; I'll make all headers visible instead (yuck!).
;	 (gnus-visible-headers "^From:\\|^Newsgroups:\\|^Subject:\\|^Date:\\|^Summary:\\|^Keywords:\\|^To:\\|^[BGF]?Cc:\\|^Posted-To:\\|^Resent-From:\\|^X-Sent:\\|^Message-[Ii][Dd]:")
	 (gnus-show-all-headers t)
	 (gnus-large-newsgroup 2000)
	 (display . all))))
(setq gnus-move-split-methods
      '(((equal gnus-newsgroup-name "gnu.emacs.sources") "nnml:emacs")
	((equal gnus-newsgroup-name "rec.humor.funny") "nnml:humor"))
      nnmail-spool-file acs::mailspool
      nnmail-keep-last-article nil	; t if using exmh
;      nnmail-delete-incoming nil	; save a copy of incoming mail
      gnus-secondary-select-methods
      '((nnml "")
	(nnfolder "")
	(nnmaildir ""))
      nnmh-get-new-mail nil
      nnmh-be-safe t
      nnml-get-new-mail t
      gnus-treat-display-smileys nil	; don't smilify by default
      gnus-large-newsgroup 1000

      nnmail-split-methods
      '(("exmh"		"^To:.*exmh")
	("exmh"		"^cc:.*exmh")
	("zsh"		"^Delivered-To:.*zsh")
	("XEmacs-review"	"^To:.*xemacs-patches@xemacs.org")
	("XEmacs-review"	"^To:.*xemacs-review@xemacs.org")
	("XEmacs-review"	"^cc:.*xemacs-patches@xemacs.org")
	("XEmacs-review"	"^cc:.*xemacs-review@xemacs.org")
	("XEmacs"	"^To:.*@xemacs.org")
	("XEmacs"	"^cc:.*@xemacs.org")
	("gcc"		"^Sender: gcc-owner")
	("ding"		"^To:.*ding@gnus.org")
	("ding"		"^cc:.*ding@gnus.org")
	("CCW"		"^From:.*pjmayher")
	("CCW"		"^From:.*zecco")
	("CCW"		"^To:.*schendel")
	("CCW"		"^cc:.*schendel")
	("inbox"	""))

      message-required-mail-headers '(From
				      Subject
				      Date
				      (optional . In-Reply-To)
				      Message-ID
				      (optional . Organization)
				      Lines
				      (optional . X-Mailer))
      message-required-news-headers '(From
				      Newsgroups
				      Subject
				      Date
				      Message-ID
				      (optional . Organization)
				      Lines
				      (optional . X-Newsreader))

      gnus-posting-styles
      '((".*"
	 (address acs::mailaddress)
	 (name "Vin Shelton")
	 (organization acs::organization))
	("UPA"
	 (address "vin.shelton@upa.org")
	 (organization "Ultimate Players Association"))
	("rec.sport.disc"
	 (address "vin.shelton@upa.org")
	 (organization "Ultimate Players Association"))
	("[Ee]macs"
	 (address "acs@xemacs.org")
	 (organization "The XEmacs Development Team"))))

;; Don't automatically expire old mail when I re-read it.
;; This is only necessary if I'm using auto-expire.
(remove-hook 'gnus-mark-article-hook
	     'gnus-summary-mark-read-and-unread-as-read)
(add-hook 'gnus-mark-article-hook 'gnus-summary-mark-unread-as-read)

;; Use d to expire articles
(require 'gnus-sum)
(define-key gnus-summary-mode-map "d" 'gnus-summary-mark-as-expirable)

;; Set up a gnus configuration for a wide screen
;; if we have a dedicated frame
;; (cond ((equal (plist-get (frame-properties) 'name) "gnus")
;; ;       (make-variable-buffer-local 'frame-title-format)
;;        (setq gnus-use-trees t
;; 	     gnus-generate-tree-function 'gnus-generate-horizontal-tree
;; 	     gnus-tree-minimize-window nil)
;; ;	     frame-title-format "%S")
;;        (gnus-add-configuration
;; 	'(article
;; 	  (horizontal 1.0
;; 		      (vertical 0.50
;; 				(tree 0.20)
;; 				(summary 1.0 point))
;; 		      (article 1.0))))))


;; Display text instead of html
(add-to-list 'mm-discouraged-alternatives "text/html")
(setq mm-automatic-display (remove "text/html" mm-automatic-display))
