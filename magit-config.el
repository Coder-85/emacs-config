(use-package magit :straight (magit :host github :repo "magit/magit"))

(add-hook 'git-commit-mode-hook #'hel-insert-state)
