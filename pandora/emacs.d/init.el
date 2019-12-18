;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; N.B. FIRST OFF on Windows:
;; RUN addpm.exe
;; reg add HKCU\Software\GNU\Emacs /t reg_sz /v HOME /d "c:\emacs"
;;
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;; Add package installation URL over Internet
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;  Adjust garbage collection thresholds during startup, and thereafter
(setq gc-cons-threshold most-positive-fixnum)
;;  If you experience freezing, decrease this.
;;  If you experience stuttering, increase this.
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 32 1024 1024))))
;; Emacs "updates" its ui more often than it needs to, so we slow it down
;; slightly, from 0.5s:
(setq idle-update-delay 1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(when (>= emacs-major-version 24)
; tips: (when (version< emacs-version "26.1")
  (require 'package)
  (setq package-enable-at-startup nil)
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
  (package-initialize)) ; M-x list-packages

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(require 'init-benchmarking) ;; Measure startup time

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defconst EMACS-EPATH (eval-when-compile (file-truename user-emacs-directory)))
(defconst EMACS-IPATH (eval-when-compile (concat EMACS-EPATH "/init.d")))
(defconst EMACS-PPATH (eval-when-compile (concat EMACS-IPATH "/plugins")))

;; (defconst EMACS-EPATH "~/.emacs.d")
;; (defconst EMACS-IPATH (concat EMACS-EPATH "/init.d"))
;; (defconst EMACS-PPATH (concat EMACS-IPATH "/plugins"))
;; (defconst EMACS-TPATH (concat EMACS-PPATH "/themes"))
(add-to-list 'load-path EMACS-IPATH t)
(add-to-list 'load-path EMACS-PPATH t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defconst IS-EMACS27+ (> emacs-major-version 26))
(defconst IS-MAC     (eq system-type 'darwin))
(defconst IS-LINUX   (eq system-type 'gnu/linux))
(defconst IS-WINDOWS (memq system-type '(cygwin windows-nt ms-dos)))
(defconst IS-BSD     (or IS-MAC (eq system-type 'berkeley-unix)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(when IS-WINDOWS
     (setq url-proxy-services
       '(("no_proxy" . "^\\(localhost\\|10.*\\)")
         ;("http" . "proxy:8080") ; proxy
         ;("https" . "proxy:8080") ; proxy
        )))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; from doom-emacs
;; This is consulted on every `require', `load' and various path/io functions.
;; You get a minor speed up by nooping this.
(setq file-name-handler-alist nil)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;;; Requires

(eval-when-compile
  (require 'use-package)
  ; (setq use-package-always-ensure t) ;; alway ensure packages are installed
  (setq use-package-verbose t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; emacs basic configuration
(require '000-emacs-basic-setting)

;(require '000-emacs-hydra-keymap)

;; programming configuration
;; (require '100-cedet-setting)
;; (require '101-xscope-setting)

;; tex type, export pdf configuration
; no need if installed by ELPA
; (require '200-auctex-setting)

;; org-mode setting
;(require '201-org-mode-setting) ; TODO: divide into html/pdf
;(require '202-org-capture-setting)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(cond
  ((< emacs-major-version 22) (setq custom-file "000-emacs-custom-21.el"))
  ((and (= emacs-major-version 22) (< emacs-minor-version 3)) (setq custom-file "000-emacs-custom-22.el"))
  (t (setq custom-file "~/.emacs.d/init.d/000-emacs-custom.el"))
)
(when (file-exists-p custom-file) (load custom-file))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; When Emacs loses focus seems like a great time to do some garbage collection
;; all sneaky breeky like, so we can return to a fresh(er) Emacs.
(add-hook 'focus-out-hook #'garbage-collect)
;; Allow access from emacsclient
(add-hook 'after-init-hook
          (lambda ()
            (require 'server)
            (unless (server-running-p)
              (server-start))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

