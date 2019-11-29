;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; N.B. emacs startup hang problem (connect VPN)!!
;; Solution: cmd(admin): net stop netlogon
;;
;; GNU Emacs FAQ for MS Windows
;; http://www.gnu.org/software/emacs/manual/html_mono/efaq-w32.html


;; set exec-path
;; (setenv "PATH" (concat "/usr/local/bin:/opt/local/bin" (getenv "PATH")))
;; (setq exec-path (append exec-path '("/usr/local/bin")))
;; (when (eq system-type 'window-nt) (setenv "PATH" (concat "\"c:/emacs/;\"" (getenv "PATH"))))

;;(cond
;; ((equal system-type 'ms-dos) (setq default-directory
;;    (concat (getenv "USERPROFILE") "/Desktop/")))
;; ((equal system-type 'windows-nt) (setq default-directory
;;    (concat (getenv "USERPROFILE") "/Desktop/")))
;; (t (setq default-directory "~"))) ; *nix
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(cond ((eq system-type 'windows-nt) (add-to-list 'exec-path "c:/wbin")))
(when (equal system-type 'windows-nt)
  ;(if (and (>= emacs-major-version 23) (>= emacs-minor-version 1))
  ;; (set-fontset-font "fontset-default" 'unicode "Courier New-14" nil 'prepend))
  (add-to-list 'default-frame-alist '(font . "Courier New-14"))
  (add-to-list 'initial-frame-alist '(font . "Courier New-14"))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; startup from scratch
;; Display the bare minimum at startup. We don't need all that noise. The
;; dashboard/empty scratch buffer is good enough.
(setq inhibit-splash-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message user-login-name
      inhibit-default-init t; open to verify it!!!
      initial-major-mode 'fundamental-mode
      initial-scratch-message nil)
(setq default-major-mode 'text-mode)
(fset #'display-startup-echo-area-message #'ignore)
;; Emacs "updates" its ui more often than it needs to, so we slow it down
;; slightly, from 0.5s:
(setq idle-update-delay 1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(blink-cursor-mode -1)
(transient-mark-mode 1)
(electric-indent-mode -1)
(electric-pair-mode -1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(prefer-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)
(set-language-environment 'UTF-8)
(set-locale-environment "UTF-8")
(setq system-time-locale "C")
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
;; (set-default buffer-file-coding-system 'prefer-utf-8-unix)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; (add-hook 'text-mode-hook 'turn-on-auto-fill)
(auto-fill-mode -1)
(fset 'yes-or-no-p 'y-or-n-p)
(global-hl-line-mode t) ; (require 'hl-line)
(global-font-lock-mode t)
(setq-default indicate-empty-lines t)
(when (not indicate-empty-lines) (toggle-indicate-empty-lines))
(show-paren-mode t) ; highlight brackets (){}[]...
(setq show-paren-style 'parenthesis)
(setq echo-keystrokes 0.1 use-dialog-box nil visible-bell t)
;; (setq default-fill-column 80) ; convenient Keys: C-x f
(setq scroll-margin 3 scroll-conservatively 10000) ; scrolling
(setq Man-notify-method 'pushy) ; jump to man buffer
(global-display-line-numbers-mode t); (when (version> "23" emacs-version)); fast
;(global-linum-mode t); (when (version< "23" emacs-version)); slow
(column-number-mode t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq large-file-warning-threshold (* 50 1000 1000))
;; Buffer settings
;(setq default-indicate-empty-lines t)
(setq require-final-newline t)
;(setq show-trailing-whitespace t)
(global-auto-revert-mode t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Optimizations
;; Disable bidirectional text rendering for a modest performance boost. Of
;; course, this renders Emacs unable to detect/display right-to-left languages
;; (sorry!), but for us left-to-right language speakers/writers, it's a boon.
(setq-default bidi-display-reordering 'left-to-right)

;; Reduce rendering/line scan work for Emacs by not rendering cursors or regions
;; in non-focused windows.
(setq-default cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)

;; More performant rapid scrolling over unfontified regions. May cause brief
;; spells of inaccurate fontification immediately after scrolling.
(setq fast-but-imprecise-scrolling t)

;; Resizing the Emacs frame can be a terribly expensive part of changing the
;; font. By inhibiting this, we halve startup times, particularly when we use
;; fonts that are larger than the system default (which would resize the frame).
(setq frame-inhibit-implied-resize t)

;; Don't ping things that look like domain names.
(setq ffap-machine-p-known 'reject)

;; Performance on Windows is considerably worse than elsewhere. We'll need
;; everything we can get.
(when IS-WINDOWS
  ;; Reduce the workload when doing file IO
  (setq w32-get-true-file-attributes nil)

  ;; Font compacting can be terribly expensive, especially for rendering icon
  ;; fonts on Windows. Whether it has a noteable affect on Linux and Mac hasn't
  ;; been determined.
  (setq inhibit-compacting-font-caches t))

;; Remove command line options that aren't relevant to our current OS; that
;; means less to process at startup.
(unless IS-MAC   (setq command-line-ns-option-alist nil))
(unless IS-LINUX (setq command-line-x-option-alist nil))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(put 'dired-find-alternate-file 'disabled nil)
(add-hook 'dired-mode-hook 'dired-hide-details-mode)
(add-hook 'dired-mode-hook (lambda () (define-key dired-mode-map (kbd "^")
  (lambda () (interactive) (find-alternate-file "..")))))
(add-hook 'dired-mode-hook 'diredfl-mode)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(pcase system-type
  ((pred (eq 'ms-dos))
    (setq default-directory
      (concat (getenv "USERPROFILE") "/Desktop/")))
  ((pred (eq 'windows-nt))
    (setq default-directory
      (concat (getenv "USERPROFILE") "/Desktop/")))
  ((pred (eq 'gnu/linux))
    (setq default-directory "~/")) ; *nix
  (_ (warn "not set default-directory for %s" system-type))) ; others
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; undo/redo window configuration: C-c left/right
;; (when (fboundp 'winner-mode) (winner-mode 1))
(setq display-time-format "%F %a %R")
(display-time) ; last display time
;;(setq display-time-24hr-format t)
;;(setq display-time-day-and-date t)
;;(setq display-time-interval 10)
;; modeline >>>>>>>
;; mouse <<<<<<<
(mouse-avoidance-mode 'exile)
;;(setq make-pointer-invisible t);default
;;(setq-default cursor-type 'bar)
;; mouse >>>>>>>
(setq make-backup-files nil)
;(add-hook 'find-file-hook (lambda() (read-only-mode)))
;; Gnus <<<<<<<
(setq gnus-inhibit-startup-message t)
;; Gnus >>>>>>>
; Maximum when emacs idle during startup
(run-with-idle-timer 0.0 nil 'w32-send-sys-command 61488)
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(add-hook 'c-mode-hook (lambda() (setq show-trailing-whitespace nil)))
; (add-hook 'c-mode-hook (lambda() (setq indent-tabs-mode nil)))
(global-set-key (kbd "C-x C-b") 'ibuffer)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; end from scratch
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; EmacsWiki
;;; https://www.emacswiki.org/emacs/SetFonts
;;; Globally Change the Default Font
;;; To change the default font for new (non special-display) frames,
;;; put either of these in your init file:
;;; 
;;; (add-to-list 'default-frame-alist '(font . FONT ))
;;; (set-face-attribute 'default t :font FONT )
;;; To change the default font for the current frame,
;;; as well as future frames, put either of these in your init file:
;;;
;;; (set-face-attribute 'default nil :font FONT )
;;; (set-frame-font FONT nil t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; M-x customize-face default will let you customize the default font.
;;; position your cursor to be over the offending text and type:
;;; M-x customize-face
;;; the face that your cursor is over will be the default one to customize.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; (defun set-font (english chinese english-size chinese-size)
;;;   (set-face-attribute 'default nil :font
;;;                       (format   "%s:pixelsize=%d"  english english-size))
;;;   (dolist (charset '(kana han symbol cjk-misc bopomofo))
;;;     (set-fontset-font (frame-parameter nil 'font) charset
;;;                       (font-spec :family chinese :size chinese-size))))
;;;
;;; (set-font   "Source Code Pro" "WenQuanYi Zen Hei Mono" 14 16)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (set-default-font "Courier New-14")) ; eally old,
;; and has been deprecated in Emacs 23,
;; in favor of its new name set-frame-font, which isn't much better
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; TODO: FONT Setting depend on system-type
;; GNU Emacs FAQ
;; M-x: (insert (prin1-to-string (x-list-fonts "*")))
;; M-S-: (font-family-list)
;; M-S-: (x-list-fonts "*")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TODO: mimic code below to add view-mode to find-file-literally
;; val-after-load "dired"
;; (progn
;;   (defadvice dired-advertised-find-file (around dired-subst-directory activate)
;;     "Replace current buffer if file is a directory."
;;     (interactive)
;;      (let* ((orig (current-buffer))
;;             ;; (filename (dired-get-filename))
;;             (filename (dired-get-filename t t))
;;            (bye-p (file-directory-p filename)))
;;       ad-do-it
;;       (when (and bye-p (not (string-match "[/\\\\]\\.$" filename)))
;;         (kill-buffer orig))))))
;; Ediff
(progn ; M-x ediff, ediff-buffers, epatch ...
  (setq ediff-window-setup-function 'ediff-setup-windows-plain) ; ediff-toggle-multiframe
  (setq ediff-split-window-function 'split-window-horizontally)
  ;;(setq ediff-diff-options "-u -N -r")
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package recentf
  :defer 1
  :commands recentf-open-files
  :config
  (setq recentf-save-file "~/.emacs.d/recentf"
        recentf-keep '(file-remote-p file-readablep); fast?
        recentf-filename-handlers '(file-truename)
        recentf-auto-cleanup 'never ;120
        recentf-max-menu-items 50
        recentf-max-menu-items 15))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package dired
  :commands dired-mode
  :bind (:map dired-mode-map ("C-o" . dired-omit-mode))
  :config
  (progn
    (setq dired-dwim-target t)
    (setq-default dired-omit-mode t)
    (setq-default dired-omit-files "^\\.?#\\|^\\.$\\|^\\.\\.$\\|^\\.")
    (define-key dired-mode-map "i" 'dired-subtree-insert)
    (define-key dired-mode-map ";" 'dired-subtree-remove)))
;; (use-package dired-subtree
;;   :ensure t
;;   :commands (dired-subtree-insert))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; (use-package org
;;;   :ensure t
;;;   :mode ("\\.org\\'" . org-mode)
;;;   :bind (("C-c l" . org-store-link)
;;;          ("C-c c" . org-capture)
;;;          ("C-c a" . org-agenda)
;;;          ("C-c b" . org-iswitchb)
;;;          ("C-c C-w" . org-refile)
;;;          ("C-c j" . org-clock-goto)
;;;          ("C-c C-x C-o" . org-clock-out))
;;;   :config
;;;   (progn
;;;     ;; The GTD part of this config is heavily inspired by
;;;     ;; https://emacs.cafe/emacs/orgmode/gtd/2017/06/30/orgmode-gtd.html
;;;     ;(setq org-directory "~/org")
;;;     ;(setq org-agenda-files
;;;     ;      (mapcar (lambda (path) (concat org-directory path))
;;;     ;              '("/org.org"
;;;     ;                "/gtd/gtd.org"
;;;     ;                "/gtd/inbox.org"
;;;     ;                "/gtd/tickler.org")))
;;;     (setq org-log-done 'time)
;;;     (setq org-src-fontify-natively t)
;;;     (setq org-use-speed-commands t)
;;;     ;(setq org-capture-templates
;;;     ;      '(("t" "Todo [inbox]" entry
;;;     ;         (file+headline "~/org/gtd/inbox.org" "Tasks")
;;;     ;         "* TODO %i%?")
;;;     ;        ("T" "Tickler" entry
;;;     ;         (file+headline "~/org/gtd/tickler.org" "Tickler")
;;;     ;         "* %i%? \n %^t")))
;;;     (setq org-refile-targets
;;;           '(("~/org/gtd/gtd.org" :maxlevel . 3)
;;;             ("~/org/gtd/someday.org" :level . 1)
;;;             ("~/org/gtd/tickler.org" :maxlevel . 2)))
;;;     (setq org-todo-keywords '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))
;;;     ;(setq org-agenda-custom-commands
;;;     ;      '(("@" "Contexts"
;;;     ;         ((tags-todo "@email"
;;;     ;                     ((org-agenda-overriding-header "Emails")))
;;;     ;          (tags-todo "@phone"
;;;     ;                     ((org-agenda-overriding-header "Phone")))))))
;;;     (setq org-clock-persist t)
;;;     (org-clock-persistence-insinuate)
;;;     (setq org-time-clocksum-format '(:hours "%d" :require-hours t :minutes ":%02d" :require-minutes t))))
;;; (use-package org-inlinetask
;;;   :bind (:map org-mode-map
;;;               ("C-c C-x t" . org-inlinetask-insert-task))
;;;   :after (org)
;;;   :commands (org-inlinetask-insert-task))
;;; (use-package org-bullets
;;;   :ensure t
;;;   :commands (org-bullets-mode)
;;;   :init (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package org
  :bind (:map org-mode-map
         ("RET" . org-return-indent)
         ("M-p" . outline-previous-visible-heading)
         ("M-n" . outline-next-visible-heading)
         ("s-t" . org-todo)
         ("M-[" . org-metaleft)
         ("M-]" . org-metaright))
  :straight org-plus-contrib
  :mode ("\\.org$" . org-mode)
  :init
  (setq org-special-ctrl-a/e t)
  (setq org-return-follows-link t)

  (setq org-export-dispatch-use-expert-ui t)

  (setq org-latex-create-formula-image-program 'imagemagick)
  (setq org-latex-listings 'minted)
  (setq org-tags-column -80)

  (setq org-enforce-todo-dependencies t)
  (setq org-enforce-todo-checkbox-dependencies  t)

  (setq org-pretty-entities t)
  (setq org-src-fontify-natively t)
  (setq org-list-allow-alphabetical t)

  (setq org-deadline-warning-days 7)

  (setq org-agenda-custom-commands
        '(("s" "Schoolwork"
           ((agenda "" ((org-agenda-ndays 14)
                        (org-agenda-start-on-weekday nil)
                        (org-agenda-prefix-format " %-12:c%?-12t% s")))
            (tags-todo "CATEGORY=\"Schoolwork\""
                       ((org-agenda-prefix-format "%b")))))

          ("r" "Reading"
           ((tags-todo "CATEGORY=\"Reading\""
                       ((org-agenda-prefix-format "%:T ")))))
          ("m" "Movies"
           ((tags-todo "CATEGORY=\"Movies\""
                       ((org-agenda-prefix-format "%:T ")))))))
    (setq
     org-latex-pdf-process (list "latexmk -shell-escape -pdf %f")

    org-entities-user
    '(("supsetneqq" "\\supsetneqq" t "" "[superset of above not equal to]"
       "[superset of above not equal to]" "⫌")
      ("subseteq" "\\subseteq" t "" "[subset of above equal to]" "subset of above equal to" "⊆")
       ("subsetneqq" "\\subsetneqq" t "" "[suberset of above not equal to]"
         "[suberset of above not equal to]" "⫋")))

  :config
  (setq org-agenda-files '("~/agenda/"))
  (plist-put org-format-latex-options :scale 1.5)

  (setq org-latex-packages-alist
    '(("" "minted") ("usenames,dvipsnames,svgnames" "xcolor")))

  (defun my-org-autodone (n-done n-not-done)
    "Switch entry to DONE when all subentries are done, to TODO otherwise."
    (let (org-log-done org-log-states)   ; turn off logging
      (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

  (add-hook 'org-after-todo-statistics-hook 'my-org-autodone)

  (org-babel-do-load-languages
    'org-babel-load-languages
    '((emacs-lisp . t)
       (latex     . t)
       (python    . t)
       ;; FIXME: Make this contingent on ob-ipython
       ;; (ipython   . t)
       (R         . t)
       (octave    . t)
       (matlab    . t)
       (shell     . t)))

  (setq org-confirm-babel-evaluate nil)
  (setq org-export-use-babel t)

  (setq org-latex-minted-options
    '(("linenos" "true")
       ("fontsize" "\\scriptsize")
       ("frame" "lines")))

  (setq org-export-latex-hyperref-format "\\ref{%s}")

  (setq
    org-src-window-setup 'current-window
    org-agenda-window-setup 'current-window)

  (setq org-blank-before-new-entry
    '((heading . true)
       (plain-list-item . auto)))

  ;; FIXME: parameter-ize dir `agenda'
  (setq org-default-notes-file "~/agenda/notes.org")

  (setq org-capture-templates
        `(("r" "Reading" entry (file "~/proj/lists/read.org")
           "* TODO %?\n  Entered on %U\n  %i")
          ("t" "Task" entry (file "")
           "* TODO %?\n %i")))

  (setq org-refile-targets '((nil . (:maxlevel . 10))))

  (setq org-export-with-smart-quotes t)
  (with-eval-after-load 'ace-link
    ;; (bind-keys :map org-agenda-mode-map
    ;;            ("M-o" . ace-link-org))
    (bind-keys :map org-mode-map
               ("M-o" . ace-link-org))))

(use-package ox-latex
  :after org)

(use-package ox-bibtex
  :after org)

(use-package ox-md
  :after org)

(use-package ob-python
  :after org
  :init
  (setq org-babel-python-command "python3"))

(use-package toc-org
  :disabled t
  :after org
  :config
  (add-hook 'org-mode-hook 'toc-org-enable))

(use-package evil-org
  :straight t
  :after (evil org)
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (evil-org-set-key-theme)
  (setq evil-org-special-o/O '(table-row)))

(use-package org-tempo
  :after org)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package pdf-tools
  :straight t
  :mode ("\\.pdf$" . pdf-view-mode)
  :config
  (pdf-tools-install)

  (let ((foreground-orig (car pdf-view-midnight-colors)))
    (setq pdf-view-midnight-colors
          (cons "white" "black")))

  (with-eval-after-load 'evil
      (progn
        (add-to-list 'evil-emacs-state-modes 'pdf-outline-buffer-mode)
        (add-to-list 'evil-emacs-state-modes 'pdf-view-mode))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package tex
  :ensure auctex
  :mode ("\\.tex\\'" . LaTeX-mode)
  :config
  (setq TeX-view-program-list
        '(("zathura"
           ("zathura" (mode-io-correlate "-sync.sh")
            " "
            (mode-io-correlate "%n:1:%b ")
            "%o"))))
  (setq TeX-view-program-selection '((output-pdf "zathura")))
  (setq TeX-PDF-mode t)
  (TeX-source-correlate-mode))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; need only color-theme.el, and themes under same directory
;; (progn ; M-x list-colors-display
;;   (require 'color-theme)
;;     (eval-after-load "color-theme"
;;       '(progn (color-theme-initialize)
;;               (color-theme-tomorrow-night-eighties))))
;; (require 'color-theme-sanityinc-tomorrow)
;; (color-theme-sanityinc-tomorrow-define-theme eighties)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(use-package doom-themes
;  :init
;  (setq doom-themes-enable-bold t
;        doom-themes-enable-italic t)
;  :config
;  (load-theme 'doom-one t)
;  (with-eval-after-load 'treemacs
;    (doom-themes-treemacs-config))
;  (doom-themes-visual-bell-config)
;  (with-eval-after-load 'org
;    (doom-themes-org-config)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package spacemacs-theme
  :defer t
  :init
  (load-theme 'spacemacs-dark t))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'telephone-line)
;; Cubed, set before (telephone-line mode 1)
(setq telephone-line-primary-left-separator 'telephone-line-cubed-left
      telephone-line-secondary-left-separator 'telephone-line-cubed-hollow-left
      telephone-line-primary-right-separator 'telephone-line-cubed-right
      telephone-line-secondary-right-separator 'telephone-line-cubed-hollow-right)
(setq telephone-line-height 24
      telephone-line-evil-use-short-tag t)
(telephone-line-mode 1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(beacon-mode 1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package which-key
  :ensure t
  :diminish which-key-mode
  :config
    (which-key-mode))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(require 'ido-vertical-mode)
;(setq ido-enable-flex-matching t)
;(ido-mode 1); (ido-mode -1)
;(ido-vertical-mode 1)
;(global-set-key (kbd "M-X") 'smex)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package rainbow-delimiters
  :defer 1
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package ivy
  :ensure t
  :config
  (ivy-mode 1)
  (setq ivy-dynamic-exhibit-delay-ms 200)
  (setq ivy-format-function 'ivy-format-function-arrow)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  ;(global-set-key (kbd "C-c C-r") 'ivy-resume)
  ;(global-set-key (kbd "<f6>") 'ivy-resume)
  (require 'ivy-rich)
  )
(use-package counsel
  :ensure t
  :config
  (counsel-mode 1))
(use-package swiper
  :ensure t
  :config
  (setq swiper-use-visual-line nil)
  (setq swiper-use-visual-line-p (lambda (a) nil)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; too slow
;(require 'helm)
;(require 'helm-config)
;(global-set-key (kbd "M-x") 'helm-M-x)
;(global-set-key (kbd "C-x r b") 'helm-filtered-bookmarks)
;(global-set-key (kbd "C-x C-f") 'helm-find-files)
;(helm-autoresize-mode t)
;(setq helm-autoresize-max-height 13)
;(setq helm-autoresize-min-height 13)
;;(set-face-attribute 'helm-selection nil 
;;                    :background "green"
;;                    :foreground "black")
;(helm-mode 1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; eshell setup
;; (add-hook 'eshell-mode-hook
;;   (lambda ()
;;   (local-set-key (kbd "C-j") 'switch-to-buffer)
;;   (local-set-key (kbd "C-a") 'eshell-bol)
;;   (local-set-key (kbd "C-c SPC") 'ace-jump-mode)
;;   (local-set-key (kbd "<up>") 'eshell-previous-matching-input-from-input)
;;   (local-set-key (kbd "<down>") 'eshell-next-matching-input-from-input)))
;; (setq eshell-save-history-on-exit t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; http://ftp.gnu.org/gnu/emacs/windows/README
;; C-h v dynamic-library-alist ; search obey this alist
;; check image-format support: gif jpeg tiff xbm xpm
;; M-: (image-type-available-p 'png); jpg and so on.
;; M-: image-library-alist RET ; obsolete

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (progn ; mail
;;   ;; Outgoing mail
;;   (setq user-full-name "kk"
;;         user-mail-address "junyidcf@126.com"
;;         smtpmail-default-smtp-server "smtp.126.com" ; runtime (smtpmail-smtp-server)
;;         send-mail-command 'smtpmail-send-it ; For mail-mode (Rmail)
;;         message-send-mail-function 'smtpmail-send-it ; For message-mode (Gnus)
;;   )
;;
;;   ;;Incoming mail with Rmail&POP3
;;   (setenv "MAILHOST" "pop3.163.com");domain.name.of.pop3.server
;;   (setq rmail-primary-inbox-list '("po:junyidcf")
;;         rmail-pop-password-required t)
;;
;;   ;;Incoming mail with Gnus, support IMAP
;; )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(progn ; Gnus
  (setq gnus-init-file "~/.emacs.d/gnus.el"
        gnus-startup-file "~/.emacs.d/newsrc"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Private defun
(defun Tab (spaces)
  "turn tabs into spaces only"
  (interactive "NN spaces: ")
  (if (equal nil spaces)
    (setq c-basic-offset spaces
          ; tab-always-indent t ; tweak TAB command(indent-for-tab-command)
          ; M-x tabify; M-x untabify
          indent-tabs-mode nil ; only spaces if nil
          tab-width spaces ; affects tab-stop-list
          ; M-x edit-tab-stops
          tab-stop-list nil)
    (progn ; initial tab setting
      (setq c-basic-offset 8
            indent-tabs-mode t
            ;default-tab-width 8
            tab-width 8))))
;; default tab setting: unextended 8-tabs
(Tab nil)

(provide '000-emacs-basic-setting)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Tips
;; Minor mode <<<<<<<
; M-x auto-fill-mode
; M-x overwrite-mode
;; Minor mode >>>>>>>

;; C-x = (what-cursor-position) Display the character code of character after point
;; C-x z (repeat) repeats the previous Emacs command

;; GNU lisp coding style

;; M-x auto-revert-mode ; reload file
