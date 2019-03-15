;; set org-capture
(provide '202-org-capture-setting)

;; just type M-x org-capture
;; (define-key global-map "\C-cc" 'org-capture)

;; import old org-remember templates:
;; M-x org-capture-import-remember-templates RET

;; change notes location, by default: ~/.notes
;; (setq org-default-notes-file (concat org-directory "/notes.org"))

;; Usage M-x org-capture RET keys
;; Finish: C-c C-c

;; start from scratch
(setq org-capture-templates nil)

;; Q: How to set capture templates
;; A: org-capture-templates: keys description type target template properties

;;; group templates
;;(add-to-list 'org-capture-templates '("t" "Tasks"))
;;(add-to-list 'org-capture-templates
;;             '("tw" "work task" entry (file+headline "~/org.d/org-capture/task-work.org" "Work")
;;             "* TODO %^{task name}\n%u\n%a\n" :clock-in t :clock-resume t ))
;;(add-to-list 'org-capture-templates
;;             '("tr" "Book Reading Task" entry
;;               (file+olp "~/Dropbox/org/task.org" "Reading" "Book")
;;               "* TODO %^{book-name}\n%u\n%a\n" :clock-in t :clock-resume t))


;; task group templates
(add-to-list 'org-capture-templates '("t" "Tasks"))
(add-to-list 'org-capture-templates
             '("tw" "work task" entry (file+headline "~/org.d/org-capture/tasks.org" "WORK")
               "** TODO %^{task name|hdshelf|carp|prbs|serdes}\n   %?\n%U\n" :empty-lines 1))
(add-to-list 'org-capture-templates
             '("th" "home task" entry (file+headline "~/org.d/org-capture/tasks.org" "HOME" )
               "** TODO %^{task name}%?\n   %?%U\n" :empty-lines 1))

;; Journey
(add-to-list 'org-capture-templates
             '("j" "journey" entry (file+olp+datetree "~/org.d/org-capture/journey.org")
              "* %U %?\n" :empty-lines 1))
