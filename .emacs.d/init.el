;; to keep package.el from adding (package-initialize) at the beginning of init.el
;(package-initialize)

;; older versions don’t have user-emacs-directory defined
(unless (boundp 'user-emacs-directory)
  (defconst user-emacs-directory
    (cond ((boundp 'user-init-directory) user-init-directory)
	  (t "~/.emacs.d/"))))

;; to keep Custom from writing directly to init.el
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file) (load-file custom-file))

;; a function to load a file from "./init.d/" in user-emacs-directory
(defconst user-emacs-init-parts-directory (expand-file-name "./init.d/" user-emacs-directory))
(defun load-init-part (file)
  (load-file (expand-file-name file user-emacs-init-parts-directory)))
(defun load-init-part-if-exists (file)
  (let ((file-path (expand-file-name file user-emacs-init-parts-directory)))
    (when (file-exists-p file-path) (load-file file-path))))

;; load all parts
(load-init-part "packages.el")
(load-init-part "appearance.el")
(load-init-part "editing.el")
(load-init-part "personal.el")

;; optionally load parts local to the machine in local.el
(load-init-part-if-exists "mail.el")