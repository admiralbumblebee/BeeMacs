;; LISP

(use-package adjust-parens)

(use-package aggressive-indent)

(use-package lispyville
  :config (lispyville-set-key-theme
	   '(operators
	     c-w
	     slurp/barf-cp
	     commentary
	     text-objects
	     additional
	     additional-insert
	     additional-movement
	     (additional-wrap normal visual insert)
	     escape
	     atom-movement
	     commentary)))

(use-package lispy)

;; Clojure

(use-package clojure-mode
  :config (progn
     (define-key clojure-mode-map (kbd "C-z") 'run-clojure-no-prompt)
     (define-key clojure-mode-map (kbd "C-c C-z") 'run-clojure)
     (add-hook 'clojure-mode-hook 'lisp-mode-hooks)))

(setq clojure-align-forms-automatically t)

(use-package clj-refactor)

(setq inferior-lisp-program "clojure")

(defvar clj-repl-command)

(defvar clj-repl-command-history '())

(savehist-mode 1)

(add-to-list 'savehist-additional-variables 'clj-repl-command-history)

(defun run-clojure-no-prompt ()
  (interactive)
  (if (and (boundp 'clj-repl-command)
           (stringp (car clj-repl-command)))
      (run-clojure-command (car clj-repl-command))
    (run-clojure-command "clojure")))

(defun run-clojure (cmd)
  (interactive (list
                (if (boundp 'clj-repl-command)
                    (let ((first-command (car clj-repl-command))
                          (rest-commands (if clj-repl-command-history
						                     (append (cdr clj-repl-command) clj-repl-command-history)
						                   (cdr clj-repl-command))))
                      (read-from-minibuffer "Command:" first-command nil nil 'rest-commands))
                  (read-from-minibuffer "Command:" "clojure" nil nil 'clj-repl-command-history))))
  (run-clojure-command cmd))

(defun run-clojure-command (cmd)
  (let ((dd (if (and (fboundp 'clojure-project-root-path)
                     (stringp (clojure-project-root-path)))
			    (clojure-project-root-path)
			  default-directory))
	    cb (curent-buffer))
    (cd dd)
    (add-to-list 'clj-repl-command-history cmd)
    (run-lisp cmd)
    (switch-to-buffer cb)
    (switch-to-buffer-other-window "*inferior-lisp*")))

(use-package flycheck-clj-kondo)

(defun lisp-mode-hooks ()
  (lispy-mode 1)
  (aggressive-indent-mode)
  (adjust-parens-mode)
  (electric-pair-mode))

(add-hook 'lisp-mode-hook 'lisp-mode-hooks)
(add-hook 'lisp-interaction-mode-hook 'lisp-mode-hooks)
(add-hook 'emacs-lisp-mode-hook 'lisp-mode-hooks)
