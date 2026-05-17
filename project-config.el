(defun my/project-root ()
  "Return current project root or nil."
  (when-let ((proj (project-current)))
    (project-root proj)))

(defun my/project-run ()
  "Run project command from .dir-locals.el or prompt and save it there."
  (interactive)
  (let* ((root    (or (my/project-root)
                      (read-directory-name "Project root: ")))
         (locals  (expand-file-name ".dir-locals.el" root))
         ;; Read saved command from .dir-locals.el if it exists
         (saved   (when (file-exists-p locals)
                    (with-temp-buffer
                      (insert-file-contents locals)
                      (let ((data (read (current-buffer))))
                        (alist-get 'my/project-run-command
                                   (alist-get nil data))))))
         (command (if (and saved (not current-prefix-arg))
                      saved
                    (let ((cmd (read-shell-command
                                (format "Run command for %s: "
                                        (file-name-nondirectory
                                         (directory-file-name root)))
                                saved)))
                      ;; Save it back to .dir-locals.el
                      (with-temp-file locals
                        (insert (format "((nil . ((my/project-run-command . %S))))\n"
                                        cmd)))
                      cmd))))

    (let ((buf (get-buffer my/vterm-buffer-name)))
      (unless (and buf (get-buffer-window buf))
        (my/vterm-toggle)))

    (when-let ((buf (get-buffer my/vterm-buffer-name)))
      (with-current-buffer buf
        (vterm-send-string (format "set p \"%s\"; set p (string replace -r '^~' $HOME -- $p); cd \"$p\" && %s"
                                   root
                                   command))
        (vterm-send-return)))))

;; Make sure whats the project run command manually!
(put 'my/project-run-command 'safe-local-variable #'stringp)
