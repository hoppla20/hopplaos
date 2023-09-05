;;;; Basic Configuration

;; package archives

(require 'package)
(setq package-archives
'(
   ("melpa" . "https://melpa.org/packages/")
   ("melpaStable" . "https://stable.melpa.org/packages/")
   ("nongnu" . "https://elpa.nongnu.org/nongnu/")
   ("elpa" . "https://elpa.gnu.org/packages/")
   ("elpaDevel" . "https://elpa.gnu.org/devel/")
 ))
(package-initialize)

;; use-package

(setq use-package-always-ensure t)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))

;;;;;; UI

;;;; Plugins

;;;;;; Essentials

;; evil

(use-package goto-chg)
(use-package undo-tree
	     :config
	     (global-undo-tree-mode))
(use-package evil
	     :after (goto-chg undo-tree)
	     :init
	     (setq evil-undo-system 'undo-tree)
	     (setq evil-want-integration t)
	     (setq evil-want-keybinding nil)
	     (setq evil-overriding-maps nil)
	     :config
	     (evil-mode 1))
(use-package evil-collection
	     :after evil
	     :config
	     (evil-collection-init))

;; org

(use-package org
	     :mode (("\\.org$" . org-mode))
	     :config)

;;;;;; Misc

;; org-reveal (presentations)

(use-package htmlize)
(use-package ox-reveal
	     :after htmlize
	     :config
	     (setq org-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js"))

