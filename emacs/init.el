;;; init.el --- My main init.el for Emacs

;(require 'package)

;; Minimal garbage collection while loading - is reset
;; at bottom of init
(defvar gc-cons-threshold--orig gc-cons-threshold)
(defvar gc-cons-percentage--orig gc-cons-percentage)

(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6)

;;don't load any packages before starting up
(setq package-enable-at-startup nil)

;;; where to place packages downloaded from the package-archives
;(setq package-user-dir (concat user-emacs-directory  "packages"))

(add-to-list 'load-path (concat user-emacs-directory "misc"))

;; Place where themes live ???
;; (setq custom-theme-directory (concat user-emacs-directory "themes/"))

;; start maximized [https://emacs.stackexchange.com/a/3008]
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;;;don't gunk up my init.el
(setq custom-file (concat user-emacs-directory "custom.el"))

;;; inhibit startup echo area message
(setq inhibit-startup-echo-area-message "bwayne")

;;; inhibit the startup screen
(setq inhibit-startup-screen t)

;;; tab indents line, and if already indented, then completes
(setq-default tab-always-indent 'complete)

(setq-default indent-tabs-mode nil)

;;(setq initial-scratch-message "")

;; highlight the current line
(global-hl-line-mode 1)

(when (display-graphic-p)
  (progn
    ;; hide the tool bar
    (tool-bar-mode -1)
    ;; hide the scroll bar
    (scroll-bar-mode -1)))

;; highlight other paired paren
(show-paren-mode 1)

;; syntax highlighting
(global-font-lock-mode 1)

;; prettify symbols
(add-hook 'prog-mode-hook
    '(lambda () (global-prettify-symbols-mode 1)))

;; Font
(set-frame-font "Ubuntu Mono derivative Powerline 11" nil t)

;; backups and such
(setq delete-old-versions t
      kept-old-versions 2
      kept-new-versions 6
      backup-by-copying t
      backup-directory-alist
        '(("." . "~/.local/share/emacs-saves"))
      auto-save-file-name-transforms
        '((".*" "~/.local/share/emacs-saves/" t))
      version-control t)

;; don't ask for confirmation when opening symlinked file
(setq vc-follow-symlinks t)

;; inhibit useless and old-school startup screen
(setq inhibit-startup-screen t)

;; silent bell when you make a mistake
(setq ring-bell-function 'ignore)

;; use utf-8 by default
(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)

;; change 'yes or no' to 'y or n'
(fset 'yes-or-no-p 'y-or-n-p)

;; sentences end with only one space.
(setq sentence-end-double-space nil)


;; don't highlight searches
(setq search-highlight nil
      isearch-lazy-highlight nil)


;;; remove whitespace from end of lines
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; restore frames when restoring desktop
(setq destop-restore-frames t)

;;; Bootstrap `straight' package manager
(let ((bootstrap-file (concat user-emacs-directory "straight/repos/straight.el/bootstrap.el"))
      (bootstrap-version 3))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; use 'use-package' [https://github.com/jwiegley/use-package]
(straight-use-package 'use-package)
(require 'use-package)

;; always integrate use-package into straight
(setq straight-use-package-by-default t)

;; Move between windows with shift-arrow
(use-package windmove
  :defer t
  :commands (windmove-left windmove-up windmove-right windmove-down)
  :config
  (windmove-default-keybindings))

;; save the place of the point when exiting a buffer
(use-package saveplace
  :defer t
  :config
  (save-place-mode t))

;; https://www.emacswiki.org/emacs/InfoPlus
(use-package info+)

(use-package dired+)

(use-package bookmark+)

;; General for KeyBindings
(use-package general
  :config
  (general-evil-setup t))

;;; Tone down the modeline
(use-package diminish)

(use-package async)

(use-package auto-compile)

;;; Spaceline
(use-package spaceline
  :config
  (setq-default powerline-default-separator 'contour)
  (spaceline-spacemacs-theme)
  (spaceline-helm-mode)
  (spaceline-info-mode))

(use-package undo-tree
  :defer t
  :diminish undo-tree-mode
  :init
  (setq undo-tree-auto-save-history t))

(use-package restart-emacs
  :defer 5
  :commands restart-emacs
  :general
  (general-define-key
    :states '(normal visual emacs)
    :prefix "SPC"
    :non-normal-prefix "C-SPC"
    "q" '(:ignore t :which-key "quit")
    "qr" '(restart-emacs :which-key "restart-emacs")
    "qq" '(save-buffers-kill-emacs :which-key "quit-emacs"))
  :init
  (setq restart-emacs-restore-frames t))

;; (use-package neotree
;;   :disabled
;;   :defer 5
;;   :commands neotree-toggle
;;   :config
;;   (setq neo-theme (if (display-graphic-p) 'icons 'arrow)))

;; (use-package all-the-icons
;;   :disabled
;;   :defer 5
;;   :after neotree)

;; Evil Mode
(use-package evil
  :init
  (setq evil-want-integration nil)
  :config
  (evil-mode 1))

(use-package evil-escape
  :after evil
  :diminish evil-escape-mode ""
  :init
  (setq evil-escape-key-sequence ",,"
        evil-escape-delay 0.3)
  :config
  (evil-escape-mode))

;;; Surround text objects [https://github.com/emacs-evil/evil-surround]
(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode 1))

(use-package evil-collection
  :disabled
  :after evil
  :config
  (evil-collection-init))

(use-package erc
  :commands erc
  :init
  (setq erc-hide-list '("JOIN" "PART" "QUIT")))

;;; Help keep emacs.d clean [https://github.com/emacscollective/no-littering]
(use-package no-littering)

;; Which-key - guides key chord usage
(use-package which-key
  :defer 2
  :init
  (setq which-key-sort-order 'which-key-key-order-alpha)
  :config
  (which-key-mode))

;; easy searching [https://github.com/abo-abo/avy]
(use-package avy
  :disabled
  :defer 2
  :general
  (general-nmap
    :prefix "SPC"
    "s" '(:ignore t :which-key "search")
    "sc" '(avy-goto-char :which-key "search-char")
    "sC" '(avy-goto-char2 :which-key "search-char2")
    "sw" '(avy-goto-word-or-subword-1 :which-key "search-word")))


;; Helm is love. Helm is life.
(use-package helm
  :diminish ""
  :general
    (general-define-key
      :states '(normal emacs visual)
      "SPC SPC" 'helm-M-x)
  :init
  (setq helm-M-x-fuzzy-match t
        helm-adaptive-sort-by-frequent-recent-usage t
        helm-split-window-inside-p t)
  :config
  (helm-mode 1))

(use-package helm-descbinds
  :defer 5
  :bind ("C-h b" . helm-descbinds)
  :config
  (helm-descbinds-mode))

(use-package swiper-helm
  :defer 5
  :general
  (general-nmap
    :prefix "SPC"
    "ss" '(swiper-helm :which-key "swiper")))

;; Make delimiters color-paired
(use-package rainbow-delimiters
  :defer 2
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

;;; Themes
(straight-use-package 'gruvbox-theme)

(use-package solarized-theme
  :init
  (setq solarized-high-contrast-mode-line nil)
  :config
  (require 'solarized))

;;;; use $PATH established in shell to check for binaries
;; (use-package exec-path-from-shell
;;   :init
;;   (setq exec-path-from-shell-check-startup-files nil)
;;   :config
;;   (exec-path-from-shell-initialize))

;; superior to docview
(use-package pdf-tools
  :defer t
  :magic ("%PDF" . pdf-view-mode)
  :config
  (pdf-tools-install))

;; Put special windows in a popup instead of a buffer [https://github.com/m2ym/popwin-el]
(use-package popwin
  :config
  (popwin-mode 1))

;(use-package aggressive-indent
;  :straight t
;  :config
;  (aggressive-indent-mode 1))

;; 'Geiser' - scheme interaction
(use-package geiser
  :defer t)

;; 'Company' - "Complete Anything"
(use-package company
  :init
  (setq company-selection-wrap-around t
        company-idle-delay 0.0
        company-minimum-prefix-length 2)
  :config
  (add-hook 'after-init-hook 'global-company-mode))

;;; diplays popup menu [https://github.com/expez/company-quickhelp]
(use-package company-quickhelp
  :after company
  :init
  (setq company-quickhelp-delay 1.0)
  :config
  (company-quickhelp-mode))

(use-package python-mode
  :mode "\\.py\\'"
  :interpreter "python3")

(use-package company-anaconda
  :after company
  :init
  (eval-after-load "company"
    '(add-to-list 'company-backends 'company-anaconda))
  :config
  (add-hook 'python-mode-hook 'anaconda-mode))

(use-package company-shell
  :after company
  :init
  (eval-after-load "company"
    '(add-to-list 'company-backends
       '(company-shell company-shell-env))))

(use-package flycheck
  :defer t)
  ;;:hook (prog-mode . flycheck-mode)
  ;;:config
  ;;(add-hook 'after-init-hook #'global-flycheck-mode)

;; (use-package haskell-mode
;;   :mode "\\.hs\\'"
;;   :init
;;   (setq haskell-process-type 'stack-ghci))

;; (use-package intero
;;   :disabled)
;;  :config
;;  (add-hook 'haskell-mode-hook 'intero-mode)

;; (use-package ghc
;;   :after haskell-mode
;;   :init
;;   (add-hook 'haskell-mode-hook (lambda ()
;;                                  (ghc-init))))

;; (use-package company-ghc
;;   :after (company ghc)
;;   :config
;;   (add-to-list 'company-backends 'company-ghc))

;; (use-package hindent
;;   :mode "\\.hs\\'"
;;   :hook (haskell-mode-hook . hindent-mode))

;; Relative numbers
(use-package linum-relative
  :diminish linum-relative-mode
  :init
  (setq linum-relative-current-symbol ""
        linum-relative-backend 'display-line-numbers-mode)
  :config
  (helm-linum-relative-mode 1)
  (add-hook 'prog-mode-hook 'linum-relative-mode))

;; Expand a emacs-lisp macro
(use-package macrostep
  :defer t
  :bind (:map emacs-lisp-mode-map
         ("C-c e" . macrostep-expand)))

(use-package magit
  :defer 10
  :commands magit)

;; Vimish-fold
(use-package vimish-fold
  :disabled
  :general
  (general-nmap
    :prefix "SPC"
    "z"  '(:ignore t                      :which-key "misc/folds")
    "zf" '(vimish-fold                    :which-key "create-fold")
    "zd" '(vimish-fold-delete             :which-key "delete-fold")
    "zD" '(vimish-fold-delete-all         :which-key "delete-all-folds")
    "zo" '(vimish-fold-unfold             :which-key "unfold")
    "zO" '(vimish-fold-unfold-all         :which-key "unfold-all")
    "zc" '(vimish-fold-refold             :which-key "refold")
    "zC" '(vimish-fold-refold-all         :which-key "refold-all")
    "zt" '(vimish-fold-toggle             :which-key "fold-toggle")
    "zT" '(vimish-fold-toggle-all         :which-key "fold-toggle-all"))
  :config
  (vimish-fold-global-mode 1))

;; Getcha some racket!
(use-package racket-mode
  :magic ("%RKT" . racket-mode)
  :mode "\\.rkt\\'")

(use-package shell-pop
  :init
  (setq shell-pop-default-directory (getenv "HOME")
        shell-pop-term-shell "/bin/zsh"
        shell-pop-window-position "bottom"
        shell-pop-window-size 30
        shell-pop-full-span t
        shell-pop-shell-type (quote ("ansi-term" "*ansi-term*"
                                     (lambda nil (ansi-term shell-pop-term-shell)))))
  :general
  (general-nmap
    :prefix "SPC"
    "'" '(shell-pop :which-key "shell")))

;; `Paredit' : Maybe ...eventually I'll learn paredit
(use-package paredit
  :general
    (general-nmap
      :prefix "SPC"
      "p"   '(:ignore t                   :which-key "paredit")
      "p("  '(paredit-wrap-round          :which-key "wrap-curly")
      "p["  '(paredit-wrap-square         :which-key "wrap-square")
      "p'"  '(paredit-meta-doublequote    :which-key "double-quote")
      "ps"  '(:ignore t                   :which-key "slurp")
      "psf" '(paredit-forward-slurp-sexp  :which-key "forward-slurp-sexp")
      "psb" '(paredit-backward-slurp-sexp :which-key "backward-slurp-sexp")
      "pb"  '(:ignore t                   :which-key "barf")
      "pbf" '(paredit-forward-barf-sexp   :which-key "forward-barf-sexp")
      "pbb" '(paredit-backward-barf-sexp  :which-key "backward-barf-sexp")
      "pb"  '(paredit-backward            :which-key "back-sexp")
      "pf"  '(paredit-forward             :which-key "forward-sexp"))
  :hook ((emacs-lisp-mode
          eval-expression-minibuffer-setup
          ielm-mode
          lisp-mode
          lisp-interaction-mode
          scheme-mode
          racket-mode) . paredit-mode))

;; ;;; Feed Reader https://github.com/skeeto/elfeed
;; (use-package elfeed
;;   :commands elfeed)

;; ;; https://github.com/remyhonig/elfeed-org
;; (use-package elfeed-org
;;   :after elfeed
;;   :config
;;   (elfeed-org))

;; ;;; https://github.com/algernon/elfeed-goodies
;; (use-package elfeed-goodies
;;   :after elfeed
;;   :config
;;   (elfeed-goodies/setup))

(require 'org-version)
(use-package org
  :defer 5
  :straight org-plus-contrib
  :init
  (setq org-directory (concat (getenv "HOME") "/Documents/org")
        org-default-notes-file (concat org-directory "/notes.org")
        org-mobile-inbox-for-pull (concat org-directory "/Documents/org/flagged.org")
        org-mobile-directory (concat (getenv "HOME") "/Dropbox/Apps/MobileOrg")
        org-startup-with-inline-images t
        org-confirm-babel-evaluate nil)
  (org-babel-do-load-languages 'org-babel-load-languages
    '((python . t)
      (scheme . t)
      ;;(sh     . t)
      (emacs-lisp  . t)
      (haskell .t)))
  ;; In a recent update, 'org-babel-get-header' was removed from org-mode, which
  ;; is something a fair number of babel plugins use. So until those plugins
  ;; update, this polyfill will do:
  (defun org-babel-get-header (params key &optional others)
      (cl-loop with fn = (if others #'not #'identity)
              for p in params
              if (funcall fn (eq (car p) key))
              collect p)))

;; Global org capture keybinding
(general-define-key
  :keymaps '(normal visual emacs)
  :prefix "SPC"
  :non-normal-prefix "C-SPC"
  "o" '(:ignore t    :which-key "org")
  "oc" '(org-capture :which-key "org-capture"))

(use-package org-bullets
  :after org
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(use-package org-noter
  :commands org-noter
  :init
  (setq org-noter-auto-save-last-location t))

;; Place images in org document [https://github.com/abo-abo/org-download]
(use-package org-download
  :after org
  :init
  (setq org-download-image-dir (concat org-directory "/images")))

(use-package mu4e
  :defer t
  :commands mu4e
  :general
  (general-nmap :prefix "SPC" "m" '(mu4e :which-key "mu4e"))
  :init
  (setq mu4e-maildir (expand-file-name "~/Documents/Email")
        mu4e-drafts-folder "/Drafts"
        mu4e-sent-folder "/Sent"
        mu4e-trash-folder "/Trash"
        mu4e-get-mail-command "mbsync gmail"
        mu4e-html2text-command "w3m -T text/html"
        mu4e-update-interval 300
        mu4e-headers-auto-update t
        mu4e-maildir-shortcuts '(("/Gmail" . ?i)
                                 ("/Sent" . ?s)
                                 ("/Trash" . ?t)
                                 ("/Drafts". ?d))
        mu4e-compose-format-flowed t
        mu4e-attachment-dir "/home/bwayne/Downloads/"
        mu4e-use-fancy-chars t
        mu4e-view-show-images t
        mu4e-show-images t
        mu4e-reply-to-address "thebillwayne@gmail.com"
        user-mail-address "thebillywayne@gmail.com"
        user-full-name "Billy Wayne McCann"
        mu4e-sent-messages-behavior 'delete
        message-send-mail-function 'smtpmail-send-it smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
        smtpmail-default-smtp-server "smtp.gmail.com"
        smtpmail-smtp-service 587
        smtpmail-debug-info t)
  (when (fboundp 'imagemagick-register-types) (imagemagick-register-types))
  (use-package evil-mu4e
    :after mu4e)
  :config
  (add-hook 'mu4e-compose-mode-hook (set-fill-column 72)))

;; some of my own functions used in the keybindings below
(require 'bw-funcs)

;;; General Key Definitions

(general-define-key
  :states '(normal emacs)
  :prefix "SPC"
  :non-normal-prefix "C-SPC"
  ";"  '(eval-expression                         :which-key "eval sexp")
  "f"  '(:ignore t                               :which-key "files")
  "fd" '(bw/find-dotfile                         :which-key "edit init.el")
  "r"  '(ranger                                  :which-key "ranger")
  "fl" '(helm-locate                             :which-key "locate-file")
  "fw" '(save-buffer                             :which-key "write-buffer")
  "fs" '(helm-find-files                         :which-key "find-files")
  "fr" '(helm-recentf                            :which-key "recent-files")
  "ft" '(neotree-toggle                          :which-key "neotree")
  "fz" '(fzf                                     :which-key "fzf")
  "w"  '(:ignore t                               :which-key "windows")
  "wd" '(delete-window                           :which-key "delete-window")
  "wo" '(delete-other-windows                    :which-key "delete-other-windows")
  "wv" '(split-window-right                      :which-key "split-window-vertically")
  "ws" '(split-window-below                      :which-key "split-window-below")
  "wh" '(evil-window-left                        :which-key "window-left")
  "wj" '(evil-window-down                        :which-key "window-bottom")
  "wk" '(evil-window-up                          :which-key "window-up")
  "wl" '(evil-window-right                       :which-key "window-right")
  "wH" '(evil-window-move-far-left               :which-key "move-window-left")
  "wJ" '(evil-window-move-very-bottom            :which-key "move-window-bottom")
  "wK" '(evil-window-move-very-top               :which-key "move-window-top")
  "wL" '(evil-window-move-far-right              :which-key "move-window-right")
  "b"  '(:ignore t                               :which-key "buffer")
  "bd" '(kill-this-buffer                        :which-key "kill buffer")
  "bl" '(helm-mini                               :which-key "buffer-list")
  "bm" '(list-buffers                             :which-key "buffer-menu")
  "bn" '(next-buffer                             :which-key "next-buffer")
  "bN" '(evil-buffer-new                         :which-key "new-buffer")
  "bp" '(evil-switch-to-windows-last-buffer      :which-key "last-buffer")
  "bb" '(bw/switch-to-previous-buffer            :which-key "previous-buffer")
  "xe" '(eval-last-sexp                          :which-key "eval-last-sexp")
  "xb" '(eval-buffer                             :which-key "eval-buffer"))

;; reset garbage collection threshold to original value
(run-with-idle-timer 5 nil (lambda ()
                             (setq gc-cons-threshold gc-cons-threshold--orig
                                   gc-cons-percentage gc-cons-percentage--orig )))

;;; load settings set by custom in custom-file
(load custom-file 'noerror 'nomessage)

(add-hook 'after-init-hook (lambda ()
                             (message (emacs-init-time))))
(add-hook 'after-init-hook (lambda ()
                             (load-theme 'solarized-dark)))
