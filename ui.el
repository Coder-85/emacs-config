(use-package git-gutter
  :hook (prog-mode . git-gutter-mode)
  :config
  (setq git-gutter:update-interval 0.02))

(use-package git-gutter-fringe
  :config
  (define-fringe-bitmap 'git-gutter-fr:added [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:modified [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:deleted [128 192 224 240] nil nil 'bottom))

(setq inhibit-startup-message t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)
(set-face-attribute 'default nil :family "LigaMonacoNerdFont" :height 110)
(set-fontset-font t '(#x1F788 . #x1F788) (font-spec :family "NotoSansSymbols2"))
(eldoc-add-command 'c-electric-paren)
(setq make-backup-files nil)
(setq select-enable-clipboard t)
(setq x-select-enable-primary nil)

(pixel-scroll-precision-mode 1)

