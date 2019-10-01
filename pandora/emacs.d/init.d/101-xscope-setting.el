(provide '101-xscope-setting)

;; Windows emacs+cscope:
;; Q: cscope -bk ## not support -q option, why?
;; A: NEED windows version sort tool!
;; recursively search cscope.out upwards in directory,
;; unless need to put cscope.out elsewhere,
;; refers to cscope-database-regexps;
;; STEPS:
;; > for /F %i in ('pwd') do find %i -name *.[chsS] -print >cscope.files
;; > cscope -qbk
(add-hook 'c-mode-common-hook
  '(lambda () (require 'xcscope)
    (setq cscope-do-not-update-database t)))

;; part of the results may be invisible
;; (setq cscope-use-face nil)
;; cscope-file-face
;; cscope-function-face
;; cscope-line-number-face
;; cscope-line-face
;; cscope-mouse-face
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cscope: Find symbol key binding:
;; (define-key global-map (kbd "C-c s d") 'cscope-find-called-functions)
;; (define-key global-map (kbd "C-c s W") 'cscope-tell-user-about-directory)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
