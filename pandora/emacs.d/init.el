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
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
  (package-initialize)) ; M-x list-packages
;; install xcscope, cedet, ecb
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defconst EPATH "~/.emacs.d")
(defconst IPATH (concat EPATH "/init.d"))
(defconst PPATH (concat IPATH "/plugins"))
;; (defconst TPATH (concat PPATH "/themes"))
(add-to-list 'load-path IPATH t)
(add-to-list 'load-path PPATH t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; emacs basic configuration
(require '000-emacs-basic-setting)

;; programming configuration
(require '101-xscope-setting)
;; (require '100-cedet-setting)


;; tex type, export pdf configuration
; no need if installed by ELPA
; (require '200-auctex-setting)

;; org-mode setting
(require '201-org-mode-setting) ; TODO: divide into html/pdf
(require '202-org-capture-setting)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(server-start)

(cond
  ((< emacs-major-version 22) setq custom-file "000-emacs-custom-21.el")
  ((and (= emacs-major-version 22) (< emacs-minor-version 3)) setq custom-file "000-emacs-custom-22.el")
  (t (setq custom-file "~/.emacs.d/init.d/000-emacs-custom.el"))
)
(load custom-file)

