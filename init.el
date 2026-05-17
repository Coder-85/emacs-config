;; Bootstrap straight.el for package management
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el"
                         user-emacs-directory))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)
(setq package-install-upgrade-built-in t)

;; Load Theme
(add-to-list 'custom-theme-load-path
             (expand-file-name "themes" user-emacs-directory))
(load-theme 'aurora t)

;; Load configurations
(load-file (concat user-emacs-directory "deps.el"))
(load-file (concat user-emacs-directory "which-key-config.el"))
(load-file (concat user-emacs-directory "project-config.el"))
(load-file (concat user-emacs-directory "hel-config.el"))
(load-file (concat user-emacs-directory "magit-config.el"))
(load-file (concat user-emacs-directory "modeline-config.el"))
(load-file (concat user-emacs-directory "completions.el"))
(load-file (concat user-emacs-directory "languages.el"))
(load-file (concat user-emacs-directory "terminal.el"))
(load-file (concat user-emacs-directory "ui.el"))
(load-file (concat user-emacs-directory "org-config.el"))
