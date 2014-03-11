;;; surgical-strine-mode.el - Surgical Strike code major mode
;;
;; Copyright (C) 2014 Rob Myers <rob@robmyers.org>
;; Indentation code from sample.el
;; Copyright (C) 2001  Free Software Foundation, Inc.
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;; 
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Installation
;;
;; To install, add this file to your Emacs load path.
;; You can then load it using M-x surgical-strike-mode
;; Alternatively you can have Emacs load it automatically for files with
;; a .strike extension by adding the following to your .emacs file:
;; 
;;    (require 'surgical-strike-mode)
;;    (add-to-list 'auto-mode-alist '("\\.strike$" . surgical-strike-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Customization
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defcustom surgical-strike-indent 2
  "How much to indent each code block."
  :type '(integer)
  :group 'surgical-strike-mode)

(defcustom surgical-strike-executable "surgical_strike"
  "The command to call to execute .strike files."
  :type 'boolean
  :group 'surgical-strike-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Syntax highlighting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defconst surgical-strike-font-lock-keywords
  '(
    ;; Start
    ("incoming!"
     . font-lock-constant-face)
    ;; Blocks
    ("\\(mark\\|clear\\|codeword\\|set\\)"
     . (0 font-lock-keyword-face))
    ;; Instructions
    ("\\(camouflage\\|deliver\\|load\\|manouver\\|roll\\|scale\\)"
     . (0 font-lock-builtin-face))
    ;; Command codewords
    ;;("\\b[[:alpha:]]+\\b"
    ;; . font-lock-variable-name-face)
  )
  "Highlighting for Surgical Strike major mode.")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Indentation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; From http://www.emacswiki.org/cgi-bin/wiki?SampleMode
(defun surgical-strike-indent-line ()
  "Indent current line of code."
  (interactive)
  (let ((savep (> (current-column) (current-indentation)))
        (indent (condition-case nil (max (surgical-strike-calculate-indentation) 0)
                  (error 0))))
     (if savep
         (save-excursion (indent-line-to indent))
       (indent-line-to indent))))

(defun surgical-strike-calculate-indentation ()
  "Indent current line as Surgical Strike code"
  (interactive)
  (save-excursion
    (beginning-of-line)
    (let ((indent 0))
      (while (not (bobp))
        (when (not (looking-at "^\s*\\\\"))
          (when (looking-at "^\s*\\(set\\|clear\\)")
            (decf indent))
          (forward-line -1)
           (when (looking-at "^\s*\\(codeword\\|mark\\)")
            (incf indent))))
      (* indent surgical-strike-indent))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Running
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun surgical-strike-execute-current-buffer ()
  (interactive)
  (let ((output-buffer (get-buffer-create "*Surgical Strike Output*")))
    (with-current-buffer output-buffer
      (erase-buffer))
    (shell-command-on-region
     (point-min) (point-max)
     surgical-strike-executable
     output-buffer)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Syntax table
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar surgical-strike-syntax-table
  (let ((st (make-syntax-table)))
    ;; c++-style comments: //
    (modify-syntax-entry ?\/ ". 12b" st)
    (modify-syntax-entry ?\n "> b" st)
    st)
  "Syntax table for Surgical Strike major mode.")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Keymap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defconst surgical-strike-mode-map (make-keymap)
  "Keymap for Surgical Strike major mode.")
(define-key surgical-strike-mode-map "\C-j"
  'newline-and-indent)
(define-key surgical-strike-mode-map (kbd "C-x C-e")
  'surgical-strike-execute-current-buffer)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Define the mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-derived-mode surgical-strike-mode prog-mode "strike"
  "Major mode for editing Surgical Strike programming language files.
\\{surgical-strike-mode-map}"
  :group 'surgical-strike-mode
  :syntax-table surgical-strike-syntax-table
  :keymap surgical-strike-mode-map
  (set (make-local-variable 'font-lock-defaults)
       '(surgical-strike-font-lock-keywords))
  (set (make-local-variable 'comment-start) "//")
  (set (make-local-variable 'comment-end) "")
  (setq-local indent-line-function 'surgical-strike-indent-line))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Provide the mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'surgical-strike-mode)
