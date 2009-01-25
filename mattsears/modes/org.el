(add-to-list 'load-path "~/.emacs.d/vendor/remember")

(require 'org-install)
(setq load-path (cons "~/.emacs.d/vendor/org/lisp" load-path))

;; Use IDO for auto-complete
(setq org-completion-use-ido t)

;; Do not fold items on startup
(setq org-startup-folded "showall")

;; Use single stars instead
(setq org-hide-leading-stars t)

;; Default states for todos
(setq org-todo-keywords '("TODO" "STARTED" "WAITING" "DONE" "DEFERRED" "CANCELLED"))

;; Include todos in icalendar export
(setq org-icalendar-include-todo t)

;; The location of the icalendar fiel
(setq org-combined-agenda-icalendar-file "~/org/org.ics")

;; Format the agenda grid
(setq org-agenda-time-grid '((daily require-timed)
                             "--------------------"
                             (800 1000 1200 1400 1600 1800 2000 2200)))

;; If things are done, then skip them
(setq org-agenda-skip-deadline-if-done t)
(setq org-agenda-skip-scheduled-if-done t)

;; Keep the recent notes on top
(setq org-reverse-note-order t)
(setq org-cycle-include-plain-lists nil)



;; The following lines are always needed.  Choose your own keys.
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;; (eval-after-load 'org
;;   '(progn
;;      (defun wicked/org-clock-in-if-starting ()
;;        "Clock in when the task is marked STARTED."
;;        (when (and (string= state "STARTED")
;; 		  (not (string= last-state state)))
;; 	 (org-clock-in)))
;;      (add-hook 'org-after-todo-state-change-hook
;; 	       'wicked/org-clock-in-if-starting)
;;      (defadvice org-clock-in (after wicked activate)
;;       "Set this task's status to 'STARTED'."
;;       (org-todo "STARTED"))
;;     (defun wicked/org-clock-out-if-waiting ()
;;       "Clock out when the task is marked WAITING."
;;       (when (and (string= state "WAITING")
;;                  (equal (marker-buffer org-clock-marker) (current-buffer))
;;                  (< (point) org-clock-marker)
;; 	         (> (save-excursion (outline-next-heading) (point))
;; 		    org-clock-marker)
;; 		 (not (string= last-state state)))
;; 	(org-clock-out)))
;;     (add-hook 'org-after-todo-state-change-hook
;;               'wicked/org-clock-out-if-waiting)))

(eval-after-load 'org
  '(progn
     (define-prefix-command 'org-todo-state-map)
     (define-key org-todo-state-map "x"
       #'(lambda nil (interactive) (org-todo "CANCELLED")))
     (define-key org-todo-state-map "d"
       #'(lambda nil (interactive) (org-todo "DONE")))
     (define-key org-todo-state-map "f"
       #'(lambda nil (interactive) (org-todo "DEFERRED")))
     (define-key org-todo-state-map "l"
       #'(lambda nil (interactive) (org-todo "DELEGATED")))
     (define-key org-todo-state-map "s"
       #'(lambda nil (interactive) (org-todo "STARTED")))
     (define-key org-todo-state-map "w"
       #'(lambda nil (interactive) (org-todo "WAITING")))
     ))

;; Remember mode
(require 'remember)
(add-hook 'remember-mode-hook 'org-remember-apply-template)

;; Key binding for remember
(define-key global-map [(control meta ?r)] 'remember)


;; Custom settings
(custom-set-variables
 '(org-agenda-files (quote ("~/org/home.org" "~/org/work.org" )))
 '(org-default-notes-file "~/org/notes.org")
 '(org-combined-agenda-icalendar-file "~/org/agenda.ics")
 '(org-agenda-ndays 7)
 '(org-deadline-warning-days 14)
 '(org-agenda-show-all-dates t)
 '(org-agenda-skip-deadline-if-done t)
 '(org-agenda-skip-scheduled-if-done t)
 '(org-agenda-start-on-weekday nil)
 '(org-reverse-note-order t)
 '(org-fast-tag-selection-single-key (quote expert))
 '(org-tag-alist '(("URGENT" . ?u)
                  ("@CALL" . ?c)
                  ("@ERRANDS" . ?e)))
 '(org-agenda-custom-commands
   (quote (("d" todo "DELEGATED" nil)
           ("c" todo "DONE|DEFERRED|CANCELLED" nil)
           ("w" todo "WAITING" nil)
           ("W" agenda "" ((org-agenda-ndays 21)))
           ("A" agenda ""
            ((org-agenda-skip-function
              (lambda nil
                (org-agenda-skip-entry-if (quote notregexp) "\\=.*\\[#A\\]")))
             (org-agenda-ndays 1)
             (org-agenda-overriding-header "Today's Priority #A tasks: ")))
           ("u" alltodo ""
            ((org-agenda-skip-function
              (lambda nil
                (org-agenda-skip-entry-if (quote scheduled) (quote deadline)
                                          (quote regexp) "<[^>\n]+>")))
             (org-agenda-overriding-header "Unscheduled TODO entries: "))))))
 '(org-remember-store-without-prompt t)
 '(org-remember-templates
   (quote ((116 "* TODO %?\n  %u" "~/todo.org" "Tasks")
           (110 "* %u %?" "~/notes.org" "Notes"))))
 '(remember-annotation-functions (quote (org-remember-annotation)))
 '(remember-handler-functions (quote (org-remember-handler))))
