;;; package --- Summary
;;; Commentary:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Anne Summers                   ;;
;; ukulanne@gmail.com             ;;
;; June 26, 1999                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
;; Time-stamp: <2024-03-07 10:43:56 anne>
;;
;; .emacs configuration file
;;   Copyright (C) <1999>  <Anne Summers>

;;
;; This program is free software; you can redistribute it and/or modify
;;   it under the terms of the GNU General Public License as published by
;;   the Free Software Foundation; either version 3 of the License, or
;;   (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;;   but WITHOUT ANY WARRANTY; without even the implied warranty of
;;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;   GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;;    along with this program.  If not, see <http://www.gnu.org/licenses/>.



;;; Code:

(require 'package)
(add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "http://stable.melpa.org/packages/") t)
(package-initialize)
;;(package-refresh-contents)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))

(defun backup-files () "Backup files to tmp."
  (set 'temporary-file-directory "/tmp")
  (setq auto-save-interval 2500)
  (setq auto-save-timeout nil)


  ;; The following line ensures that emacs deletes the #buffer# files
  ;; that it uses for auto-save files.

  ;;(setq delete-auto-save-files t)

  ;; If you don't like the fact that emacs leaves buffer~ files laying
  ;; around when it quits use this command.

  (setq make-backup-files nil)

  (setq backup-directory-alist `(("." . "/tmp"))))

(use-package emacs
  :init
  (tool-bar-mode -1)
  (when scroll-bar-mode
      (scroll-bar-mode -1))

  (when (version<= "26.0.50" emacs-version )
    (global-display-line-numbers-mode))
  
  (autoload 'whitespace-mode "whitespace" "Toggle whitespace visualization." t)
  ;(set-face-attribute 'default nil :font "CaskaydiaCove Nerd Font Mono" :height 160)
  
  (fido-vertical-mode)

;;  (display-time)
  
  :config
  (add-hook 'before-save-hook 'time-stamp)
  (backup-files)
  
  (setq ring-bell-function 'ignore)
  
  (setq shell-file-name "bash")
  
  (setq user-mail-address "ukulanne@gmail.com")
  
  ;;(setq default-major-mode 'text-mode)
  
  ;;(setq display-time-24hr-format t)

  (setq inhibit-startup-message t)

  (fset 'yes-or-no-p 'y-or-n-p)
  
  (setq create-lockfiles nil)

  :custom
  (treesit-language-source-alist
   ;; '((ruby "https://github.com/tree-sitter/tree-sitter-ruby"))
   '((javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src"))
  ))

(use-package eglot
    :hook (prog-mode . eglot-ensure)
    :init
    (setq eglot-stay-out-of '(flymake))
    :bind (:map
           eglot-mode-map
           ("C-c c a" . eglot-code-actions)
           ("C-c c o" . eglot-code-actions-organize-imports)
           ("C-c c r" . eglot-rename)
           ("C-c c f" . eglot-format)))

 (use-package eldoc
   :init
   (global-eldoc-mode))

(use-package flymake
    :hook (prog-mode . flymake-mode)
    :bind (:map flymake-mode-map
                ("C-c ! n" . flymake-goto-next-error)
                ("C-c ! p" . flymake-goto-prev-error)
                ("C-c ! l" . flymake-show-buffer-diagnostics)))

(use-package js-base-mode
    :defer 't
    :ensure js ;; I care about js-base-mode but it is locked behind the feature "js"
    :custom
    (js-indent-level 2)
    :config
 ;;   (add-to-list 'treesit-language-source-alist '(javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src"))
    (unbind-key "M-." js-base-mode-map))

(use-package company
    :ensure t
    :commands (global-company-mode)
    :init
    (global-company-mode)
    :custom
    (company-tooltip-align-annotations 't)
    (company-minimum-prefix-length 1)
    (company-idle-delay 0.1))

(use-package markdown-mode
    :ensure t
    :magic "\\.md\\'")

 (use-package nano-modeline
    :ensure t
    :init
    (nano-modeline-prog-mode t)
    :custom
    (nano-modeline-position 'nano-modeline-footer)
    :hook
    (prog-mode           . nano-modeline-prog-mode)
    (text-mode           . nano-modeline-text-mode)
    (org-mode            . nano-modeline-org-mode)
    (pdf-view-mode       . nano-modeline-pdf-mode)
    (mu4e-headers-mode   . nano-modeline-mu4e-headers-mode)
    (mu4e-view-mode      . nano-modeline-mu4e-message-mode)
    (elfeed-show-mode    . nano-modeline-elfeed-entry-mode)
    (elfeed-search-mode  . nano-modeline-elfeed-search-mode)
    (term-mode           . nano-modeline-term-mode)
    (xwidget-webkit-mode . nano-modeline-xwidget-mode)
    (messages-buffer-mode . nano-modeline-message-mode)
    (org-capture-mode    . nano-modeline-org-capture-mode)
    (org-agenda-mode     . nano-modeline-org-agenda-mode))

(use-package spacemacs-theme
  :config
  (load-theme 'spacemacs-dark t))

(use-package all-the-icons :if (display-graphic-p))

(use-package neotree :ensure t)
(setq neo-theme (if (display-graphic-p) 'icons))
(global-set-key [f8] 'neotree-toggle)


;;(use-package flycheck
;;  :init (global-flycheck-mode))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun kill-buffer-fast () "Kill the current buffer."
  (interactive)
  (kill-buffer nil))


;; Global Keys


(global-set-key "\C-x\C-g" 'goto-line)
;;(global-set-key "\C-x\C-j" 'compile-command)

(global-set-key [f1] 'list-packages)
(global-set-key [f2] 'find-file)
(global-set-key [f3] 'kill-buffer-fast)
(global-set-key [f4] 'goto-line)

(global-set-key [f5] 'undo)
(global-set-key [f6] 'replace-string)
;;(global-set-key [f7] 'compile)
;;(global-set-key [f8] 'next-error)

(global-set-key [f9] 'mark-defun)
(global-set-key [f10] 'mark-whole-buffer)
(global-set-key [f11] 'indent-region)
(global-set-key [f12] 'add-change-log-entry-other-window)

(global-set-key [home] 'beginning-of-line)
(global-set-key [end] 'end-of-line)
;;(global-set-key [C-next]  'scroll-other-window)
;;(global-set-key [C-prior] 'scroll-other-window-down)

(easy-menu-define words-menu global-map
  "Menu for word navigation commands."
  '("🐼"))
;;     ["Forward word" forward-word]
;;     ["Backward word" backward-word]))

;(use-package json-mode)

(require 'mmm-mode)
(require 'vue-html-mode)
(require 'vue-mode)

(setq-default indent-tabs-mode nil)
(setq js-indent-level 2)

(when (not (display-graphic-p))
  (message "Running emacs on the console [TRUE]")
  (xterm-mouse-mode 1))

(defmacro with-unix (os &rest body)
  "Eval BODY if `system-type' is OS."
  (declare (indent defun))
  `(when (eq system-type ',os) ,@body))

(defun pkg-installed-msg (name pkg) "Check if NAME PKG is installed."
       (message "%s mode installed %s "
                name (if (package-installed-p pkg) "[TRUE]" "[FALSE]")))

(message "Checking for installed modules")
(pkg-installed-msg "Js2-mode" 'js2-mode)
;;(pkg-installed-msg "rjsx-mode" 'rjsx-mode)
(pkg-installed-msg "vue-mode" 'vue-mode)
(pkg-installed-msg "Neotree-mode" 'neotree)
(pkg-installed-msg "all-the-icons" 'all-the-icons)
(pkg-installed-msg "flycheck" 'flycheck-mode)

(with-unix gnu/linux (message "Operating system:  [GNU/Linux]"))
(with-unix aix (message "Operating system:  [AIX]"))

(message "Dixitque Deus fiat lux et facta sunt Emacs.")
(message "Save the pandas!")


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(flycheck json-mode lsp-ui lsp-mode spacemacs-theme all-the-icons-completion all-the-icons-ivy-rich all-the-icons-dired tern neotree doom-modeline all-the-icons focus-autosave-mode minimap describe-number ## markdown-mode nodejs-repl mmm-mode vue-mode rjsx-mode indium tern-auto-complete npm-mode js2-mode feature-mode))
 '(warning-suppress-log-types '((comp) (comp) (comp)))
 '(warning-suppress-types '((comp) (comp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;(provide '.emacs)
;;; .emacs ends here
