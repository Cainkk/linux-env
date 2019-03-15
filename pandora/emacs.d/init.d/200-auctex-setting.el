;;http://www.gnu.org/software/auctex/download-for-windows.html
(provide '200-auctex-setting)
(add-to-list 'load-path "~/site-lisp/site-start.d")
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(if (string-equal system-type "windows-nt") (require 'tex-mik))

(setq Tex-auto-save t
      TeX-parse-self t) ;make files right away
(setq-default Tex-master nil)

;enable RefTeX?

