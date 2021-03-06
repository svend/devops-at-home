;;; init.el -*- lexical-binding: t; -*-
;;; $DOOMDIR/init.el
(doom! :input
       :completion (company) (ivy +fuzzy +prescient +icons)
       :ui
       doom doom-dashboard doom-quit hl-todo modeline ophints (popup +defaults)
       (pretty-code +fira) treemacs vc-gutter vi-tilde-fringe
       (window-select +switch-window) workspaces
       :editor
       (evil +everywhere) file-templates fold format snippets
       :emacs (dired +icons) electric (ibuffer +icons) undo vc
       :term vterm
       :checkers syntax (spell +hunspell)
       :tools ansible debugger direnv (docker +lsp) editorconfig (eval +overlay)
       gist (lookup +dictionary) (lsp +peek) magit make pass pdf rgb tmux upload
       :lang
       (cc +lsp) (csharp +lsp) data emacs-lisp erlang (go +lsp)
       (javascript +lsp) json (latex +lsp +fold) lua (markdown +grip) nix
       (org +dragndrop +gnuplot +pretty) php plantuml (python +lsp +pyright)
       rest (rust +lsp) (sh +fish +lsp) web (yaml +lsp)
       :mail
       :app
       :config (default +bindings +smartparens))

;; Until https://github.com/hlissner/doom-emacs/issues/2447 resolved
(setq evil-respect-visual-line-mode t)
