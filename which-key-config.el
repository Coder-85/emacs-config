(use-package which-key
  :straight t
  :init
  (setq which-key-idle-delay 0.3)
  (setq which-key-idle-secondary-delay 0.05)
  (setq which-key-max-description-length 40)
  (setq which-key-sort-order 'which-key-key-order-alpha)
  (setq which-key-add-column-padding 2)
  (setq which-key-separator " → ")
  :config
  (which-key-mode 1)
  (add-to-list 'which-key-replacement-alist
               '(("^C-w C-[a-z]" . nil) . ignore)))

(use-package which-key-posframe
  :straight t
  :after (which-key posframe)
  :custom
  (which-key-posframe-poshandler
   'posframe-poshandler-frame-bottom-center)
  (which-key-posframe-border-width 2)
  (which-key-posframe-parameters
   '((left-fringe  . 8)
     (right-fringe . 8)))
  :config
  (which-key-posframe-mode 1))
