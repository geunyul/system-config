;; Red Hat Linux default .emacs initialization file  ; -*- mode: emacs-lisp -*-

(when (file-exists-p (format "~/.emacs_d/lisp/bhj-%s.el" (symbol-name system-type)))
  (load (format "~/.emacs_d/lisp/bhj-%s.el" (symbol-name system-type))))

(defconst *is-a-mac* (eq system-type 'darwin))
(defconst *is-a-win* (eq system-type 'windows-nt))
(when (and (file-exists-p "/etc/emacs/site-start.d/00debian-vars.el")
           (not (fboundp 'debian-file->string)))
  (load "/usr/share/emacs/site-lisp/debian-startup.el")
  (setq debian-emacs-flavor
        (intern
         (concat "emacs" (replace-regexp-in-string "\\..*" "" emacs-version))))
  (let ((flavor 'emacs))
    (mapc (lambda (file)
            (load file))
          (directory-files "/etc/emacs/site-start.d/" t ".*.el"))))
(when (file-exists-p (expand-file-name "~/.emacs-path.el"))
  (load-file (expand-file-name "~/.emacs-path.el")))

(setq load-path
      (nconc (list
              "/usr/share/emacs/site-lisp/gnus"
              "/opt/local/share/emacs/site-lisp/gnus"
              (expand-file-name "~/src/gnus")
              (expand-file-name "~/src/bbdb/lisp")
              (expand-file-name (concat "~/system-config/.emacs_d/" (symbol-name system-type)))
              (expand-file-name "~/system-config/.emacs_d/lisp")
              (expand-file-name "~/system-config/.emacs_d/skeleton-complete")
              (expand-file-name "~/system-config/.emacs_d/org-confluence")
              (expand-file-name "~/system-config/.emacs_d/org-jira")
              (expand-file-name "~/system-config/.emacs_d/mo-git-blame")
              (expand-file-name "~/system-config/.emacs_d/lisp/ext")
              (expand-file-name "~/system-config/.emacs_d/weblogger")
              (expand-file-name "~/system-config/.emacs_d/org2blog")
              (expand-file-name "~/src/github/helm")
              (expand-file-name "~/src/github/org-mode/contrib/lisp"))
             load-path))

(when (file-exists-p (expand-file-name "~/.config/emacs.gen.el"))
  (load (expand-file-name "~/.config/emacs.gen.el")))


(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/"))
(package-initialize)

(when (and
       (file-exists-p "~/src/github/emacs.d/init.el")
       (not (string= (getenv "ORG2PDF") "true")))
  (load "init.el"))

(require 'mmm-auto)

(when  (or (eq system-type 'cygwin) (eq system-type 'windows-nt))
  ;;press F2 to get MSDN help
  (global-set-key[(f2)](lambda()(interactive)(call-process "/bin/bash" nil nil nil "/q/bin/windows/ehelp" (current-word))))
  (setq locate-command "locateEmacs.sh"))

(when (eq system-type 'windows-nt)
  (require 'cygwin-mount)
  (cygwin-mount-activate)
  (require 'w32-symlinks))


(when window-system
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (load "bhj-fonts.el"))

(autoload 'csharp-mode "csharp-mode")



(autoload 'sdim-use-package "sdim" "Shadow dance input method")
(register-input-method
 "sdim" "euc-cn" 'sdim-use-package "影舞笔")

(mapcar (lambda (x) (add-hook x (lambda ()
                    (setq beginning-of-defun-function #'ajoke--beginning-of-defun-function)
                    (local-set-key [?\C-\M-a] 'beginning-of-defun)
                    (local-set-key [?\C-\M-e] 'end-of-defun))))
        (list 'c-mode-hook 'c++-mode-hook 'csharp-mode-hook 'java-mode-hook))

(mapcar (lambda (x) (add-hook x (lambda ()
                    (local-set-key [?\C-c ?\C-d] 'c-down-conditional)
                    (c-set-offset 'innamespace 0)
                    (c-set-offset 'substatement-open 0))))
        (list 'c-mode-hook 'c++-mode-hook))






(auto-image-file-mode)
(put 'set-goal-column 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'LaTeX-hide-environment 'disabled nil)


(require 'browse-kill-ring-autoloads)
(browse-kill-ring-default-keybindings)

;; enable visual feedback on selections

;;popup the manual page, try:)
(put 'narrow-to-region 'disabled nil)



(require 'org2blog-autoloads)

(global-set-key [(meta control \,)] 'ajoke-pop-mark)
(global-set-key [(meta control .)] 'ajoke-pop-mark-back)
(prefer-coding-system 'gbk)
(prefer-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)


(put 'upcase-region 'disabled nil)


(fset 'grep-buffers-symbol-at-point 'current-word)



(standard-display-ascii ?\221 "\`")
(standard-display-ascii ?\222 "\'")
(standard-display-ascii ?\223 "\"")
(standard-display-ascii ?\224 "\"")
(standard-display-ascii ?\227 "\-")
(standard-display-ascii ?\225 "\*")

(keydef "C-S-g" (progn (setq grep-buffers-buffer-name "*grep-buffers*")(grep-buffers)))





;; old time motorola usage
;; (defcustom bhj-clt-branch "dbg_zch68_a22242_ringtone-hx11i"
;;   "the cleartool branch to use for mkbranch")

;; (defun bhj-clt-insert-branch ()
;;   (interactive)
;;   (insert bhj-clt-branch))
;; (define-key minibuffer-local-shell-command-map [(control meta b )] 'bhj-clt-insert-branch)


(defvar last-grep-marker nil)

(defcustom bhj-force-cleanup-buffer nil
  "force to clean up the buffer before save"
  :type 'boolean)

(make-variable-buffer-local 'bhj-force-cleanup-buffer)

(defvar ajoke-output-buffer-name "*ajoke*"
  "The name of the ajoke output buffer.")

(keydef "M-g r" (progn
                  (let ((current-prefix-arg 4)
                        ;; (default-directory (eval bhj-grep-default-directory))
                        (grep-use-null-device nil))
                    (nodup-ring-insert ajoke--marker-ring (point-marker))
                    (call-interactively 'grep-bhj-dir))))

(defvar grep-find-file-history nil)

(defvar grep-rgrep-history nil)


(setq my-grep-command "beagrep -e pat") ;; should not put it into custom, the custom will be read every time and so the `(let ((grep-command ..' scheme will fail


(defvar grep-gtags-history nil)
(defvar grep-imenu-history nil)
(defvar bhj-occur-regexp nil)

(put 'scroll-left 'disabled nil)

(fset 'bhj-bhjd
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("\"" 0 "%d")) arg)))
(fset 'bhj-preview-markdown
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([24 49 67108896 3 2 134217848 98 104 106 45 109 105 109 101 tab return 3 return 80 24 111 67108911 24 111] 0 "%d")) arg)))

(add-hook 'w3m-mode-hook
          (lambda ()
            (local-set-key [(left)] 'backward-char)
            (local-set-key [(right)] 'forward-char)
            (local-set-key [(\ )] 'bhj-w3m-scroll-up-or-next-url)
            (local-set-key [(backspace)] 'bhj-w3m-scroll-down-or-previous-url)
            (local-set-key [(down)] 'next-line)
            (local-set-key [(up)] 'previous-line)
            (local-set-key [(n)] 'next-line)
            (local-set-key [(p)] 'previous-line)
            ))

(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)

(require 'skeleton-complete)
(skeleton-complete-global-mode 1)


(keydef "C-M-j" 'bhj-jdk-help)
(keydef (w3m "C-c e") (lambda()(interactive)(call-process "/bin/bash" nil nil nil "/q/bin/windows/w3m-external" w3m-current-url)))


;; Command to point VS.NET at our current file & line

;; Command to toggle a VS.NET breakpoint at the current line.

;; Run the debugger.


(setenv "EMACS" "t")
(require 'saveplace)
(setq-default abbrev-mode t)
(read-abbrev-file "~/.abbrev_defs")
(setq save-abbrevs t)

(defun random-theme()
  (interactive)
  (dolist (theme custom-enabled-themes)
    (disable-theme theme))
  (load-theme (let ((theme (nth (random (length (custom-available-themes))) (custom-available-themes))))
                (message "loaded theme: %s" theme)
                theme)))

(unless (boundp 'bhj-no-random-theme)
  (condition-case nil
      (random-theme)
    (error nil)))




(defvar grep-func-call-history nil)


(defmacro set-remote-env (name val)
  `(let ((process-environment tramp-remote-process-environment))
     (setenv ,name ,val)
     (setq tramp-remote-process-environment process-environment)))

(defvar code-reading-file "~/.code-reading")

  ;; if it's on a `error' line, i.e. entry 0 in the following, it
  ;; means we are actually on 10th entry, we need go to entry 9

  ;; if we are on entry 1, then we need call `prev-error'.

    ;; 0 /usr/share/pyshared/html2text.py:270:                     if a:
    ;; 1     class _html2text(sgmllib.SGMLParser):
    ;; 2         ...
    ;; 3         def handle_tag(self, tag, attrs, start):
    ;; 4             ...
    ;; 5             if tag == "a":
    ;; 6                 ...
    ;; 7                 else:
    ;; 8                     if self.astack:
    ;; 9                         ...
    ;; 10 =>                      if a:

(defvar waw-mode-map nil
  "Keymap for where-are-we-mode.")

(put 'waw-mode 'mode-class 'special)

(defvar java-bt-mode-map nil
  "Keymap for java-bt-mode.")

(defvar java-bt-tag-alist nil
  "backtrace/code tag alist.")

(put 'java-bt-mode 'mode-class 'special)

(defvar boe-default-indent-col 0)
(make-variable-buffer-local 'boe-default-indent-col)

(define-key esc-map [(shift backspace)] 'back-to-indent-same-space-as-prev-line)




(when (eq system-type 'windows-nt)
  (setq file-name-coding-system 'gbk)
  (set-selection-coding-system 'gbk))

(require 'bbdb-autoloads)

(add-hook 'bbdb-canonicalize-net-hook
      'my-bbdb-canonicalize)


(when (eq system-type 'windows-nt)
  (setq nntp-authinfo-file "~/../.authinfo"
        auth-sources '((:source "~/../.authinfo" :host t :protocol t))))
(when nil
  (require 'twittering-mode)
  (twittering-enable-unread-status-notifier)
  (setq-default twittering-icon-mode t)
  (setq twittering-use-ssl nil
        twittering-oauth-use-ssl nil)
  (setq twittering-icon-mode 1)
  (setq twittering-enabled-services '(sina))
  (setq twittering-accounts '((sina (username "baohj_zj@hotmail.com")
                                    (auth oauth))))

  (setq twittering-initial-timeline-spec-string `(":home@sina")))


;; (unless (or (eq system-type 'windows-nt)
;;             (eq system-type 'darwin))
;;   (load-file "~/system-config/.emacs_d/lisp/my-erc-config.el"))


(define-key esc-map [(meta d)] 'bhj-do-dictionary)


(autoload 'mo-git-blame-file "mo-git-blame" nil t)
(autoload 'mo-git-blame-current "mo-git-blame" nil t)


(defadvice hack-dir-local-variables
  (around hack-remote-file-p first activate)
  "Hack (hack-dir-local-variables) to make it work with remote files."
  (require 'cl)
  (let ((saved-file-remote-p (symbol-function 'file-remote-p)))
    (flet ((file-remote-p (file &optional identification connected)
                          (cond
                           ((string-match "^/scp:" file) nil)
                           ((string-match "/smb/" file) t)
                           (t (funcall saved-file-remote-p file identification connected)))))
      ad-do-it)))

(require 'helm-config)
(helm-mode 1)

(define-key global-map [remap find-file] 'helm-find-files)
(define-key global-map [remap occur] 'helm-occur)
(define-key global-map [remap list-buffers] 'helm-buffers-list)
(define-key lisp-interaction-mode-map [remap completion-at-point] 'helm-lisp-completion-at-point)
(define-key emacs-lisp-mode-map       [remap completion-at-point] 'helm-lisp-completion-at-point)

(add-hook 'vc-git-log-view-mode-hook
          (lambda ()
            (when (string= log-view-message-re "^commit *\\([0-9a-z]+\\)")
              (setq log-view-message-re "^commit +\\([0-9a-z]+\\)"))))


(add-hook 'python-mode-hook
          (lambda ()
            (setq imenu-create-index-function #'ajoke--create-index-function))
          t)

(add-hook 'grep-mode-hook
          (lambda ()
            (setq compilation-directory-matcher (default-value 'compilation-directory-matcher))))

(load "bhj-setq.el")
(load "bhj-set-key.el")
(load "bhj-autoloads.el")
(load "bhj-eval-after-load.el")

(condition-case nil
    (server-start)
  (error (message "emacs server start failed")))
;;----------------------------------------------------------------------------
;; Variables configured via the interactive 'customize' interface
;;----------------------------------------------------------------------------
(setq custom-file (expand-file-name "custom.el" "~/etc/"))
(when (file-exists-p custom-file)
  (load custom-file))
