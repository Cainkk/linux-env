(require 'hydra)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'which-key)
(which-key-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Emacs basic hydra
(global-set-key
 (kbd "C-n")
 (defhydra hydra-move
   (:body-pre (forward-line))
   "move"
   ("n" forward-line); next-line
   ("p" previous-line)
   ("f" forward-char)
   ("b" backward-char)
   ("a" beginning-of-line)
   ("e" move-end-of-line)
   ("v" scroll-up-command)
   ;; Converting M-v to V here by analogy.
   ("V" scroll-down-command)
   ("l" recenter-top-bottom)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ibuffer
(defhydra hydra-ibuffer-main (:color pink :hint nil)
  "
 ^Navigation^ | ^Mark^        | ^Actions^        | ^View^
-^----------^-+-^----^--------+-^-------^--------+-^----^-------
  _k_:    ʌ   | _m_: mark     | _D_: delete      | _g_: refresh
 _RET_: visit | _u_: unmark   | _S_: save        | _s_: sort
  _j_:    v   | _*_: specific | _a_: all actions | _/_: filter
-^----------^-+-^----^--------+-^-------^--------+-^----^-------
"
  ("j" ibuffer-forward-line)
  ("RET" ibuffer-visit-buffer :color blue)
  ("k" ibuffer-backward-line)

  ("m" ibuffer-mark-forward)
  ("u" ibuffer-unmark-forward)
  ("*" hydra-ibuffer-mark/body :color blue)

  ("D" ibuffer-do-delete)
  ("S" ibuffer-do-save)
  ("a" hydra-ibuffer-action/body :color blue)

  ("g" ibuffer-update)
  ("s" hydra-ibuffer-sort/body :color blue)
  ("/" hydra-ibuffer-filter/body :color blue)

  ("o" ibuffer-visit-buffer-other-window "other window" :color blue)
  ("q" quit-window "quit ibuffer" :color blue)
  ("." nil "toggle hydra" :color blue))

(defhydra hydra-ibuffer-mark (:color teal :columns 5
                              :after-exit (hydra-ibuffer-main/body))
  "Mark"
  ("*" ibuffer-unmark-all "unmark all")
  ("M" ibuffer-mark-by-mode "mode")
  ("m" ibuffer-mark-modified-buffers "modified")
  ("u" ibuffer-mark-unsaved-buffers "unsaved")
  ("s" ibuffer-mark-special-buffers "special")
  ("r" ibuffer-mark-read-only-buffers "read-only")
  ("/" ibuffer-mark-dired-buffers "dired")
  ("e" ibuffer-mark-dissociated-buffers "dissociated")
  ("h" ibuffer-mark-help-buffers "help")
  ("z" ibuffer-mark-compressed-file-buffers "compressed")
  ("b" hydra-ibuffer-main/body "back" :color blue))

(defhydra hydra-ibuffer-action (:color teal :columns 4
                                :after-exit
                                (if (eq major-mode 'ibuffer-mode)
                                    (hydra-ibuffer-main/body)))
  "Action"
  ("A" ibuffer-do-view "view")
  ("E" ibuffer-do-eval "eval")
  ("F" ibuffer-do-shell-command-file "shell-command-file")
  ("I" ibuffer-do-query-replace-regexp "query-replace-regexp")
  ("H" ibuffer-do-view-other-frame "view-other-frame")
  ("N" ibuffer-do-shell-command-pipe-replace "shell-cmd-pipe-replace")
  ("M" ibuffer-do-toggle-modified "toggle-modified")
  ("O" ibuffer-do-occur "occur")
  ("P" ibuffer-do-print "print")
  ("Q" ibuffer-do-query-replace "query-replace")
  ("R" ibuffer-do-rename-uniquely "rename-uniquely")
  ("T" ibuffer-do-toggle-read-only "toggle-read-only")
  ("U" ibuffer-do-replace-regexp "replace-regexp")
  ("V" ibuffer-do-revert "revert")
  ("W" ibuffer-do-view-and-eval "view-and-eval")
  ("X" ibuffer-do-shell-command-pipe "shell-command-pipe")
  ("b" nil "back"))

(defhydra hydra-ibuffer-sort (:color amaranth :columns 3)
  "Sort"
  ("i" ibuffer-invert-sorting "invert")
  ("a" ibuffer-do-sort-by-alphabetic "alphabetic")
  ("v" ibuffer-do-sort-by-recency "recently used")
  ("s" ibuffer-do-sort-by-size "size")
  ("f" ibuffer-do-sort-by-filename/process "filename")
  ("m" ibuffer-do-sort-by-major-mode "mode")
  ("b" hydra-ibuffer-main/body "back" :color blue))

(defhydra hydra-ibuffer-filter (:color amaranth :columns 4)
  "Filter"
  ("m" ibuffer-filter-by-used-mode "mode")
  ("M" ibuffer-filter-by-derived-mode "derived mode")
  ("n" ibuffer-filter-by-name "name")
  ("c" ibuffer-filter-by-content "content")
  ("e" ibuffer-filter-by-predicate "predicate")
  ("f" ibuffer-filter-by-filename "filename")
  (">" ibuffer-filter-by-size-gt "size")
  ("<" ibuffer-filter-by-size-lt "size")
  ("/" ibuffer-filter-disable "disable")
  ("b" hydra-ibuffer-main/body "back" :color blue))

(add-hook 'ibuffer-hook 'hydra-ibuffer-main/body); Automatically open the hydra with Ibuffer;
(define-key 'ibuffer-mode-map (kbd ".") 'hydra-ibuffer-main/body)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Dired
(defhydra hydra-dired (:hint nil :color pink)
  "
_+_ mkdir          _v_iew           _m_ark             _(_ details        _i_nsert-subdir    wdired
_C_opy             _O_ view other   _U_nmark all       _)_ omit-mode      _$_ hide-subdir    C-x C-q : edit
_D_elete           _o_pen other     _u_nmark           _l_ redisplay      _w_ kill-subdir    C-c C-c : commit
_R_ename           _M_ chmod        _t_oggle           _g_ revert buf     _e_ ediff          C-c ESC : abort
_Y_ rel symlink    _G_ chgrp        _E_xtension mark   _s_ort             _=_ pdiff
_S_ymlink          ^ ^              _F_ind marked      _._ toggle hydra   \\ flyspell
_r_sync            ^ ^              ^ ^                ^ ^                _?_ summary
_z_ compress-file  _A_ find regexp
_Z_ compress       _Q_ repl regexp

T - tag prefix
"
  ("\\" dired-do-ispell)
  ("(" dired-hide-details-mode)
  (")" dired-omit-mode)
  ("+" dired-create-directory)
  ("=" diredp-ediff)         ;; smart diff
  ("?" dired-summary)
  ("$" diredp-hide-subdir-nomove)
  ("A" dired-do-find-regexp)
  ("C" dired-do-copy)        ;; Copy all marked files
  ("D" dired-do-delete)
  ("E" dired-mark-extension)
  ("e" dired-ediff-files)
  ("F" dired-do-find-marked-files)
  ("G" dired-do-chgrp)
  ("g" revert-buffer)        ;; read all directories again (refresh)
  ("i" dired-maybe-insert-subdir)
  ("l" dired-do-redisplay)   ;; relist the marked or singel directory
  ("M" dired-do-chmod)
  ("m" dired-mark)
  ("O" dired-display-file)
  ("o" dired-find-file-other-window)
  ("Q" dired-do-find-regexp-and-replace)
  ("R" dired-do-rename)
  ("r" dired-do-rsynch)
  ("S" dired-do-symlink)
  ("s" dired-sort-toggle-or-edit)
  ("t" dired-toggle-marks)
  ("U" dired-unmark-all-marks)
  ("u" dired-unmark)
  ("v" dired-view-file)      ;; q to exit, s to search, = gets line #
  ("w" dired-kill-subdir)
  ("Y" dired-do-relsymlink)
  ("z" diredp-compress-this-file)
  ("Z" dired-do-compress)
  ("q" nil)
  ("." nil :color blue))

(define-key 'dired-mode-map (kbd ".") 'hydra-dired/body)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Info
(defhydra hydra-info (:color blue
                      :hint nil)
      "
Info-mode:

  ^^_]_ forward  (next logical node)       ^^_l_ast (←)        _u_p (↑)                             _f_ollow reference       _T_OC
  ^^_[_ backward (prev logical node)       ^^_r_eturn (→)      _m_enu (↓) (C-u for new window)      _i_ndex                  _d_irectory
  ^^_n_ext (same level only)               ^^_H_istory         _g_oto (C-u for new window)          _,_ next index item      _c_opy node name
  ^^_p_rev (same level only)               _<_/_t_op           _b_eginning of buffer                virtual _I_ndex          _C_lone buffer
  regex _s_earch (_S_ case sensitive)      ^^_>_ final         _e_nd of buffer                      ^^                       _a_propos

  _1_ .. _9_ Pick first .. ninth item in the node's menu.

"
      ("]"   Info-forward-node)
      ("["   Info-backward-node)
      ("n"   Info-next)
      ("p"   Info-prev)
      ("s"   Info-search)
      ("S"   Info-search-case-sensitively)

      ("l"   Info-history-back)
      ("r"   Info-history-forward)
      ("H"   Info-history)
      ("t"   Info-top-node)
      ("<"   Info-top-node)
      (">"   Info-final-node)

      ("u"   Info-up)
      ("^"   Info-up)
      ("m"   Info-menu)
      ("g"   Info-goto-node)
      ("b"   beginning-of-buffer)
      ("e"   end-of-buffer)

      ("f"   Info-follow-reference)
      ("i"   Info-index)
      (","   Info-index-next)
      ("I"   Info-virtual-index)

      ("T"   Info-toc)
      ("d"   Info-directory)
      ("c"   Info-copy-current-node-name)
      ("C"   clone-buffer)
      ("a"   info-apropos)

      ("1"   Info-nth-menu-item)
      ("2"   Info-nth-menu-item)
      ("3"   Info-nth-menu-item)
      ("4"   Info-nth-menu-item)
      ("5"   Info-nth-menu-item)
      ("6"   Info-nth-menu-item)
      ("7"   Info-nth-menu-item)
      ("8"   Info-nth-menu-item)
      ("9"   Info-nth-menu-item)

      ("?"   Info-summary "Info summary")
      ("h"   Info-help "Info help")
      ("q"   Info-exit "Info exit")
      ("C-g" nil "cancel" :color blue))
(define-key 'Info-mode-map (kbd "?") 'hydra-info/body)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(provide '000-emacs-hydra-keymap)
