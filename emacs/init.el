;;; init.el --- My Emacs configuration -*- lexical-binding: t; -*-

;; Cleaned up and organized version – February 2026

;; ──────────────────────────────────────────────────────────────
;; 1. Package system & use-package bootstrap
;; ──────────────────────────────────────────────────────────────

(require 'package)

(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu"   . "https://elpa.gnu.org/packages/")))

(package-initialize)

;; Install use-package if missing
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; ──────────────────────────────────────────────────────────────
;; 2. General settings & UI/behavior tweaks
;; ──────────────────────────────────────────────────────────────

;; Suppress many warnings (careful — can hide real problems)
(setq warning-suppress-types '((comp) (bytecomp) (initialization)))

;; y/n instead of yes/no
(defalias 'yes-or-no-p 'y-or-n-p)

;; Line numbers
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'absolute)

;; Pair brackets, show matching parens
(electric-pair-mode 1)
(show-paren-mode 1)

;; Smooth scrolling (pixel precision when available)
(when (fboundp 'pixel-scroll-precision-mode)
  (pixel-scroll-precision-mode 1))

(setq scroll-margin 8
      scroll-conservatively 100000
      scroll-preserve-screen-position t)

;; Italic comments & doc strings
(set-face-attribute 'font-lock-comment-face nil :slant 'italic)
(set-face-attribute 'font-lock-doc-face    nil :slant 'italic)

;; No toolbar
(tool-bar-mode -1)
(menu-bar-mode -1)

;; doom-modeline

(use-package doom-modeline
  :ensure t)

;; ──────────────────────────────────────────────────────────────
;; 3. Completion framework — Vertico + family
;; ──────────────────────────────────────────────────────────────

(use-package vertico
  :ensure t
  :init
  (vertico-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides
   '((file (styles basic partial-completion)))))

(use-package marginalia
  :ensure t
  :after vertico
  :init
  (marginalia-mode))

(use-package consult
  :ensure t
  :bind (("C-s"     . consult-line)
         ("C-x b"   . consult-buffer)
         ;; Optional useful extras
         ("M-y"     . consult-yank-pop)
         ("C-x C-r" . consult-recent-file)))

;; ──────────────────────────────────────────────────────────────
;; 4. modeline
;; ──────────────────────────────────────────────────────────────
 
;; (use-package doom-modeline
;;   :init (doom-modeline-mode 1)
;;   :config
;;   (setq doom-modeline-height 25
;;         doom-modeline-bar-width 3
;;         doom-modeline-buffer-file-name-style 'truncate-upto-project
;;         doom-modeline-icon nil  ;; No icons for cleaner look
;;         doom-modeline-major-mode-icon nil
;;         doom-modeline-buffer-encoding nil))

;; ──────────────────────────────────────────────────────────────
;; 5. Editing / programming aids
;; ──────────────────────────────────────────────────────────────

;; Indent guides
(use-package highlight-indent-guides
  :ensure t
  :hook (prog-mode . highlight-indent-guides-mode)
  :config
  (setq highlight-indent-guides-method 'character
        highlight-indent-guides-character ?\│
        highlight-indent-guides-responsive 'top
        highlight-indent-guides-auto-enabled t
        highlight-indent-guides-auto-odd-face-perc 5
        highlight-indent-guides-auto-even-face-perc 10
        highlight-indent-guides-auto-character-face-perc 20))

;; Company — autocompletion
(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :custom
  (company-idle-delay 0.1)
  (company-minimum-prefix-length 1))

;; Flycheck — syntax checking
(use-package flycheck
  :ensure t
  :hook (after-init . global-flycheck-mode))

;; LSP (mainly for C/C++ with clangd)
(use-package lsp-mode
  :ensure t
  :hook (c++-mode . lsp)
  :custom
  (lsp-prefer-flymake nil))             ; use flycheck instead

;; ──────────────────────────────────────────────────────────────
;; 6. Language / file-type specific
;; ──────────────────────────────────────────────────────────────

;; Default to c++-mode for .cpp, .h, etc.
(setq-default major-mode 'c++-mode)

;; Default compile command for quick C++ testing
(setq compile-command "g++ -std=c++17 -g -o main main.cpp ")

;; ──────────────────────────────────────────────────────────────
;; 7. Appearance
;; ──────────────────────────────────────────────────────────────

(load-theme 'tango-dark t)

;; ──────────────────────────────────────────────────────────────
;; Custom-set variables (leave at the very end)
;; ──────────────────────────────────────────────────────────────

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(display-line-numbers-type 'absolute)
 '(global-display-line-numbers-mode t)
 '(package-selected-packages
   '(doom-modeline highlight-indent-guides vertico consult orderless marginalia lsp-mode flycheck company))
 '(tool-bar-mode nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "DejaVu Sans Mono" :foundry "PfEd" :slant normal :weight regular :height 120 :width normal)))))

(provide 'init)
;;; init.el ends here
