;;; detached-minibuf.el -- Support a detached minibuffer for XEmacs.

;; Copyright (C) 1997 Alvin C. Shelton

;; Author: Alvin Shelton <acs@acm.org>
;; Keywords: extensions

;; This file is part of XEmacs.

;; XEmacs is free software; you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your
;; option) any later version.

;; XEmacs is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with XEmacs; if not, write to the Free Software Foundation,
;; Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

;;; Synched up with: not in FSF.

;;; Commentary:

;; Version: 1.1

;;; Code:

;;
;; Variable definitions

(defvar add-minibuf-options t
  "*If nil, prevent minibuffer options from being added to the Options menu.\
This must be set before detached-minibuf is loaded.")
(defvar minibuf-frame-height 1
  "*The height in lines of the minibuffer frame created by make-detached-minibuf")
(defvar minibuf-frame-width (frame-width (selected-frame))
  "*The width in chars of the minibuffer frame created by make-detached-minibuf")
(defvar minibuf-frame-pos-y -2
  "*The y position of the minibuffer frame as created by make-detached-minibuf")
(defvar minibuf-frame-pos-x -2
  "*The x position of the minibuffer frame as created by make-detached-minibuf")

;;
;; Add minibuffer options to the Options menu
(if add-minibuf-options
    (progn
      (defun toggle-minibuf ()
	(if (equal (frame-property (selected-frame) 'minibuffer) t)

	    ;; This frame already has a minibuffer, so remove the minibuffer.
	    ;; Unfortunately, we must delete and redraw the frame
	    (let ((fp (frame-properties (selected-frame)))
		  (buf (current-buffer))
		  (orig (selected-frame)))

	      ;; Create and select the new frame;
	      ;; we have to do this before we delete the old frame.
	      (setq fp (plist-remprop fp 'window-id)
		    fp (plist-remprop fp 'minibuffer))
	      (select-frame
	       (make-frame (plist-put fp 'minibuffer nil)))  
	      (switch-to-buffer buf)

	      (set-frame-properties
	       orig (list 'minibuffer default-minibuffer-frame))
	      (delete-frame orig t))

	  ;; This frame does not have a minibuffer, so add one
	  (set-frame-property (selected-frame) 'minibuffer t)))

      (add-menu-button '("Options" "Frame Appearance")
		       ["------" nil nil]
		       nil)
      (add-menu-button '("Options" "Frame Appearance")
		       ["Toggle minibuffer"
			(toggle-minibuf)
			:style toggle
			:active (not (equal (selected-frame)
					    default-minibuffer-frame))
			:selected (equal
				   (frame-property (selected-frame) 'minibuffer)
				   t)]
		       nil)
      (add-menu-button '("Options" "Frame Appearance")
		       ["Default minibuffer here"
			(setq default-minibuffer-frame (selected-frame))
			:style toggle
			:active (let ((mbf (frame-property
					    (selected-frame) 'minibuffer)))
				  (or (equal mbf (selected-frame))
				      (equal mbf t)))
			:selected (equal (selected-frame)
					 default-minibuffer-frame)]
		       nil)
      (add-menu-button '("Options" "Frame Appearance")
		       ["Make a detached minibuffer"
			(make-detached-minibuf)
			:style nil]
		       nil)))

;;
;; Create a minibuffer-only frame.
;;
;; This function creates a frame named "minibuffer".
;; You will likely want this frame not to have a titlebar.
;; In order to do this for gwm, uncomment the following line
;; and add it to your .profile.gwm:
;; (set-window Emacs.minibuffer no-frame)
;;
(defun make-detached-minibuf ()
  "Create a standalone minibuffer"
  (if (console-on-window-system-p)
      (progn
	(setq initial-frame-plist
	      (list 'minibuffer nil
		    'width (frame-width (selected-frame))
		    'height (frame-height (selected-frame))))
	(setq default-minibuffer-frame
	      (make-frame
	       (list 'minibuffer 'only
		     'width minibuf-frame-width
		     'height minibuf-frame-height
		     'menubar-visible-p nil
		     'default-toolbar-visible-p nil
		     'name "minibuffer"
		     'top minibuf-frame-pos-y
		     'left minibuf-frame-pos-x
		     'has-modeline-p nil)))

	;; Bogus!  But it avoids annoying screen flash at startup
	(if (not command-line-args-left)
	    (frame-notice-user-settings)))))

(provide 'detached-minibuf)

;;; detached-minibuf.el ends here
