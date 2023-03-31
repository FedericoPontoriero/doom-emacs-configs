;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Federico Pontoriero"
      user-mail-address "fedeponto@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;;  you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-xcode)
(setq  doom-font (font-spec :family "FiraCode Nerd Font" :size 16 :weight 'normal)
       doom-variable-pitch-font (font-spec :family "Overpass" :size 16)
        doom-serif-font (font-spec :family "IBM Plex Mono" :size 16 :weight 'light))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq company-show-numbers t)

(global-subword-mode 1)

(display-time-mode 1)

(global-visual-line-mode 1)

(global-set-key (kbd "C-c C-d") 'delete-pair)
(global-set-key (kbd "C-c t") 'sgml-delete-tag)

(after! evil
  (setq evil-want-fine-undo t))

(setq which-key-idle-delay 0.3
      which-key-idle-secondary-delay 0.05
      which-key-allow-multiple-replacements t)

(setq auth-sources '("~/.authinfo"))

(setq confirm-kill-emacs nil)


(apheleia-global-mode 1)

(use-package fira-code-mode
  :custom (fira-code-mode-disabled-ligatures '("[]" "${" "#(" "#_" "#_(" "x"))
  :hook prog-mode)







;; (use-package! tree-sitter
;;   :when (bound-and-true-p module-file-suffix)
;;   :hook (prog-mode . tree-sitter-mode)
;;   :hook (tree-sitter-after-on . tree-sitter-hl-mode)
;;   :config
;;   (require 'tree-sitter-langs)
;;   (global-tree-sitter-mode)
;;   (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)
;;   (defadvice! doom-tree-sitter-fail-gracefully-a (orig-fn &rest args)
;;     "Don't break with errors when current major mode lacks tree-sitter support."
;;     :around #'tree-sitter-mode
;;     (condition-case e
;;         (apply orig-fn args)
;;       (error
;;        (unless (string-match-p (concat "^Cannot find shared library\\|"
;;                                        "^No language registered\\|"
;;                                        "cannot open shared object file")
;;                                (error-message-string e))
;;          (signal (car e) (cadr e)))))))

;; (use-package! typescript-mode
;;   :mode ("\\.tsx\\'" . typescript-tsx-tree-sitter-mode)
;;   :config
;;   (setq typescript-indent-level 2)

;;   (define-derived-mode typescript-tsx-tree-sitter-mode typescript-mode "TypeScript TSX"
;;     (setq-local indent-line-function 'rjsx-indent-line))

;;   (add-hook! 'typescript-tsx-tree-sitter-mode-local-vars-hook
;;              #'+javascript-init-lsp-or-tide-maybe-h
;;              #'rjsx-minor-mode)
;;   (map! :map typescript-tsx-tree-sitter-mode-map
;;         "<" 'rjsx-electric-lt
;;         ">" 'rjsx-electric-gt))

;; (after! tree-sitter
;;   (add-to-list 'tree-sitter-major-mode-language-alist '(typescript-tsx-tree-sitter-mode . tsx)))

(setq global-tree-sitter-mode 1)

(defadvice! +lsp--create-filter-function (workspace)
  :override #'lsp--create-filter-function
  (let ((body-received 0)
        leftovers body-length body chunk)
    (lambda (_proc input)
      (setf chunk (if (s-blank? leftovers)
                      input
                    (concat leftovers input)))

      (let (messages)
        (while (not (s-blank? chunk))
          (if (not body-length)
              ;; Read headers
              (if-let ((body-sep-pos (string-match-p "\r\n\r\n" chunk)))
                  ;; We've got all the headers, handle them all at once:
                  (setf body-length (lsp--get-body-length
                                     (mapcar #'lsp--parse-header
                                             (split-string
                                              (substring-no-properties chunk
                                                                       (or (string-match-p "Content-Length" chunk)
                                                                           (error "Unable to find Content-Length header."))
                                                                       body-sep-pos)
                                              "\r\n")))
                        body-received 0
                        leftovers nil
                        chunk (substring-no-properties chunk (+ body-sep-pos 4)))

                ;; Haven't found the end of the headers yet. Save everything
                ;; for when the next chunk arrives and await further input.
                (setf leftovers chunk
                      chunk nil))
            (let* ((chunk-length (string-bytes chunk))
                   (left-to-receive (- body-length body-received))
                   (this-body (if (< left-to-receive chunk-length)
                                  (prog1 (substring-no-properties chunk 0 left-to-receive)
                                    (setf chunk (substring-no-properties chunk left-to-receive)))
                                (prog1 chunk
                                  (setf chunk nil))))
                   (body-bytes (string-bytes this-body)))
              (push this-body body)
              (setf body-received (+ body-received body-bytes))
              (when (>= chunk-length left-to-receive)
                (condition-case err
                    (with-temp-buffer
                      (apply #'insert
                             (nreverse
                              (prog1 body
                                (setf leftovers nil
                                      body-length nil
                                      body-received nil
                                      body nil))))
                      (decode-coding-region (point-min)
                                            (point-max)
                                            'utf-8)
                      (goto-char (point-min))
                      (while (search-forward "\\u0000" nil t)
                        (replace-match "" nil t))
                      (goto-char (point-min))
                      (push (lsp-json-read-buffer) messages))

                  (error
                   (lsp-warn "Failed to parse the following chunk:\n'''\n%s\n'''\nwith message %s"
                             (concat leftovers input)
                             err)))))))
        (mapc (lambda (msg)
                (lsp--parser-on-message msg workspace))
              (nreverse messages))))))


(global-centered-cursor-mode 1)

(setq ispell-dictionary "spanish")

(setq pixel-scroll-mode 1)

(setq lsp-enable-snippet nil)

(use-package! lsp-tailwindcss
  :init
  (setq lsp-tailwind-add-on-mode t))

(use-package org
  :config
  (add-to-list 'org-src-lang-modes '("dot" . "graphviz-dot"))

  (org-babel-do-load-languages 'org-babel-load-languages
                               '((shell      . t)
                                 (js         . t)
                                 (emacs-lisp . t)
                                 (perl       . t)
                                 (scala      . t)
                                 (clojure    . t)
                                 (python     . t)
                                 (ruby       . t)
                                 (dot        . t)
                                 (css        . t)
                                 (plantuml   . t))))

(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)

(use-package org
  :init
  (font-lock-add-keywords 'org-mode
   '(("^ +\\([-*]\\) "
          (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•")))))))

(setq org-babel-default-header-args
      (cons '(:results . "output")
            (assq-delete-all :results org-babel-default-header-args)))

(setq org-babel-default-header-args
      (cons '(:wrap . "quote")
            (assq-delete-all :wrap org-babel-default-header-args)))

(setq org-babel-default-header-args
      (cons '(:exports . "both")
            (assq-delete-all :exports org-babel-default-header-args)))

(cl-defmacro lsp-org-babel-enable (lang)
  "Support LANG in org source code block."
  (setq centaur-lsp 'lsp-mode)
  (cl-check-type lang stringp)
  (let* ((edit-pre (intern (format "org-babel-edit-prep:%s" lang)))
         (intern-pre (intern (format "lsp--%s" (symbol-name edit-pre)))))
    `(progn
       (defun ,intern-pre (info)
         (let ((file-name (->> info caddr (alist-get :file))))
           (unless file-name
             (setq file-name (make-temp-file "babel-lsp-")))
           (setq buffer-file-name file-name)
           (lsp-deferred)))
       (put ',intern-pre 'function-documentation
            (format "Enable lsp-mode in the buffer of org source block (%s)."
                    (upcase ,lang)))
       (if (fboundp ',edit-pre)
           (advice-add ',edit-pre :after ',intern-pre)
         (progn
           (defun ,edit-pre (info)
             (,intern-pre info))
           (put ',edit-pre 'function-documentation
                (format "Prepare local buffer environment for org source block (%s)."
                        (upcase ,lang))))))))
(defvar org-babel-lang-list '("go" "python" "ipython" "bash" "sh")) (dolist (lang org-babel-lang-list)
  (eval `(lsp-org-babel-enable ,lang)))




(setq truncate-string-ellipsis "…")




(setq which-key-idle-delay 0.5) ;; I need the help, I really do



(setq which-key-allow-multiple-replacements t)
(after! which-key
  (pushnew!
   which-key-replacement-alist
   '(("" . "\\`+?evil[-:]?\\(?:a-\\)?\\(.*\\)") . (nil . "◂\\1"))
   '(("\\`g s" . "\\`evilem--?motion-\\(.*\\)") . (nil . "◃\\1"))
   ))


(after! evil
  (setq evil-ex-substitute-global t     ; I like my s/../.. to by global by default
        evil-move-cursor-back nil       ; Don't move the block cursor when toggling insert mode
        evil-kill-on-visual-paste nil)) ; Don't put overwritten text in the kill ring

(setq-default history-length 1000)
(setq-default prescient-history-length 1000)

(use-package! screenshot
  :defer t
  :config (setq screenshot-upload-fn "upload %s 2>/dev/null"))

(setq yas-triggers-in-field t)

(use-package! info-colors
  :commands (info-colors-fontify-node))

(add-hook 'Info-selection-hook 'info-colors-fontify-node)



(defvar mixed-pitch-modes '(org-mode LaTeX-mode markdown-mode gfm-mode Info-mode)
  "Modes that `mixed-pitch-mode' should be enabled in, but only after UI initialisation.")
(defun init-mixed-pitch-h ()
  "Hook `mixed-pitch-mode' into each mode in `mixed-pitch-modes'.
Also immediately enables `mixed-pitch-modes' if currently in one of the modes."
  (when (memq major-mode mixed-pitch-modes)
    (mixed-pitch-mode 1))
  (dolist (hook mixed-pitch-modes)
    (add-hook (intern (concat (symbol-name hook) "-hook")) #'mixed-pitch-mode)))
(add-hook 'doom-init-ui-hook #'init-mixed-pitch-h)


(autoload #'mixed-pitch-serif-mode "mixed-pitch"
  "Change the default face of the current buffer to a serifed variable pitch, while keeping some faces fixed pitch." t)

(setq! variable-pitch-serif-font (font-spec :family "Alegreya" :size 27))

(after! mixed-pitch
  (setq mixed-pitch-set-height t)
  (set-face-attribute 'variable-pitch-serif nil :font variable-pitch-serif-font)
  (defun mixed-pitch-serif-mode (&optional arg)
    "Change the default face of the current buffer to a serifed variable pitch, while keeping some faces fixed pitch."
    (interactive)
    (let ((mixed-pitch-face 'variable-pitch-serif))
      (mixed-pitch-mode (or arg 'toggle)))))



(set-char-table-range composition-function-table ?f '(["\\(?:ff?[fijlt]\\)" 0 font-shape-gstring]))
(set-char-table-range composition-function-table ?T '(["\\(?:Th\\)" 0 font-shape-gstring]))


(defface variable-pitch-serif
    '((t (:family "serif")))
    "A variable-pitch face with serifs."
    :group 'basic-faces)

(defcustom variable-pitch-serif-font (font-spec :family "serif")
  "The font face used for `variable-pitch-serif'."
  :group 'basic-faces
  :set (lambda (symbol value)
         (set-face-attribute 'variable-pitch-serif nil :font value)
         (set-default-toplevel-value symbol value)))

;; (use-package! org-modern
;;   :hook (org-mode . org-modern-mode)
;;   :config
;;   (setq org-modern-star '("◉" "○" "✸" "✿" "✤" "✜" "◆" "▶")
;;         org-modern-table-vertical 1
;;         org-modern-table-horizontal 0.2
;;         org-modern-list '((43 . "➤")
;;                           (45 . "–")
;;                           (42 . "•"))
;;         org-modern-todo-faces
;;         '(("TODO" :inverse-video t :inherit org-todo)
;;           ("PROJ" :inverse-video t :inherit +org-todo-project)
;;           ("STRT" :inverse-video t :inherit +org-todo-active)
;;           ("[-]"  :inverse-video t :inherit +org-todo-active)
;;           ("HOLD" :inverse-video t :inherit +org-todo-onhold)
;;           ("WAIT" :inverse-video t :inherit +org-todo-onhold)
;;           ("[?]"  :inverse-video t :inherit +org-todo-onhold)
;;           ("KILL" :inverse-video t :inherit +org-todo-cancel)
;;           ("NO"   :inverse-video t :inherit +org-todo-cancel))
;;         org-modern-footnote
;;         (cons nil (cadr org-script-display))
;;         org-modern-block-fringe nil
;;         org-modern-block-name
;;         '((t . t)
;;           ("src" "»" "«")
;;           ("example" "»–" "–«")
;;           ("quote" "❝" "❞")
;;           ("export" "⏩" "⏪"))
;;         org-modern-progress nil
;;         org-modern-priority nil
;;         org-modern-horizontal-rule (make-string 36 ?─)
;;         org-modern-keyword
;;         '((t . t)
;;           ("title" . "𝙏")
;;           ("subtitle" . "𝙩")
;;           ("author" . "𝘼")
;;           ("email" . #("" 0 1 (display (raise -0.14))))
;;           ("date" . "𝘿")
;;           ("property" . "☸")
;;           ("options" . "⌥")
;;           ("startup" . "⏻")
;;           ("macro" . "𝓜")
;;           ("bind" . #("" 0 1 (display (raise -0.1))))
;;           ("bibliography" . "")
;;           ("print_bibliography" . #("" 0 1 (display (raise -0.1))))
;;           ("cite_export" . "⮭")
;;           ("print_glossary" . #("ᴬᶻ" 0 1 (display (raise -0.1))))
;;           ("glossary_sources" . #("" 0 1 (display (raise -0.14))))
;;           ("include" . "⇤")
;;           ("setupfile" . "⇚")
;;           ("html_head" . "🅷")
;;           ("html" . "🅗")
;;           ("latex_class" . "🄻")
;;           ("latex_class_options" . #("🄻" 1 2 (display (raise -0.14))))
;;           ("latex_header" . "🅻")
;;           ("latex_header_extra" . "🅻⁺")
;;           ("latex" . "🅛")
;;           ("beamer_theme" . "🄱")
;;           ("beamer_color_theme" . #("🄱" 1 2 (display (raise -0.12))))
;;           ("beamer_font_theme" . "🄱𝐀")
;;           ("beamer_header" . "🅱")
;;           ("beamer" . "🅑")
;;           ("attr_latex" . "🄛")
;;           ("attr_html" . "🄗")
;;           ("attr_org" . "⒪")
;;           ("call" . #("" 0 1 (display (raise -0.15))))
;;           ("name" . "⁍")
;;           ("header" . "›")
;;           ("caption" . "☰")
;;           ("results" . "🠶")))
;;   (custom-set-faces! '(org-modern-statistics :inherit org-checkbox-statistics-todo)))
