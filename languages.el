;; LSP and programming language specific configs
(use-package eglot
  :hook ((c-ts-mode . eglot-ensure)
         (c++-ts-mode . eglot-ensure)
         (python-ts-mode . eglot-ensure)
         (rust-ts-mode   . eglot-ensure)))

;; Tree sitter
(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(setopt eglot-ignored-server-capabilities (list :documentOnTypeFormattingProvider))
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default standard-indent 4)
(setq-default c-basic-offset 4)
(setq-default c-ts-mode-indent-offset 4)
(setq-default js-indent-level 2)
(setq-default python-indent-offset 4)
(electric-pair-mode 1)
(electric-quote-mode 1)

;; SQL setup
(use-package sql-indent
  :hook (sql-mode . sqlind-minor-mode))

;; Rust setup
(use-package rust-mode)
(use-package cargo-mode
  :hook
  (rust-mode . cargo-minor-mode)
  :config
  (setq compilation-scroll-output t))

;; JS/TS(X) setup
(use-package typescript-ts-mode
  :straight (:type built-in)
  :mode (("\\.ts\\'"  . typescript-ts-mode)
         ("\\.tsx\\'" . tsx-ts-mode)
         ("\\.js\\'"  . typescript-ts-mode)
         ("\\.jsx\\'" . tsx-ts-mode))
  :custom
  (typescript-ts-mode-indent-offset 2))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((tsx-ts-mode typescript-ts-mode)
                 . ("rass"
                    "--" "typescript-language-server" "--stdio"
                    "--" "tailwindcss-language-server" "--stdio"
                    "--" "eslint-lsp" "--stdio"))))

(add-hook 'tsx-ts-mode-hook        #'eglot-ensure)
(add-hook 'typescript-ts-mode-hook #'eglot-ensure)

(use-package electric
  :straight (:type built-in)
  :hook ((tsx-ts-mode . electric-pair-mode)
         (typescript-ts-mode . electric-pair-mode))
  :config
  (defun my/tsx-electric-pairs ()
    "Add JSX-specific auto pairs."
    (setq-local electric-pair-pairs
                (append electric-pair-pairs
                        '((?< . ?>)     ; <Component />
                          (?{ . ?})     ; {expression}
                          (?` . ?`))))  ; template literals
    (setq-local electric-pair-text-pairs electric-pair-pairs))
  (add-hook 'tsx-ts-mode-hook #'my/tsx-electric-pairs)
  (add-hook 'typescript-ts-mode-hook #'my/tsx-electric-pairs))

(use-package auto-rename-tag
  :straight t
  :hook ((tsx-ts-mode . auto-rename-tag-mode)))

(use-package prettier
  :straight t
  :hook ((tsx-ts-mode        . prettier-mode)
         (typescript-ts-mode . prettier-mode)))
