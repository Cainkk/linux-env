(provide '001-emacs-mail-setting)

(setq smtpmail-smtp-server 'smtp.163.com')
(setq send-mail-function 'smtpmail-send-it)
(setq message-send-mail-function 'smtpmail-send-it)
(setq smtpmail-smtp-service 25)
(setq smtpmail-auth-credencials
      list (smtpmail-mail-server
	    smtpmail-mail-service
	    'junyidcf'
	    'passwd'))
(require 'smtpmail)

(setq rmail-primary-inbox-list 'POP3//:junyidcf:passwd')
