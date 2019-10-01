;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; N.B. emacs startup hang problem (connect VPN)!!
;; Solution: cmd(admin): net stop netlogon
;;
;; GNU Emacs FAQ for MS Windows
;; http://www.gnu.org/software/emacs/manual/html_mono/efaq-w32.html
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; set exec-path
;; (setenv "PATH" (concat "/usr/local/bin:/opt/local/bin" (getenv "PATH")))
;; (setq exec-path (append exec-path '("/usr/local/bin")))
;; (when (eq system-type 'window-nt) (setenv "PATH" (concat "\"c:/emacs/;\"" (getenv "PATH"))))

;;{{{ recentf customization
(require 'recentf)
(setq recentf-auto-cleanup 'never) ;; disable before we start recentf
(recentf-mode 1)
;(setq recentf-save-file "d:/tmp/.recentf")
;(setq recentf-menu-title "Recent Files")
;; Set the maximum number of items saved
(setq recentf-max-saved-items 34)
;; Set the max items on the menu
(setq recentf-max-menu-items 15)
;; M-x recentf-open-files
;;}}}

(pcase system-type
  ((pred (equal 'ms-dos))
    (setq default-directory
      (concat (getenv "USERPROFILE") "/Desktop/")))
  ((pred (equal 'windows-nt))
    (setq default-directory
      (concat (getenv "USERPROFILE") "/Desktop/")))
  ((pred (equal 'gnu/linux))
    (setq default-directory "~/")) ; *nix
  (_ (warn "not set default-directory for %s" system-type))) ; others


;;(cond
;; ((equal system-type 'ms-dos) (setq default-directory
;;    (concat (getenv "USERPROFILE") "/Desktop/")))
;; ((equal system-type 'windows-nt) (setq default-directory
;;    (concat (getenv "USERPROFILE") "/Desktop/")))
;; (t (setq default-directory "~"))) ; *nix

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
            ; default-tab-width 8 ; obsolete
            tab-width 8))))
;; default tab setting: unextended 8-tabs
(Tab nil)

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
(when (equal system-type 'windows-nt)
  ;(if (and (>= emacs-major-version 23) (>= emacs-minor-version 1))
  ;; (set-fontset-font "fontset-default" 'unicode "Courier New-14" nil 'prepend))
  (add-to-list 'default-frame-alist '(font . "Courier New-14"))
  (add-to-list 'initial-frame-alist '(font . "Courier New-14"))
  )

(when  (equal system-type 'gnu/linux) ; on ubuntu
  (add-to-list 'default-frame-alist '(font . "Monospace-12"))
  (add-to-list 'initial-frame-alist '(font . "Monospace-12"))
  )
;; (_ (warn "not set-default-font for %s" system-type))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(progn ; startup from scratch
  (setq inhibit-splash-screen t initial-scratch-message nil)
  (setq frame-title-format "%f")
  (set-default-coding-systems 'utf-8-unix)
  (prefer-coding-system 'utf-8-unix)
  (set-language-environment 'UTF-8)
  (set-locale-environment "UTF-8")
  (setq system-time-locale "C")
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  ; (set-default buffer-file-coding-system 'prefer-utf-8-unix)
  (menu-bar-mode 0)
  (tool-bar-mode 0)
  (scroll-bar-mode 0)
  (blink-cursor-mode -1)
  (transient-mark-mode 1) ; highlight region
  (electric-indent-mode -1) ; ugly when RET
  (electric-pair-mode -1) ; ugly if enable
  (setq inhibit-startup-message t initial-scratch-message "")
  (auto-fill-mode -1)
  ;; (add-hook 'text-mode-hook 'turn-on-auto-fill)
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
  ;; modeline <<<<<<<
  (global-linum-mode t)
  (column-number-mode t)
  ; undo/redo window configuration: C-c left/right
  (when (fboundp 'winner-mode) (winner-mode 1))
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
  (add-hook 'find-file-hook (lambda() (read-only-mode)))
  ;; Gnus <<<<<<<
  (setq gnus-inhibit-startup-message t)
  ;; Gnus >>>>>>>
  ; Maximum when emacs idle during startup
  (run-with-idle-timer 0.0 nil 'w32-send-sys-command 61488)
  (add-to-list 'default-frame-alist '(fullscreen . maximized))
  (add-hook 'c-mode-hook (lambda() (setq show-trailing-whitespace nil)))
  ; (add-hook 'c-mode-hook (lambda() (setq indent-tabs-mode nil)))
)

;; Ediff
(progn ; M-x ediff, ediff-buffers, epatch ...
  (setq ediff-window-setup-function 'ediff-setup-windows-plain) ; ediff-toggle-multiframe
  (setq ediff-split-window-function 'split-window-horizontally)
  ;;(setq ediff-diff-options "-u -N -r")
)

;; need only color-theme.el, and themes under same directory
;; (progn ; M-x list-colors-display
;;   (require 'color-theme)
;;     (eval-after-load "color-theme"
;;       '(progn (color-theme-initialize) (color-theme-tomorrow-night-eighties)))
;;   (set-foreground-color "#AAAAAA")
;;   (set-background-color "#2E3436") ; #2E3436 ;solarized: #002B36
;;   (set-face-foreground 'linum "goldenrod")
;;   (set-face-background 'hl-line "#3D3D3D") ; #3D3D3D ;solarized: #073642
;;   (set-face-foreground 'mode-line "yellow")
;;   (set-face-background 'mode-line "navy")
;;   (set-face-foreground 'mode-line-inactive "black")
;;   (set-face-background 'mode-line-inactive "white")
;;   (set-face-background 'mode-line-buffer-id "DarkGreen"))

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

(provide '000-emacs-basic-setting)

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
