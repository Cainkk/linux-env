(provide '100-cedet-setting)

;;(setq byte-compile-warnings nil)
;;(setq stack-trace-on-error t) ; FIXME: compile error
;;CEDET config
;;*MUST READ*: cedet-1.1/{INSTALL,cedet-build.el}
;;*compile*: emacs -Q -l cedet-build.el -f cedet-build
;;TODO: add-to-list append
(add-to-list 'load-path (concat PPATH "cedet-1.1/common"))
(add-to-list 'load-path (concat PPATH "cedet-1.1/ede"))
(add-to-list 'load-path (concat PPATH "cedet-1.1/eieio"))
(add-to-list 'load-path (concat PPATH "cedet-1.1/semantic"))
(add-to-list 'load-path (concat PPATH "cedet-1.1/speedbar"))
(add-to-list 'load-path (concat PPATH "cedet-1.1/srecode"))
(add-to-list 'load-path (concat PPATH "cedet-1.1/cogre"))
;;NEED load cedet(.elc/el), if Emacs >= 23.2
(load (concat PPATH "cedet-1.1/common/cedet"))
(load-file (concat PPATH "cedet-1.1/eieio/eieio.el"))

(require 'eieio)
(require 'semantic)
;(require 'ede)
(require 'srecode)
(require 'cedet)
;(require 'cogre) ; FIXME: compile error

;; Enable EDE (Project Management) features
(global-ede-mode 1)
;; Enable prototype help and smart completion
(semantic-load-enable-minimum-features)
(semantic-load-enable-code-helpers)
(semantic-load-enable-guady-code-helpers)
(semantic-load-enable-excessive-code-helpers)
(semantic-load-enable-semantic-debugging-helpers)
;; Enable template insertion menu
;;(global-srecode-minor-mode 1)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;ECB: Emacs Code Browser
;;*MUST READ*: ecb-2.40/README
;;*compile*: M-x ecb-byte-compile
;;modified cedet-version-max in file ecb-upgrade.el.
(add-to-list 'load-path (concat PPATH "ecb-2.40") t)
;;(require 'ecb) ; FIXME: compile error
(setq ecb-source-path (quote (("d:/MDSS" "MDSS"))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Key bindings:

;;(setq ecb-auto-activate t ecb-tip-of-the-day nil)
(setq ecb-tip-of-the-day nil)
;; switch on/off ECB
(defun my-ecb-switch ()
(interactive)
(if ecb-minor-mode
(ecb-deactivate)
(ecb-activate)))
(global-set-key (kbd "<C-f1>") 'my-ecb-switch)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;ECB: Emacs Code Browser
;;*MUST READ*: ecb-2.40/README
;;*compile*: M-x ecb-byte-compile
;;modified cedet-version-max in file ecb-upgrade.el.
(add-to-list 'load-path (concat PPATH "ecb-2.40") t)
; (require 'ecb) ; FIXME: compile error
(setq ecb-source-path (quote (("d:/MDSS" "MDSS"))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Key bindings:

;;(setq ecb-auto-activate t ecb-tip-of-the-day nil)
(setq ecb-tip-of-the-day nil)
;; switch on/off ECB
(defun my-ecb-switch ()
(interactive)
(if ecb-minor-mode
(ecb-deactivate)
(ecb-activate)))
(global-set-key (kbd "<C-f1>") 'my-ecb-switch)

;;Easy windows move, Key-bindings: Alt + Arrow
(windmove-default-keybindings 'meta)
;;Add Key-bindings:
(global-set-key (kbd "C-S-j") 'windmove-down)
(global-set-key (kbd "C-S-k") 'windmove-up)
(global-set-key (kbd "C-S-h") 'windmove-left)
(global-set-key (kbd "C-S-l") 'windmove-right)
;;(windmove-default-keybindings 'super)
;;undo/redo windows if C-x 1
;;Key-bindings: C-c + left/right Arrow
;;(winner-mode t) ; cannot use in ECB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; distinguish (ecb-split-ver 0.3 t)
;; learn (other-window 1)
;; fraction between -0.9 and +0.9
(ecb-layout-define "add-cscope-layout" left nil
        (ecb-set-history-buffer)
        (ecb-split-ver 0.2)
        (ecb-set-methods-buffer)
        (select-window (previous-window))
        (ecb-split-hor 0.4)
        (ecb-set-directories-buffer)
        (select-window (next-window))
        (ecb-split-ver 0.8)
        (ecb-set-cscope-buffer)
        (select-window (next-window)))

(defecb-window-dedicator ecb-set-cscope-buffer
        "*ECB cscope-buf*" (switch-to-buffer "*cscope*"))

(setq ecb-layout-name "add-cscope-layout")

;; Disable buckets so that history buffer can display more entries
(setq ecb-history-make-buckets 'never)
