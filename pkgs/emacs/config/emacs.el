;; bootstrap use-package
(package-initialize)
(setq use-package-always-ensure t)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))

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
;;; org-reveal
(use-package ox-reveal
	     :config
	     (setq org-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js"))

;; misc
(use-package htmlize)

