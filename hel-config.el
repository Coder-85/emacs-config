;; Contains hel config and global keymaps
(use-package hel
  :straight (hel :host github
                 :repo "anuvyklack/hel"
                 :files (:defaults "extensions/**/*.el"))
  :init
  ;; Block cursor in normal state, bar in insert state
  (setq hel-normal-state-cursor-type 'box)
  (setq hel-insert-state-cursor-type 'bar)
  (setq hel-motion-state-cursor-type 'box)

  :config
  (hel-mode)

  (hel-keymap-global-set :state 'insert
    "C-o" #'hel-normal-state)
  (hel-keymap-global-set :state 'normal
    "}" #'forward-sexp)
  (hel-keymap-global-set :state 'normal
    "{" #'backward-sexp)
  (require 'hel-leader)

  (defvar my-leader-map (make-sparse-keymap)
    "Global Space leader keymap.")

  (hel-keymap-global-set :state '(normal motion)
    "SPC" my-leader-map)

  ;; Group labels for which-key popup
  (which-key-add-keymap-based-replacements my-leader-map
    "f"   "files"
    "b"   "buffers"
    "s"   "search"
    "w"   "windows"
    "g"   "git/goto"
    "n"   "notes"
    "c"   "code/LSP"
    "P"   "project"
    "t"   "toggles"
    "h"   "help")

  (hel-keymap-set my-leader-map
    "y" (lambda () (interactive)
          (when (use-region-p)
            (gui-set-selection 'CLIPBOARD
                               (buffer-substring-no-properties
                                (region-beginning) (region-end)))))
    "p" (lambda () (interactive)
          (insert (gui-get-selection 'CLIPBOARD))))

  (hel-keymap-set my-leader-map
    "f f" #'find-file
    "f r" #'consult-recent-file
    "f s" #'save-buffer
    "f S" #'write-file
    "f d" #'dired-jump
    "f R" #'rename-visited-file)

  (hel-keymap-set my-leader-map
    "b b" #'consult-buffer
    "b d" #'kill-current-buffer
    "b D" #'kill-buffer-and-window
    "b n" #'next-buffer
    "b p" #'previous-buffer
    "b s" #'scratch-buffer
    "b r" #'revert-buffer)

  (hel-keymap-set my-leader-map
    "s s" #'consult-line
    "s S" #'consult-line-multi
    "s g" #'consult-ripgrep
    "s f" #'consult-find
    "s i" #'consult-imenu
    "s I" #'consult-imenu-multi
    "s r" #'query-replace
    "s R" #'query-replace-regexp)

  (hel-keymap-set my-leader-map
    "w s" #'hel-window-split
    "w v" #'hel-window-vsplit
    "w c" #'hel-window-delete
    "w o" #'delete-other-windows
    "w w" #'other-window
    "w h" #'windmove-left
    "w j" #'windmove-down
    "w k" #'windmove-up
    "w l" #'windmove-right
    "w H" #'hel-move-window-left
    "w J" #'hel-move-window-down
    "w K" #'hel-move-window-up
    "w L" #'hel-move-window-right
    "w r" #'revert-buffer
    "w b" #'clone-indirect-buffer-other-window)

  (hel-keymap-set my-leader-map
    "g g" #'magit-status
    "g b" #'magit-blame
    "g l" #'magit-log-current
    "g d" #'xref-find-definitions
    "g r" #'xref-find-references
    "g i" #'consult-imenu
    "g o" #'browse-url-at-point)

  (hel-keymap-set my-leader-map
    "c a" #'eglot-code-actions
    "c r" #'eglot-rename
    "c f" #'eglot-format
    "c F" #'eglot-format-buffer
    "c d" #'xref-find-definitions
    "c D" #'xref-find-definitions-other-window
    "c R" #'xref-find-references
    "c e" #'consult-flymake
    "c t" #'my/vterm-toggle
    "c n" #'flymake-goto-next-error
    "c p" #'flymake-goto-prev-error)

  (hel-keymap-set my-leader-map
    "P p" #'project-switch-project
    "P f" #'project-find-file
    "P r" #'my/project-run
    "P g" #'consult-ripgrep
    "P b" #'project-switch-to-buffer
    "P k" #'project-kill-buffers
    "P d" #'project-dired)

  (hel-keymap-set my-leader-map
    "t l" #'display-line-numbers-mode
    "t r" #'display-line-numbers-mode
    "t w" #'visual-line-mode
    "t s" #'flyspell-mode
    "t W" #'whitespace-mode
    "t i" #'indent-tabs-mode)

  (hel-keymap-set my-leader-map
    "h h" #'eldoc-box-help-at-point
    "h f" #'describe-function
    "h v" #'describe-variable
    "h k" #'describe-key
    "h m" #'describe-mode
    "h p" #'describe-package
    "h b" #'describe-bindings
    "h i" #'info)

  (defun my/select-left ()
    (interactive)
    (unless (region-active-p) (set-mark (point)))
    (backward-char 1))

  (defun my/select-right ()
    (interactive)
    (unless (region-active-p) (set-mark (point)))
    (forward-char 1))

  (defun my/select-up ()
    (interactive)
    (unless (region-active-p) (set-mark (point)))
    (previous-line 1))

  (defun my/select-down ()
    (interactive)
    (unless (region-active-p) (set-mark (point)))
    (next-line 1))

   (hel-keymap-global-set :state 'normal
     "H" #'my/select-left
     "J" #'my/select-down
     "K" #'my/select-up
     "L" #'my/select-right))

;; Some handy commands
(defun ex-write ()
  "Save current buffer (:w)."
  (interactive)
  (save-buffer))

(defun ex-write-quit ()
  "Save and close (:wq)."
  (interactive)
  (save-buffer)
  (delete-window))

(defalias 'w 'ex-write)
(defalias 'q 'delete-window)
(defalias 'wq 'ex-write-quit)

