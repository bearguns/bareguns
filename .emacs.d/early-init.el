;;; early-init.el --- Startup optimizations, early wins in init cycle -*- lexical-binding: t; -*-
;; Runs before init.el

;; GC hacks
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

(setq lsp-use-plists t)

(setq native-comp-async-report-warnings-errors 'silent
      native-comp-warning-on-missing-source nil)

(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
;; Match kitty: JetBrainsMono Nerd Font Mono, 16pt.
(push '(font . "JetBrainsMono Nerd Font Mono-16") default-frame-alist)


