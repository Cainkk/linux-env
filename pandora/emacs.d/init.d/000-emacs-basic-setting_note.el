;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; N.B. emacs startup hang problem (connect VPN)!!
;; Solution: cmd(admin): net stop netlogon
;;
;; GNU Emacs FAQ for MS Windows
;; http://www.gnu.org/software/emacs/manual/html_mono/efaq-w32.html
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;;pcase system-type
;; ((pred (eq "ms-dos"))
;;   (setq default-directory
;;     (concat (getenv "USERPROFILE") "/Desktop")))
;; ((pred (eq "windows-nt"))
;;   (setq default-directory
;;     (concat (getenv "USERPROFILE") "/Desktop")))
;; (_ (setq default-directory "~"))) ; *nix

;; set default-directory
;; M-x pwd
;; M-x cd
(progn
  (cond
    ((eq system-type 'ms-dos) (setq default-directory
       (concat (getenv "USERPROFILE") "/Desktop")))
    ((eq system-type 'windows-nt) (setq default-directory
       (concat (getenv "USERPROFILE") "/Desktop")))
    (t (setq default-directory "~")))) ; *nix

(defun Tab (spaces)
  "switch tabs into spaces"
  (interactive "How many spaces: ")
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
            default-tab-width 8
            tab-width 8))))
;; default tab setting: unextended 8-tabs
(Tab nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TODO: FONT Setting depend on system-type
;; X Window System tools: legacy xlsfonts, modern fontconfig
;; GNU Emacs FAQ
;; M-x: (insert (prin1-to-string (x-list-fonts "*")))
(when (eq system-type 'windows-nt)
  (set-default-font "Courier New-12"))
;;(set-fontset-font "fontset-default"
;;  'unicode
;;  '("WenQuanYi Zen Hei" . "unicode-ttf"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(progn ; startup from scratch
  (setq frame-title-format "%b@%f")
  (set-default-coding-systems 'utf-8-unix)
  (prefer-coding-system 'utf-8-unix)
  (set-language-environment 'UTF-8)
  (set-locale-environment "UTF-8")
  (setq system-time-locale "C")
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  ; (set-default buffer-file-coding-system 'prefer-utf-8-unix)
  (menu-bar-mode 0) ; undisplay menu bar
  (tool-bar-mode 0) ; undisplay tool bar
  (scroll-bar-mode 0) ; undisplay scroll bar
  (blink-cursor-mode -1) ; unblink cursor
  (transient-mark-mode 1) ; highlight region
  (electric-indent-mode -1) ; ugly when Return
  (electric-pair-mode -1) ; ugly if enable
  (setq inhibit-startup-message t initial-scratch-message "")
  (setq default-major-mode 'text-mode)
  (add-hook 'text-mode-hook 'turn-on-auto-fill)
  (setq visible-bell t) ; forbid voice
  (fset 'yes-or-no-p 'y-or-n-p)
  (global-hl-line-mode t) ; minor mode ; (require 'hl-line)
  (global-font-lock-mode t) ; minor mode
  (show-paren-mode t) ; highlight brackets (){}[]...
  (setq show-paren-style 'parenthesis)
  ; (setq default-fill-column 80) ; convenient Keys: C-x f
  (setq scroll-margin 3 scroll-conservatively 10000) ; scrolling
  (setq Man-notify-method 'pushy) ; jump to man buffer
  ;; modeline {{{
  (global-linum-mode t) ; show line-number in modeline
  (column-number-mode t) ; show column-number in modeline
  (setq display-time-format "%F %a %R") ; show time in modeline
  (display-time) ; last display time
  ;;(setq display-time-24hr-format t)
  ;;(setq display-time-day-and-date t)
  ;;(setq display-time-interval 10)
  ;; modeline }}}
  ;; mouse {{{
  (mouse-avoidance-mode 'exile)
  ;;(setq make-pointer-invisible t);default
  ;;(setq-default cursor-type 'bar)
  ;; mouse }}}
  (run-with-idle-timer 0.0 nil 'w32-send-sys-command 61488);For what?
  (setq make-backup-files nil)
  ;; Gnus {{{
  (setq gnus-inhibit-startup-message t)
  ;; Gnus }}}
)

;;; TODO: try default color theme
;; need only color-theme.el, and themes under same directory
(progn ; M-x list-colors-display
  (require 'color-theme)
    (eval-after-load "color-theme"
      '(progn (color-theme-initialize) (color-theme-tomorrow-night-eighties)))
  (set-foreground-color "#AAAAAA")
  (set-background-color "#2E3436") ; #2E3436 ;solarized: #002B36
  (set-face-foreground 'linum "goldenrod")
  (set-face-background 'hl-line "#3D3D3D") ; #3D3D3D ;solarized: #073642
  (set-face-foreground 'mode-line "yellow")
  (set-face-background 'mode-line "navy")
  (set-face-foreground 'mode-line-inactive "black")
  (set-face-background 'mode-line-inactive "white")
  (set-face-background 'mode-line-buffer-id "DarkGreen"))

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

;; Tips
;; Minor mode <<<<<<<
; M-x auto-fill-mode
; M-x overwrite-mode
; M-x follow-mode
; C-x n n ; C-x n w ; narrowing and widening
;; Minor mode >>>>>>>

;; C-x = (what-cursor-position) Display the character code of character after point
;; C-x z (repeat) repeats the previous Emacs command

;; GNU lisp coding style
(provide '000-emacs-basic-setting)

