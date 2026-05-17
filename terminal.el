(use-package vterm
  :straight t
  :custom
  (vterm-max-scrollback 10000)
  (vterm-kill-buffer-on-exit t)
  (vterm-shell (or (executable-find "fish")
                   (executable-find "bash")))
  :config
  ;; Allow hel insert state to pass keys through to vterm
  (with-eval-after-load 'hel
    (add-hook 'vterm-mode-hook #'hel-insert-state)))

(defvar my/vterm-buffer-name "*vterm-toggle*"
  "Name of the toggleable vterm buffer.")

(defvar my/vterm-window-height 0.3
  "Height of the vterm window as fraction of frame height.")

(defun my/vterm-toggle ()
  "Toggle a vterm window at the bottom of the frame"
  (interactive)
  (let ((buf (get-buffer my/vterm-buffer-name)))
    (if (and buf (get-buffer-window buf))
      ;; Already visible — hide it
      (delete-window (get-buffer-window buf))
      ;; Not visible — show or create it
      (let ((win (split-window (frame-root-window)
                               (- (round (* (frame-height)
                                            my/vterm-window-height)))
                               'below)))
        (select-window win)
        (if (buffer-live-p buf)
            (switch-to-buffer buf)
          (vterm my/vterm-buffer-name)
          (setq-local display-line-numbers nil))))))

(defun my/vterm-enter-insert ()
  "Switch to insert state properly in vterm"
  (interactive)
  (let ((inhibit-read-only t))
    (when (bound-and-true-p vterm-copy-mode)
      (vterm-copy-mode -1))
    (hel-insert-state)))

(defun my/vterm-enter-normal ()
  "Switch to normal state in vterm"
  (interactive)
  (hel-normal-state))

(add-hook 'vterm-mode-hook
          (lambda ()
            ;; Override i/a/I/A in normal state to use vterm-aware insert
            (with-eval-after-load 'hel
            (hel-keymap-set vterm-mode-map :state 'normal
                "i" #'my/vterm-enter-insert
                "a" #'my/vterm-enter-insert
                "I" #'my/vterm-enter-insert
                "A" #'my/vterm-enter-insert
                "y" #'vterm-copy-mode-done
                "p" (lambda () (interactive) (vterm-send-string
                                              (gui-get-selection 'CLIPBOARD))))
              (hel-keymap-set vterm-mode-map :state 'insert
                "<escape>" #'my/vterm-enter-normal))))
