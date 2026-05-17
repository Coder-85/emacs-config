;; Contains configuration for latex as well

(defun my/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("\u25c9" "\u25cb" "\u25cf" "\u25cb" "\u25cf" "\u25cb" "\u25cf")))

(use-package org-present
  :config
  (with-eval-after-load 'hel
    (hel-keymap-set org-present-mode-keymap :state 'normal
      "<right>" #'org-present-next
      "<left>"  #'org-present-prev))
  :hook
  (org-present-mode . hel-normal-state))

(use-package visual-fill-column
  :init
  (setq visual-fill-column-width 110
    visual-fill-column-center-text t))

(defun my/org-present-start ()
  ;; Tweak font sizes
  (setq-local face-remapping-alist '((default (:height 1.5) variable-pitch)
                                     (header-line (:height 4.0) variable-pitch)
                                     (org-document-title (:height 1.75) org-document-title)
                                     (org-code (:height 1.55) org-code)
                                     (org-verbatim (:height 1.55) org-verbatim)
                                     (org-block (:height 1.25) org-block)
                                     (org-block-begin-line (:height 0.7) org-block)))

  (setq header-line-format " ")

  ;; Display inline images automatically
  (org-display-inline-images)

  ;; Center the presentation and wrap lines
  (visual-fill-column-mode 1)
  (visual-line-mode 1))

(defun my/org-present-end ()
  (setq-local face-remapping-alist '((default variable-pitch default)))
  (setq header-line-format nil)

  (visual-fill-column-mode 0)
  (visual-line-mode 0))

;; Turn on variable pitch fonts in Org Mode buffers
(add-hook 'org-mode-hook 'variable-pitch-mode)

;; Register hooks with org-present
(add-hook 'org-present-mode-hook 'my/org-present-start)
(add-hook 'org-present-mode-quit-hook 'my/org-present-end)

;; Drawing and hand notes
(use-package edraw
  :straight (edraw :host github
                   :repo "misohena/el-easydraw"
                   :files ("*.el" "msg"))
  :config
  (autoload 'edraw-mode "edraw-mode")
  (add-to-list 'auto-mode-alist '("\\.edraw\\.svg$" . edraw-mode))

  (with-eval-after-load 'org
    (require 'edraw-org)
    (edraw-org-setup-default))

  (with-eval-after-load 'ox
    (require 'edraw-org)
    (edraw-org-setup-exporter)))

;; Setup for latex
;; Both for inline latex+latex mode
(use-package auctex)
(use-package cdlatex
  :hook ((LaTeX-mode . turn-on-cdlatex)
         (org-mode   . turn-on-org-cdlatex)))

(use-package math-delimiters :straight (math-delimiters :host github :repo "sp1ff/math-delimiters"))
(autoload 'math-delimiters-insert "math-delimiters")
(with-eval-after-load 'tex
  (define-key TeX-mode-map "$" #'math-delimiters-insert))

(with-eval-after-load 'tex-mode
  (define-key tex-mode-map "$" #'math-delimiters-insert))

(with-eval-after-load 'cdlatex
  (define-key cdlatex-mode-map "$" nil))

;; Settings for org mode
(with-eval-after-load 'org
  (setq org-image-align 'center)
  (setq org-ellipsis " \u25be"
        org-hide-emphasis-markers t)
  (define-key org-mode-map (kbd "C-<return>") #'org-meta-return)
  (define-key org-mode-map (kbd "M-<return>") nil)
  (define-key org-mode-map "$" #'math-delimiters-insert)

  (plist-put
   (cdr (assoc 'dvipng org-preview-latex-process-alist))
   :latex-compiler '("latex -interaction nonstopmode -output-directory %o %f"
                     "latex -interaction nonstopmode -output-directory %o %f"
                     "latex -interaction nonstopmode -output-directory %o %f"))
  
  (plist-put
   (cdr (assoc 'dvisvgm org-preview-latex-process-alist))
   :latex-compiler '("latex -interaction nonstopmode -output-directory %o %f"
                     "latex -interaction nonstopmode -output-directory %o %f"
                     "latex -interaction nonstopmode -output-directory %o %f"))
  (plist-put
   (cdr (assoc 'imagemagick org-preview-latex-process-alist))
   :latex-compiler '("latex -interaction nonstopmode -output-directory %o %f"
                     "latex -interaction nonstopmode -output-directory %o %f"
                     "latex -interaction nonstopmode -output-directory %o %f"))

  (font-lock-add-keywords 'org-mode
                        '(("^ *\\([-]\\) "
                          (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "\u2022"))))))

  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1))))

  (require 'org-indent)

  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)

  (setq
    org-babel-latex-preamble
     (lambda (_)
       "\\documentclass[preview]{standalone}
     "))

  (add-hook 'org-mode-hook
          (lambda ()
            (setq-local electric-pair-mode nil)))
  (add-hook 'org-mode-hook #'my/org-mode-setup))

