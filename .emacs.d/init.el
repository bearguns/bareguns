;;; init.el -*- lexical-binding: t; -*-

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; GUI Emacs doesn't inherit the shell PATH (mise node, claude-agent-acp).
(use-package exec-path-from-shell
  :ensure t
  :config (exec-path-from-shell-initialize))

(use-package catppuccin-theme
  :ensure t
  :config (load-theme 'catppuccin :no-confirm))

;; Vue SFCs: web-mode highlights the template plus embedded TS/CSS.
(use-package web-mode
  :ensure t
  :mode "\\.vue\\'"
  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2)
  ;; Oxfmt leaves <script>/<style> contents unindented.
  (web-mode-script-padding 0)
  (web-mode-style-padding 0))

;; Plain .ts/.tsx via built-in tree-sitter modes; grammars compile on first run.
(setq treesit-language-source-alist
      '((typescript "https://github.com/tree-sitter/tree-sitter-typescript" "v0.23.2" "typescript/src")
        (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "v0.23.2" "tsx/src")))
(dolist (lang '(typescript tsx))
  (unless (treesit-language-available-p lang)
    (treesit-install-language-grammar lang)))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))

(use-package agent-shell
  :ensure t
  :bind ("C-c a" . agent-shell)
  :config
  ;; Reuse the existing `claude' login instead of an API key.
  (setq agent-shell-anthropic-authentication
        (agent-shell-anthropic-make-authentication :login t)))
