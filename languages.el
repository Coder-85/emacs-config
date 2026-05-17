;; LSP and programming language specific configs
(use-package eglot
  :hook ((c-mode . eglot-ensure)
         (c++-mode . eglot-ensure)
         (python-mode . eglot-ensure)
         (rust-mode   . eglot-ensure)
         (js-mode     . eglot-ensure)))

(setopt eglot-ignored-server-capabilities (list :documentOnTypeFormattingProvider))
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default standard-indent 4)
(setq-default c-basic-offset 4)
(setq-default js-indent-level 2)
(setq-default python-indent-offset 4)
(electric-pair-mode 1)
(electric-quote-mode 1)
