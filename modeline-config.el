;; Using doom-modeline
(use-package doom-modeline
  :straight t
  :hook (after-init . doom-modeline-mode)
  :config
  (defface my/modeline-normal
    '((t :background "#575268" :foreground "#D9DFED" :weight bold))
    "Face for normal state indicator.")

  (defface my/modeline-insert
    '((t :background "#575268" :foreground "#D9DFED" :weight bold))
    "Face for insert state indicator.")

  (doom-modeline-def-segment my/hel-state
    "Show current hel modal state"
    (when (bound-and-true-p hel-mode)
    (let* ((label (cond
                   ((bound-and-true-p hel-normal-state) " NOR ")
                   ((bound-and-true-p hel-insert-state) " INS ")
                   (t                                   " ??? ")))
           (face  (cond
                   ((bound-and-true-p hel-normal-state) 'my/modeline-normal)
                   ((bound-and-true-p hel-insert-state) 'my/modeline-insert)
                   (t                                   'my/modeline-normal))))
      (propertize label 'face face))))

  ;; \u2500\u2500 Redefine the main modeline with our segment after buffer-info \u2500\u2500
  (doom-modeline-def-modeline 'main
    '(bar                ; left side
      my/hel-state       ; NOR / INS / MOT  \u2190 right after the bar
      matches
      buffer-info        ; filename
      remote-host
      buffer-position
      selection-info)
    '(misc-info          ; right side
      minor-modes
      input-method
      buffer-encoding
      major-mode
      process
      vcs
      check))

  ;; Apply to all existing windows
  (add-hook 'doom-modeline-mode-hook
            (lambda ()
              (doom-modeline-set-modeline 'main 'default)))

  ;; Force modeline refresh on state change
  (with-eval-after-load 'hel
    (add-hook 'hel-normal-state-entry-hook #'force-mode-line-update)
    (add-hook 'hel-insert-state-entry-hook #'force-mode-line-update)
    (add-hook 'hel-motion-state-entry-hook #'force-mode-line-update))
  :custom
  (doom-modeline-height 28)
  (doom-modeline-bar-width 4)
  (doom-modeline-icon t)
  (doom-modeline-buffer-encoding nil)
  (doom-modeline-vcs-max-length 20))
