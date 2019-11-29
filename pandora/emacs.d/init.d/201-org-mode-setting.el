(provide '201-org-mode-setting)

;;autoopen image, like in WIKI
;;(auto-image-file-mode)
;;operation in compression tarball
(auto-compression-mode 1)

(setq org-agenda-files (list "c:/Users/Chaofeng_Dun/Documents/todo.org"))

;(setq org-agenda-text-search-extra-files
;      '(agenda-archives
;        "~/org/subdir/textfile1.txt"
;        "~/org/subdir/textfile1.txt"))

;; bindings to specific mode based on file type
(setq auto-mode-alist
 (append '(("\\.org$"  . org-mode)
           ("\\.css$"  . css-mode))
  auto-mode-alist))

(with-eval-after-load "org"
 (progn
  (setq fill-column 120)
  (auto-image-file-mode)
  ;; html export settings
  (setq org-html-inline-images t)
  (setq org-html-doctype "xhtml-strict")
  (setq org-htmlcontainer-element "div")
  (setq org-html-head-include-default-style nil)
  ;;#+OPTIONS;;;;;;;;;;;;;;;;;;;;;;;;;;
  (setq org-export-with-smart-quotes t)
  (setq org-export-with-emphasize t)
  (setq org-export-preserve-breaks t)
  (setq org-export-withsub-superscripts "{}")
  (setq org-export-withdrawers nil)
  (setq org-export-with-date t)
  (setq org-export-with-footnotes t)
  (setq org-export-headline-levels 6)
  ;;(setq org-export-with-inlinetasks t)
  ;;(setq org-export-with-section-numbers 4)
  ;;(setq org-export-with-planning t)
  ;;(setq org-export-with-priority t)
  ;;(setq org-exportwith-properties nil)
  ;;(setq org-export-with-statisticscookies nil)
  ;;(setq org-export-with-tasks t)
  ;;(setq org-export-with-latex t)
  ;;(setq org-export-timestamp-file t)
  (setq org-export-with-title t)
  (setq org-exportwith-toc 2)
  (setq org-export-withtodo-keywords t)
  (setq org-export-with-tables t)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;   (setq org-html-head "<style type='text/css'>
;; * { margin: 0; padding: 0; border: 0; }
;; html { background-color: silver; }
;; body
;; {
;;     margin-top: 0; margin-bottom: 0;
;;     margin-left: 16%; margin-right: 16%;
;;     padding-top: 2pt; padding-bottom: 2pt;
;;     padding-letf: 2pt; padding-right: 2pt;
;;     border: thin solid #3d3d3d;
;;     border-top: none; border-bottom: none;
;;     background-color: white;
;;     
;;     /* if spread-radius == - blur-radius,
;;        it could remove shadow if x/y-offset == blur-radius!! */
;;     box-shadow: 10px 10px 5px 5px #666, -10px 10px 5px 5px #666;
;;     -moz-box-shadow: 10px 10px 5px 5px #666, -10px 10px 5px 5px #666;
;;     -webkit-box-shadow:10px 10px 5px 5px #666, -10px 10px 5px 5px #666;
;; 
;;     font-family: '微软雅黑', '宋体', 'Courier New', 'Verdana', Arial;
;;     font-size: 14pt; color: #333;
;;     letter-spacing: 1px; /*word-spacing: 2px;*/
;; }
;; 
;; /* TODO: font-color optimize */
;; h1 { font-weight: bold; font-size: 36pt;}
;; h2 { font-size: 24pt;}
;; h3 { font-weight: normal; font-size: 20pt; }
;; h4 { font-weight: normal; font-size: 18pt; }
;; h5, h6 { font-weight: normal; font-size: 16pt; }
;; h1.title { text-align: center; font-size: 36pt; background-color: #3CF; }
;; 
;; h2::after {
;;     position: relative;
;;     background-color: #FFF; /* why no effect */
;;     display: block;
;;     top: .1em;
;;     content: '';
;;     border-top: 1px solid black;
;;     margin-bottom: .9em;
;; }
;; 
;; /* try to align span with other inline element */
;; span { vertical-align: -2.2%; }
;; 
;; div { margin: 0; padding 0; }
;; body > div { margin: 1em; margin-top: 2pt; }
;; 
;; p { margin-left: 1em; text-indent: 2em; }
;; 
;; p + table { margin-left: 2em; }
;; 
;; * ul, * ol { margin-left: 1em; }
;; /* why 5em, how to indent for list/table? */
;; p + ul, p + ol { margin-left: 5em; }
;; 
;; code
;; {
;;     font-family: 'Droid Sans Mono';
;;     background-color: #eeeeee;
;;     padding: 2pt;
;;     margin-right: 1pt;
;;     box-shadow: 1px 1px 1px #aaa;
;; }
;; 
;; pre
;; {
;;     font-family: monospace;
;;     font-size: .8em;
;;     font-weight: normal;
;;     line-height: 1.4em;
;;     background-color: #eeeeee;
;;     box-shadow: 1px 1px 1px #aaa;
;; 
;;     border: 1px solid #ccc;
;;     margin: 1.2em; padding: 8pt;
;;     overflow: auto;
;; }
;; 
;; a { text-decoration: none; }
;; a:visited { text-decoration: none; }
;; a:hover { text-decoration: underline; }
;; /* hide inner link position */
;; a[name] { display: none; }
;; /* show footnotes */
;; div[class='footdef'] a[name][class='footnum'] { display: inherit; }
;; /* TODO: fix sup align */
;; /* div[class='footdef'] { vertical-align: text-bottom; } */
;; 
;; /* ---------------------orgmode default settings--------------------- */
;; 
;; .todo { font-family: monospace; color: red; }
;; .done { color: green; }
;; .tag
;; {
;;     background-color: #eee; font-family: monospace;
;;     padding: 2px; font-size: 80%; font-weight: normal;
;; }
;; 
;; .timestamp { color: #bebebe; }
;; .timestamp-kwd { color: #5f9ea0; }
;; .right  { margin-left: auto; margin-right: 0px;  text-align: right; }
;; .left   { margin-left: 0px;  margin-right: auto; text-align: left; }
;; .center { margin-left: auto; margin-right: auto; text-align: center; }
;; .underline { text-decoration: underline; }
;; #postamble p, #preamble p { font-size: 90%; margin: .2em; }
;; p.verse { margin-left: 3%; }
;; pre {
;; 
;; }
;; pre.src {
;;   position: relative;
;;   overflow: visible;
;;   padding-top: 1.2em;
;; }
;; pre.src:before {
;;   display: none;
;;   position: absolute;
;;   background-color: white;
;;   top: -10px;
;;   right: 10px;
;;   padding: 3px;
;;   border: 1px solid black;
;; }
;; pre.src:hover:before { display: inline;}
;; pre.src-sh:before    { content: 'sh'; }
;; pre.src-bash:before  { content: 'sh'; }
;; pre.src-emacs-lisp:before { content: 'Emacs Lisp'; }
;; pre.src-R:before     { content: 'R'; }
;; pre.src-perl:before  { content: 'Perl'; }
;; pre.src-java:before  { content: 'Java'; }
;; pre.src-sql:before   { content: 'SQL'; }
;; 
;; dt { font-weight: bold; }
;; .footpara:nth-child(2) { display: inline; }
;; .footpara { display: block; }
;; .footdef  { margin-bottom: 1em; }
;; .figure { padding: 1em; }
;; .figure p { text-align: center; }
;; .inlinetask {
;;   padding: 10px;
;;   border: 2px solid gray;
;;   margin: 10px;
;;   background: #ffffcc;
;; }
;; 
;; table caption{
;; 	font-size:20px;
;; 	font-weight:normal;
;; 	padding-top: 20px;
;; 	height:50px;}
;; 
;; table {
;;     border-collapse: collapse;
;;     border-spacing: 0;
;;     border: 1px solid #555;
;; 	width:100%;
;; 	-webkit-box-shadow:  0px 2px 1px 5px rgba(242, 242, 242, 0.1);
;;     box-shadow:  0px 2px 1px 5px rgba(242, 242, 242, 0.1);
;; 
;; }
;; 
;; table td {
;;     border-left: 1px solid #555;
;;     border-top: 1px solid #555;
;;     padding: 10px;
;;     text-align: left;    
;; }
;; 
;; table th, table th:hover {
;;     border-left: 1px solid #555;
;; 	border-bottom: 1px solid #828282;
;;     padding: 20px;  
;;     background-color:#151515 !important;
;;     background-image: -webkit-gradient(linear, left top, left bottom, from(#151515), to(#404040)) !important;
;;     background-image: -webkit-linear-gradient(top, #151515, #404040) !important;
;;     background-image:    -moz-linear-gradient(top, #151515, #404040) !important;
;;     background-image:     -ms-linear-gradient(top, #151515, #404040) !important;
;;     background-image:      -o-linear-gradient(top, #151515, #404040) !important;
;;     background-image:         linear-gradient(top, #151515, #404040) !important;
;; 	color:#fff !important;
;; 	font-weight:normal;
;; }
;; 
;; table tbody tr:nth-child(even) {
;;     background: #000 !important;
;; 	color:#fff;
;; }
;; 
;; table tr:hover *{
;;     background: #eeeeee;
;; 	color:#000;
;; }
;; 
;; table tr {
;; 	background:#404040;
;; 	color:#fff;
;; }
;; </style>")
  ;;(setq org-htmlhead-extra "<link rel=\"stylesheet\" type=\"text/css\" href=\"org.css\" />")
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;html table settings
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; PDF export settings
  (setq org-latex-pdf-process (quote
   ("xelatex -interaction nonstopmode -output-directory %o %f")))
 ))
