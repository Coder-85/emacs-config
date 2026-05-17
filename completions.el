;; Minibuffer completion
(use-package vertico
  :init (vertico-mode))

;; Popup documentations
(use-package eldoc-box)

;; Completion styles configs
(use-package orderless
  :custom
  (completion-styles '(orderless basic flex))
  (completion-category-overrides '((file (styles basic flex partial-completion)))))

(use-package consult
  :bind (("C-s" . consult-line)
         ("M-y" . consult-yank-pop)))

(use-package marginalia
  :init (marginalia-mode))

;; In buffer completion
(use-package cape
  :straight t
  :init
  (setq cape-dabbrev-min-length 2)
  (setq cape-dabbrev-buffer-function #'cape-text-buffers)
  :bind (("C-c b" . cape-dabbrev)
        ("C-c f" . cape-file))
  :config
    (defun my/cape-super ()
      (add-hook 'completion-at-point-functions
                (cape-capf-super #'cape-dabbrev
                                 #'cape-keyword)
                20 t))

    (add-hook 'completion-at-point-functions #'cape-file)

    (add-hook 'text-mode-hook #'my/cape-super)
    (add-hook 'prog-mode-hook #'my/cape-super))

(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-auto-prefix 2)
  (corfu-auto-delay 0.1)
  (corfu-popupinfo-delay 0.2)
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode))

(use-package nerd-icons-corfu
  :straight t
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))


