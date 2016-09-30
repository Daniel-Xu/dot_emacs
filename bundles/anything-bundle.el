;;; anything-bundle.el --- Just anything

;;; Commentary:
;;

;;; Code:

(menu-bar-mode -1)

(smex-initialize)
;(ido-hacks 1)
(require 'projectile)
(setq projectile-enable-caching t)
(setq projectile-globally-ignored-directories (append '("node_modules" ".svn") projectile-globally-ignored-directories))
(projectile-mode t)
(projectile-global-mode)

;; Show projectile lists by most recently active
(setq projectile-sort-order (quote recently-active))

(setq ido-decorations (quote ("\n↪ "     "" "\n   " "\n   ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))

(require 'flx-ido)
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)

;; Parens handling
;; Show and create matching parens automatically
(show-paren-mode t)
(smartparens-global-mode t)
(show-smartparens-global-mode nil)
(setq sp-autoescape-string-quote nil)
;; Do not highlight paren area
(setq sp-highlight-pair-overlay nil)
(setq sp-highlight-wrap-overlay nil)
(setq sp-highlight-wrap-tag-overlay nil)
;; Do not use default slight delay
(setq show-paren-delay 0)
(setq evil-want-fine-undo nil)
(setq evil-in-single-undo t)
(global-auto-revert-mode t)


;;==============================================================================
;; web-mode
;;==============================================================================
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.hbs\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
;;==============================================================================
;; Autocomplete with company-mode
;;==============================================================================
(global-company-mode t)
(setq company-tooltip-limit 12)                      ; bigger popup window
(setq company-idle-delay .1)                         ; decrease delay before autocompletion popup shows
(setq company-echo-delay 0)                          ; remove annoying blinking
(setq company-begin-commands '(self-insert-command)) ; start autocompletion only after typing
(setq company-dabbrev-downcase nil)                  ; Do not convert to lowercase
(setq company-selection-wrap-around t)               ; continue from top when reaching bottom
(with-eval-after-load 'company
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous))
;; =============================================================================
;; lobal settings
;; =============================================================================
;; (setq auto-save-default nil)
;; (setq make-backup-files nil)
;; =============================================================================
;; multiple cursor
;; =============================================================================
; visual select one word and press R, then C to modify or anything else
(require 'evil-multiedit)
(evil-multiedit-default-keybinds)

;; =============================================================================
;; surround
;; =============================================================================
(require 'evil-surround)
(global-evil-surround-mode 1)

;; =============================================================================
;; expand region
;; =============================================================================
(require 'expand-region)
;; press ,vv to select and v to expand, V to contract
(eval-after-load "evil" '(setq expand-region-contract-fast-key "V"))
(evil-leader/set-key "vv" 'er/expand-region)
(set-face-attribute 'region nil :background "#C0504D")

;; =============================================================================
;; line number
;; =============================================================================
(global-linum-mode t)
(defun linum-format-func (line)
  (let ((w (length (number-to-string (count-lines (point-min) (point-max))))))
     (propertize (format (format "%%%dd " w) line) 'face 'linum)))

;; use customized linum-format: add a addition space after the line number
(setq linum-format 'linum-format-func)

;; =============================================================================
;; matchit
;; =============================================================================
(require 'evil-matchit)

(defun evilmi-customize-keybinding ()
  (evil-define-key 'visual evil-matchit-mode-map
    (kbd "TAB") 'evilmi-jump-items)
  (evil-define-key 'normal evil-matchit-mode-map
    (kbd "TAB") 'evilmi-jump-items))

(global-evil-matchit-mode 1)
(evil-leader/set-key "vb" 'exchange-point-and-mark)

;; =============================================================================
;; snippet
;; =============================================================================
(require 'yasnippet)
(yas-global-mode 1)
; setup yasnippet snipppet repo
(setq yas-snippet-dirs (append yas-snippet-dirs
                               '("~/.emacs.d/snippets")))
;; =============================================================================
;; Evil
;; =============================================================================
(osx-clipboard-mode +1)

(require 'evil)
(evil-mode 1)
(global-evil-visualstar-mode 1)
; (setq evil-default-cursor t)
(progn (setq evil-default-state 'normal)
       (setq evil-auto-indent t)
       (setq evil-shift-width 2)
       (setq evil-search-wrap t)
       (setq evil-find-skip-newlines t)
       (setq evil-mode-line-format 'before)
       (setq evil-esc-delay 0.001)
       (setq evil-cross-lines t))

(setq evil-overriding-maps nil)
(setq evil-intercept-maps nil)

;; Don't wait for any other keys after escape is pressed.
(setq evil-esc-delay 0)

;; Don't show default text in command bar
;  ** Currently breaks visual range selection, looking for workaround
;(add-hook 'minibuffer-setup-hook (lambda () (evil-ex-remove-default)))

;; Make HJKL keys work in special buffers
(evil-add-hjkl-bindings magit-branch-manager-mode-map 'emacs
  "K" 'magit-discard-item
  "L" 'magit-key-mode-popup-logging)
(evil-add-hjkl-bindings magit-status-mode-map 'emacs
  "K" 'magit-discard-item
  "l" 'magit-key-mode-popup-logging
  "h" 'magit-toggle-diff-refine-hunk)
(evil-add-hjkl-bindings magit-log-mode-map 'emacs)
(evil-add-hjkl-bindings magit-commit-mode-map 'emacs)
(evil-add-hjkl-bindings occur-mode 'emacs)


;;(evil-set-initial-state 'git-commit-mode 'normal)

(setq evil-want-C-i-jump t)
(setq evil-want-C-u-scroll t)

(global-evil-leader-mode)
(evil-leader/set-leader ",")
(evil-leader/set-key
  "." 'find-tag
  "t" 'helm-projectile-find-file
  "p" 'helm-projectile-switch-project
  "b" 'helm-mini
  "o" 'helm-projectile-find-other-file
  "o" 'projectile-toggle-between-implementation-and-test
  "mh" 'evil-window-move-far-left
  "mj" 'evil-window-move-very-bottom
  "mk" 'evil-window-move-very-top
  "ml" 'evil-window-move-far-right
  "cc" 'evilnc-comment-or-uncomment-lines
  "ag" 'helm-projectile-ag
  "," 'switch-to-previous-buffer
  "gd" 'git-gutter:popup-diff
  "gp" 'git-gutter:previous-hunk
  "gn" 'git-gutter:next-hunk
  "gr" 'git-gutter:revert-hunk
  "ga" 'git-gutter:stage-hunk
  "gb" 'magit-blame
  "gc" 'magit-checkout-file
  "gL" 'magit-log
  "gs" 'magit-status
  "w"  'delete-window
  "d"  'kill-buffer-and-window'
  "nn" 'neotree-toggle
  "nf" 'neotree-find
  "gk" 'windmove-up
  "gj" 'windmove-down
  "gl" 'windmove-right
  "gh" 'windmove-left
  "vs" 'split-window-right
  "hs" 'split-window-below
  "s" 'ispell-word
  "=" 'balance-windows
  "f" 'delete-other-windows
  "ar" 'align-regexp
  "x" 'helm-M-x)

;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; =============================================================================
;; Evil Packages
;; =============================================================================

;; evil-magit
(setq evil-magit-state 'normal)
;; optional: disable additional bindings for yanking text
;; (setq evil-magit-use-y-for-yank nil)
(require 'evil-magit)

(require 'evil-visualstar)

(defun fix-underscore-word ()
  (modify-syntax-entry ?_ "w"))

;; =============================================================================
;; Buffer
;; =============================================================================
(defun buffer-exists (bufname)   (not (eq nil (get-buffer bufname))))
(defun switch-to-previous-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  ;; Don't switch back to the ibuffer!!!
  (if (buffer-exists "*Ibuffer*")  (kill-buffer "*Ibuffer*"))
  (switch-to-buffer (other-buffer (current-buffer) 1)))

;; =============================================================================
;; helm - search file
;; =============================================================================
(require 'helm-projectile)
(helm-projectile-on)
(define-key helm-map (kbd "C-w") 'backward-kill-word)
(global-set-key (kbd "M-x") 'helm-M-x)
(define-key helm-map (kbd "C-o") 'helm-ff-run-switch-other-window)
(setq projectile-switch-project-action 'helm-projectile)
(setq helm-M-x-fuzzy-match t)
(setq projectile-completion-system 'helm)
(setq helm-split-window-in-side-p t)
(setq helm-display-header-line nil)
(set-face-attribute 'helm-source-header nil :height 0.1)
(helm-autoresize-mode 1)
(setq helm-autoresize-max-height 30)
(setq helm-autoresize-min-height 30)
(setq helm-split-window-in-side-p t)
(defvar helm-source-header-default-background (face-attribute 'helm-source-header :background))
(defvar helm-source-header-default-foreground (face-attribute 'helm-source-header :foreground))
(defvar helm-source-header-default-box (face-attribute 'helm-source-header :box))

(defun helm-toggle-header-line ()
  (if (> (length helm-sources) 1)
      (set-face-attribute 'helm-source-header
                          nil
                          :foreground helm-source-header-default-foreground
                          :background helm-source-header-default-background
                          :box helm-source-header-default-box
                          :height 1.0)
    (set-face-attribute 'helm-source-header
                        nil
                        :foreground (face-attribute 'helm-selection :background)
                        :background (face-attribute 'helm-selection :background)
                        :box nil
                        :height 0.1)))
(add-to-list 'projectile-globally-ignored-directories "backup")
(add-to-list 'projectile-other-file-alist '("html" "js")) ;; switch from html -> js
(add-to-list 'projectile-other-file-alist '("js" "html")) ;; switch from js -> html

;; =============================================================================
;; Evil Bindings
;; =============================================================================
;; Git Gutter
(global-git-gutter-mode 1)
(custom-set-variables
 '(git-gutter:hide-gutter t))

(add-hook 'magit-post-refresh-hook
          #'git-gutter:update-all-windows)

(add-hook 'magit-refresh-buffer-hook
          #'git-gutter:update-all-windows)

;; =============================================================================
;; ember-mode
;; =============================================================================
(require 'ember-mode)

(add-hook 'web-mode-hook (lambda () (ember-mode t)))
(add-hook 'js-mode-hook (lambda () (ember-mode t)))

;; =============================================================================
;; shell
;; =============================================================================
(defun eshell/clear ()
  "Clear the eshell buffer."
  (let ((inhibit-read-only t))
    (erase-buffer)
    (eshell-send-input)))

(defun eshell-here (arg)
  "Opens up a new shell in the directory associated with the
current buffer's file. The eshell is renamed to match that
directory to make multiple eshell windows easier."
  (interactive)
  (let* ((parent (if (buffer-file-name)
                   (file-name-directory (buffer-file-name))
                   default-directory))
          (height (/ (window-total-height) 3))
          (name   (car (last (split-string parent "/" t)))))
    (split-window-vertically (- height))
    (other-window 1)
    (let ((arg (or arg 1)))
      (eshell (format "*eshell%d*" arg)))
    (insert (concat "ls"))
    (eshell-send-input)))


(global-set-key (kbd "C-c 1") '(lambda () (interactive) (eshell-here 1)))
(global-set-key (kbd "C-c 2") '(lambda () (interactive) (eshell-here 2)))
(global-set-key (kbd "C-c 3") '(lambda () (interactive) (eshell-here 3)))
(global-set-key (kbd "C-c 4") '(lambda () (interactive) (eshell-here 4)))
(global-set-key (kbd "C-c 5") '(lambda () (interactive) (eshell-here 5)))
;; =============================================================================
;; elm configuration
;; =============================================================================
;; C-c C-c will compile the buffer
;; C-c C-n will preview it in a browser
;; C-c C-d will show the doc of a function
;; C-c M-k opens the package catalog
;; C-c C-l open repl
(require 'elm-mode)
(setq elm-format-on-save t)
(add-hook 'elm-mode-hook #'elm-oracle-setup-completion)
(add-to-list 'company-backends 'company-elm)

;; =============================================================================
;; make tab work
;; =============================================================================
(defun check-expansion ()
  (save-excursion
    (if (looking-at "\\_>") t
      (backward-char 1)
      (if (looking-at "\\.") t
    (backward-char 1)
    (if (looking-at "->") t nil)))))

(defun do-yas-expand ()
  (let ((yas/fallback-behavior 'return-nil))
    (yas/expand)))

(defun tab-indent-or-complete ()
  (interactive)
  (cond
   ((minibufferp)
    (minibuffer-complete))
   (t
    (indent-for-tab-command)
    (if (or (not yas/minor-mode)
        (null (do-yas-expand)))
    (if (check-expansion)
        (progn
          (company-manual-begin)
          (if (null company-candidates)
          (progn
            (company-abort)
            (indent-for-tab-command)))))))))

(defun tab-complete-or-next-field ()
  (interactive)
  (if (or (not yas/minor-mode)
      (null (do-yas-expand)))
      (if company-candidates
      (company-complete-selection)
    (if (check-expansion)
      (progn
        (company-manual-begin)
        (if (null company-candidates)
        (progn
          (company-abort)
          (yas-next-field))))
      (yas-next-field)))))

(defun expand-snippet-or-complete-selection ()
  (interactive)
  (if (or (not yas/minor-mode)
      (null (do-yas-expand))
      (company-abort))
      (company-complete-selection)))

(defun abort-company-or-yas ()
  (interactive)
  (if (null company-candidates)
      (yas-abort-snippet)
    (company-abort)))

(global-set-key [tab] 'tab-indent-or-complete)
(global-set-key (kbd "TAB") 'tab-indent-or-complete)
(global-set-key [(control return)] 'company-complete-common)

(define-key company-active-map [tab] 'expand-snippet-or-complete-selection)
(define-key company-active-map (kbd "TAB") 'expand-snippet-or-complete-selection)

(define-key yas-minor-mode-map [tab] nil)
(define-key yas-minor-mode-map (kbd "TAB") nil)

(define-key yas-keymap [tab] 'tab-complete-or-next-field)
(define-key yas-keymap (kbd "TAB") 'tab-complete-or-next-field)
(define-key yas-keymap [(control tab)] 'yas-next-field)

;; =============================================================================
;; fly check
;; =============================================================================
;; (require 'flycheck)

;; =============================================================================
;; Evil Bindings
;; =============================================================================
(define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
(define-key evil-normal-state-map (kbd "C-p") 'helm-projectile-switch-project)
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)

;; Yank whole buffer
(define-key evil-normal-state-map (kbd "gy") (kbd "gg v G y"))

(setq key-chord-two-keys-delay 0.075)
(key-chord-mode 1)
(key-chord-define evil-insert-state-map "jj" 'evil-normal-state)
(key-chord-define evil-insert-state-map "JJ" 'evil-normal-state)
(key-chord-define evil-insert-state-map "JJ" 'evil-normal-state)

(define-key evil-insert-state-map "j" #'cofi/maybe-exit-j)
(define-key evil-insert-state-map "J" #'cofi/maybe-exit-J)
(evil-define-command cofi/maybe-exit-j ()
  :repeat change
  (interactive)
  (let ((modified (buffer-modified-p)))
    (insert "j")
    (let ((evt (read-event (format "" ?k)
               nil 0.5)))
      (cond
       ((null evt) (message ""))
       ((and (integerp evt) (char-equal evt ?k))
         (delete-char -1)
         (set-buffer-modified-p modified)
         (push 'escape unread-command-events))
       (t (setq unread-command-events (append unread-command-events
                          (list evt))))))))

(evil-define-command cofi/maybe-exit-J ()
  :repeat change
  (interactive)
  (let ((modified (buffer-modified-p)))
    (insert "J")
    (let ((evt (read-event (format "" ?k)
               nil 0.5)))
      (cond
       ((null evt) (message ""))
       ((and (integerp evt) (char-equal evt ?k))
         (delete-char -1)
         (set-buffer-modified-p modified)
         (push 'escape unread-command-events))
       (t (setq unread-command-events (append unread-command-events
                          (list evt))))))))

(define-key evil-normal-state-map "gh" 'windmove-left)
(define-key evil-normal-state-map "gj" 'windmove-down)
(define-key evil-normal-state-map "gk" 'windmove-up)
(define-key evil-normal-state-map "gl" 'windmove-right)
(define-key evil-normal-state-map ",q" 'evil-quit)

(add-hook 'neotree-mode-hook
 (lambda ()
   (define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter)
   (define-key evil-normal-state-local-map (kbd "SPC") 'neotree-enter)
   (define-key evil-normal-state-local-map (kbd "o") 'neotree-enter)
   (define-key evil-normal-state-local-map (kbd "go") 'neotree-quick-look)
   (define-key evil-normal-state-local-map (kbd "s") 'neotree-enter-horizontal-split)
   (define-key evil-normal-state-local-map (kbd "v") 'neotree-enter-vertical-split)
   (define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter)
   (define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
         (define-key evil-normal-state-local-map (kbd "ma") 'neotree-create-node)
         (define-key evil-normal-state-local-map (kbd "md") 'neotree-delete-node)
         (define-key evil-normal-state-local-map (kbd "r") 'neotree-refresh)
         (define-key evil-normal-state-local-map (kbd "mm") 'neotree-rename-node)
))

;; Map ctrl-n/p to up down in ido selections
(add-hook 'ido-setup-hook
  (lambda ()
    (define-key ido-completion-map (kbd "C-n") 'ido-next-match)
    (define-key ido-completion-map (kbd "C-p") 'ido-prev-match)
))


;; =============================================================================
;; UI
;; =============================================================================
;; window resize
;; C-w -  or n C-w -
;; C-w +
;; C-w >
;; C-w <
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(setq-default truncate-lines t)

;; Remember the cursor position of files when reopening them
(setq save-place-file "~/.emacs.d/saveplace")
(setq-default save-place t)
(require 'saveplace)

;; show the column number in the status bar
(column-number-mode t)

;; smart line mode -> powerline
(setq sml/theme 'powerline)
(sml/setup)
(setq powerline-arrow-shape 'curve)
;; (setq powerline-default-separator-dir '(right . left))
(custom-set-faces
 '(mode-line ((t (:foreground "#ffffff" :background "#FF6E64" :box nil))))
 '(mode-line-inactive ((t (:foreground "#f9f9f9" :background "#5CC9F5" :box nil)))))

;; Highlight cursor line
(global-hl-line-mode t)
(set-face-background hl-line-face "gray10")

;; Make lines longer than 80 highlighted
(setq whitespace-line-column 80) ;; limit line length
(setq whitespace-style '(face lines-tail))
(global-whitespace-mode t)

(add-hook 'prog-mode-hook 'whitespace-mode)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; ;; If you would like to use git-gutter.el and linum-mode
;; (git-gutter:linum-setup)

(require 'smooth-scrolling)
(smooth-scrolling-mode t)
(setq smooth-scroll-margin 3)
;; Delay updates to give Emacs a chance for other changes
(setq linum-delay t)
(setq redisplay-dont-pause t)

; Auto-indent with the Return key
(define-key global-map (kbd "RET") 'newline-and-indent)

;; Fix cursor
(defun my-send-string-to-terminal (string)
   (unless (display-graphic-p) (send-string-to-terminal string)))

(defun my-evil-terminal-cursor-change ()
   (when (string= (getenv "TERM_PROGRAM") "iTerm.app")
        (add-hook 'evil-insert-state-entry-hook (lambda () (my-send-string-to-terminal "\e]50;CursorShape=1\x7")))
           (add-hook 'evil-insert-state-exit-hook  (lambda () (my-send-string-to-terminal "\e]50;CursorShape=0\x7"))))
     (when (and (getenv "TMUX") (string= (getenv "TERM_PROGRAM") "iTerm.app"))
          (add-hook 'evil-insert-state-entry-hook (lambda () (my-send-string-to-terminal "\ePtmux;\e\e]50;CursorShape=1\x7\e\\")))
              (add-hook 'evil-insert-state-exit-hook  (lambda () (my-send-string-to-terminal "\ePtmux;\e\e]50;CursorShape=0\x7\e\\")))))

  (add-hook 'after-make-frame-functions (lambda (frame) (my-evil-terminal-cursor-change)))
  (my-evil-terminal-cursor-change)


;; (defun change-major-mode-hook () (modify-syntax-entry ?_ "w"))
(setq inhibit-startup-screen t)

;; =============================================================================
;; Custom Packages
;; =============================================================================

(load "~/.emacs.d/vendor/ujelly-theme/ujelly-theme.el")
(load-theme 'ujelly)

(setq initial-major-mode 'elixir-mode)
(setq initial-scratch-message "# scratch")

(add-to-list 'load-path "~/.emacs.d/vendor/longlines/")
(require 'longlines)

(require 'elixir-mode)
(add-to-list 'load-path "~/.emacs.d/vendor/alchemist.el")
(require 'alchemist)

(sp-with-modes '(elixir-mode)
  (sp-local-pair "fn" "end"
         :when '(("SPC" "RET"))
         :actions '(insert navigate))
  (sp-local-pair "do" "end"
         :when '(("SPC" "RET"))
         :post-handlers '(sp-ruby-def-post-handler)
         :actions '(insert navigate)))
(load "~/.emacs.d/vendor/change-case.el")

;; Enable mouse support
(unless window-system
  (require 'mouse)
  (xterm-mouse-mode t)
  (global-set-key [mouse-4] '(lambda ()
                              (interactive)
                              (scroll-down 1)))
  (global-set-key [mouse-5] '(lambda ()
                              (interactive)
                              (scroll-up 1)))
  (defun track-mouse (e))
  (setq mouse-sel-mode t)
)

(defun author-mode ()
  (interactive)
  (linum-mode -1)
  (writeroom-mode t)
  (longlines-mode t)
  (flyspell-mode t)
  (turn-off-smartparens-mode)
  (company-mode -1)
  )

;; I want underscores as part of word in all modes
(modify-syntax-entry (string-to-char "_") "w" (standard-syntax-table))
(modify-syntax-entry (string-to-char "_") "w" text-mode-syntax-table)
(modify-syntax-entry (string-to-char "_") "w" lisp-mode-syntax-table)
(modify-syntax-entry (string-to-char "_") "w" emacs-lisp-mode-syntax-table)
;; (require 'enh-ruby-mode)
(require 'ruby-mode)
(require 'coffee-mode)
(modify-syntax-entry (string-to-char "_") "w" ruby-mode-syntax-table)
(modify-syntax-entry (string-to-char "_") "w" elixir-mode-syntax-table)
(modify-syntax-entry (string-to-char "_") "w" coffee-mode-syntax-table)

;; ;; JSX
;; ;; (require 'web-mode)
;; ;; (add-to-list 'auto-mode-alist '("\\.js[x]?$" . web-mode))
;; ;; (defadvice web-mode-highlight-part (around tweak-jsx activate)
;; ;;   (if (equal web-mode-content-type "jsx")
;; ;;       (let ((web-mode-enable-part-face nil))
;; ;;         ad-do-it)
;; ;;     ad-do-it))
;; (require 'jsx-mode)
;; (add-to-list 'auto-mode-alist '("\\.js[x]?\\'" . jsx-mode))
;; (setq jsx-indent-level 2)


;; File handling
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Space indentation - I want tab as two spaces everywhere
(setq-default indent-tabs-mode nil)
(setq-default indent-line-function 2)
(setq-default tab-width 2)
(setq-default c-basic-offset 2)
(setq-default css-indent-offset 2)
(setq-default lisp-indent-offset 2)
(setq-default sgml-basic-offset 2)
(setq-default nxml-child-indent 2)
(setq-default js-indent-level 2)

;; (add-hook 'enh-ruby-mode-hook (lambda () (setq evil-shift-width 2)))
(add-hook 'ruby-mode-hook (lambda ()
                            (setq evil-shift-width 2)
                            (setq tab-width 2)))

(add-hook 'elixir-mode-hook (lambda ()
                            (setq evil-shift-width 2)
                            (setq tab-width 2)))

(add-hook 'coffee-mode-hook (lambda ()
                            (setq evil-shift-width 2)
                            (setq tab-width 2)))

(add-hook 'haml-mode-hook (lambda ()
                            (setq evil-shift-width 2)
                            (setq tab-width 2)))

(add-hook 'html-mode-hook (lambda ()
                            (emmet-mode t)
                            (setq evil-shift-width 2)
                            (setq tab-width 2)))

(add-hook 'web-mode-hook (lambda ()
                           (emmet-mode t)
                           (setq evil-shift-width 2)
                           (setq tab-width 2)))


;; (add-hook 'jsx-mode-hook (lambda ()
                            ;; (emmet-mode t)))

(add-hook 'css-mode-hook (lambda ()
                            (setq evil-shift-width 2)
                            (setq tab-width 2)))

;; Play nice with evil-mode in compilation-mode, ie project-ag results
(add-hook 'compilation-mode-hook '(lambda ()
                                    (local-unset-key "g")
                                    (local-unset-key "h")
                                    (local-unset-key "k")))

;;==============================================================================
;; Hack "*" to hightlight, but not jump to first match
(defun my-evil-prepare-word-search (forward symbol)
  "Prepare word search, but do not move yet."
  (interactive (list (prefix-numeric-value current-prefix-arg)
                     evil-symbol-word-search))
  (let ((string (car-safe regexp-search-ring))
        (move (if forward #'forward-char #'backward-char))
        (end (if forward #'eobp #'bobp)))
    (setq isearch-forward forward)
    (setq string (evil-find-thing forward (if symbol 'symbol 'word)))
    (cond
     ((null string)
      (error "No word under point"))
     (t
      (setq string
            (format (if symbol "\\_<%s\\_>" "\\<%s\\>")
                    (regexp-quote string)))))
    (evil-push-search-history string forward)
    (my-evil-search string forward t)))

(defun my-evil-search (string forward &optional regexp-p start)
  "Highlight STRING matches.
If FORWARD is nil, search backward, otherwise forward.
If REGEXP-P is non-nil, STRING is taken to be a regular expression.
START is the position to search from; if unspecified, it is
one more than the current position."
  (when (and (stringp string)
             (not (string= string "")))
    (let* ((orig (point))
           (start (or start
                      (if forward
                          (min (point-max) (1+ orig))
                        orig)))
           (isearch-regexp regexp-p)
           (isearch-forward forward)
           (case-fold-search
            (unless (and search-upper-case
                         (not (isearch-no-upper-case-p string nil)))
              case-fold-search)))
      ;; no text properties, thank you very much
      (set-text-properties 0 (length string) nil string)
      (setq isearch-string string)
      (isearch-update-ring string regexp-p)
      ;; handle opening and closing of invisible area
      (cond
       ((boundp 'isearch-filter-predicates)
        (dolist (pred isearch-filter-predicates)
          (funcall pred (match-beginning 0) (match-end 0))))
       ((boundp 'isearch-filter-predicate)
        (funcall isearch-filter-predicate (match-beginning 0) (match-end 0))))
      (evil-flash-search-pattern string t))))

(define-key evil-motion-state-map "*" 'my-evil-prepare-word-search)
(define-key evil-motion-state-map (kbd "*") 'my-evil-prepare-word-search)
;; end highlight hack
;;==============================================================================


;; Enable syntax highlighting in markdown
;; (require 'mmm-mode)
;;   (mmm-add-classes
;;     '((markdown-rubyp
;;       :submode ruby-mode
;;       :face mmm-declaration-submode-face
;;       :front "^\{:language=\"ruby\"\}[\n\r]+~~~"
;;       :back "^~~~$")))

;;   (mmm-add-classes
;;     '((markdown-elixirp
;;       :submode elixir-mode
;;       :face mmm-declaration-submode-face
;;       :front "^\{:language=\"elixir\"\}[\n\r]+~~~"
;;       :back "^~~~$")))

;;   (mmm-add-classes
;;     '((markdown-elixirp
;;       :submode elixir-mode
;;       :face mmm-declaration-submode-face
;;       :front "^```elixir$"
;;       :back "^```$")))

;;   (mmm-add-classes
;;     '((markdown-jsp
;;       :submode js-mode
;;       :face mmm-declaration-submode-face
;;       :front "^\{:language=\"javascript\"\}[\n\r]+~~~"
;;       :back "^~~~$")))

;;   (mmm-add-classes
;;     '((markdown-ruby
;;       :submode ruby-mode
;;       :face mmm-declaration-submode-face
;;       :front "^~~~\s?ruby[\n\r]"
;;       :back "^~~~$")))

;;   (mmm-add-classes
;;     '((markdown-elixir
;;       :submode elixir-mode
;;       :face mmm-declaration-submode-face
;;       :front "^~~~\s?elixir[\n\r]"
;;       :back "^~~~$")))

;;   (mmm-add-classes
;;     '((markdown-js
;;       :submode js-mode
;;       :face mmm-declaration-submode-face
;;       :front "^~~~\s?javascript[\n\r]"
;;       :back "^~~~$")))


;; ;; (setq mmm-global-mode 't)
;; (setq mmm-submode-decoration-level 0)

;; (add-to-list 'mmm-mode-ext-classes-alist '(markdown-mode nil markdown-rubyp))
;; (add-to-list 'mmm-mode-ext-classes-alist '(markdown-mode nil markdown-elixirp))
;; (add-to-list 'mmm-mode-ext-classes-alist '(markdown-mode nil markdown-jsp))
;; (add-to-list 'mmm-mode-ext-classes-alist '(markdown-mode nil markdown-ruby))
;; (add-to-list 'mmm-mode-ext-classes-alist '(markdown-mode nil markdown-elixir))
;; (add-to-list 'mmm-mode-ext-classes-alist '(markdown-mode nil markdown-js))


(setq custom-file (expand-file-name "customize.el" user-emacs-directory))
(load custom-file)

(provide 'anything-bundle)

;;; anything-bundle.el ends here
