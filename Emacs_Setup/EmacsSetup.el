
(require 'package) ;; You might already have this line
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (url (concat (if no-ssl "http" "https") "://melpa.org/packages/")))
  (add-to-list 'package-archives (cons "melpa" url) t)  )

(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

;; (setq exec-path (append exec-path '("D:/Backup/Documents/PortableApps/Other/PortableGit/bin")))
(global-set-key (kbd "C-x g") 'magit-status)

(setq visible-bell t)

;; (setq lexical-binding t
;;         visible-bell nil
;;         ring-bell-function 'asc:flash-background)

;;   (defun asc:flash-background ()
;;     (let ((fg (face-foreground 'default))
;;           (bg (face-background 'default)))
;;       (set-face-background 'default "DodgerBlue")
;;       (set-face-foreground 'default "black")
;;       (run-with-idle-timer
;;        0.1 nil (lambda ()
;;                (set-face-background 'default bg)
;;                (set-face-foreground 'default fg)))))

;;(add-to-list 'custom-theme-load-path "/path/to/emacs-leuven-theme")
(setq leuven-scale-outline-headlines nil)
(setq leuven-scale-org-agenda-structure nil) ; nil

(load-theme 'leuven t)                  ; For Emacs 24+.

;; Disable the splash screen (to enable it agin, replace the t with 0)
;; (setq inhibit-splash-screen 0)

(cua-mode t)
(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
(transient-mark-mode 1) ;; No region when it is not highlighted
(setq cua-keep-region-after-copy t) ;; Standard Windows behaviour

;; From tutorial
;; http://orgmode.org/worg/org-tutorials/orgtutorial_dto.html
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)

;; I guess this is not  part of CUA mode
(setq org-support-shift-select t)

;; C-d to duplicate line
;; https://stackoverflow.com/questions/88399/how-do-i-duplicate-a-whole-line-in-emacs
(defun duplicate-line()
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (next-line 1)
  (yank)
)
(global-set-key (kbd "C-d") 'duplicate-line)
;;(global-set-key (kbd "<delete>") 'delete-char) ;; This might be necessary see post

;; Add hunspell
;; (setq ispell-program-name "D:/Backup/Documents/PortableApps/Other/hunspell/bin/hunspell")
(setenv "DICTIONARY" "en_US")

;; Show agenda window in daily view
(add-hook 'after-init-hook (lambda () (org-agenda nil "dw")))

;;;;Org mode configuration
;; Enable Org mode
(require 'org)
(require 'org-habit)

(setq org-startup-indented t)
(add-hook 'org-mode-hook 'turn-on-visual-line-mode)
;; Make Org mode work with files ending in .org
;; (add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
;; The above is the default in recent emacsen

;; Define standart TODO keywords
;; From http://doc.norang.ca/org-mode.html#TasksAndStates

(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
        (sequence "PROJECT(p)" "|" "COMPLETED(c)")
              (sequence "WAITING(w)" "|" "CANCELLED(x)")))

(setq org-todo-keyword-faces
     (quote (("TODO" :foreground "dark gray" :weight bold)
             ("NEXT" :foreground "blue" :weight bold)
             ("DONE" :foreground "forest green" :weight bold)
             ("WAITING" :foreground "orange" :weight bold)
             ("PROJECT" :foreground "black" :weight bold)
             ("CANCELLED" :foreground "light gray" :weight bold))))


(setq org-use-fast-todo-selection t)
(setq org-treat-S-cursor-todo-selection-as-state-change nil)

;; Place to search for agenda files
;; (setq org-agenda-files (quote ("D:/Backup/Documents/Productivity/org-mode/agenda"
;;                               "D:/Backup/Documents/Productivity/org-mode/Index.org") ))
;;  "D:/Backup/Documents/Productivity/org-mode/Index.org"

;; Agenda views
;; Good tutorial: http://orgmode.org/worg/org-tutorials/org-custom-agenda-commands.html

(setq org-agenda-custom-commands
    '( ("w" todo "WAITING" nil)
       ("n" todo "NEXT" nil)
       ("d" . "Agenda + Next Actions")
           ("da" "all" ((agenda) (todo "NEXT") (tags "anchor") )  )
           ("dw" "@work" ((agenda) (todo "NEXT") (tags "anchor") )  ((org-agenda-tag-filter-preset '("-@home")))  )
           ("dh" "@home" ((agenda) (todo "NEXT") (tags "anchor") )  ((org-agenda-tag-filter-preset '("+@home")))  )
       ("x" "Agenda + stuck projects" ((agenda) (stuck "") (todo "NEXT")))
    )
    )

;;  (tag "anchor")
(setq org-tags-exclude-from-inheritance '("anchor"))

;; http://orgmode.org/manual/Stuck-projects.html#Stuck-projects
(setq org-stuck-projects
           '("-SOMEDAY/+PROJECT" ("NEXT") ("@SHOP")
                                    "\\<IGNORE\\>"))

;; Re-file and capture
(setq org-refile-targets '((org-agenda-files :maxlevel . 3)))

(setq org-refile-use-outline-path 'file)

(setq org-refile-allow-creating-parent-nodes 'confirm)

;; (setq org-directory "D:/Backup/Documents/Productivity/org-mode")
;; (setq org-default-notes-file (concat org-directory "/agenda/Inbox-W540.org"))

;; (setq mhee-default-journal-file (concat org-directory "/agenda/Journal.org"))
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "" "Tasks")
         "* TODO %?\n %U %a\n  %i")
        ("i" "Idea" entry (file+headline "" "Ideas")
             "* %?\n %U \n %i")
        ("j" "Journal" entry (file+datetree mhee-default-journal-file)
         "* %?\nEntered on %U\n  %i\n  %a")))


(define-key global-map "\C-cc" 'org-capture)

(setq org-highest-priority ?A)
(setq org-default-priority ?C)
(setq org-lowest-priority ?D)

;; Syntax highlighting
(setq org-src-fontify-natively t)

(setq org-icalendar-use-scheduled '(event-if-todo event-if-not-todo))

(setq org-image-actual-width nil)

(setq org-log-into-drawer t)
(setq org-clock-into-drawer t)
(setq org-log-done t)
