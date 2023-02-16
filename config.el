;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

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
(setq  doom-font (font-spec :family "FiraCode Nerd Font" :size 16 :weight 'normal))

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







(use-package! tree-sitter
  :when (bound-and-true-p module-file-suffix)
  :hook (prog-mode . tree-sitter-mode)
  :hook (tree-sitter-after-on . tree-sitter-hl-mode)
  :config
  (require 'tree-sitter-langs)
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)
  (defadvice! doom-tree-sitter-fail-gracefully-a (orig-fn &rest args)
    "Don't break with errors when current major mode lacks tree-sitter support."
    :around #'tree-sitter-mode
    (condition-case e
        (apply orig-fn args)
      (error
       (unless (string-match-p (concat "^Cannot find shared library\\|"
                                       "^No language registered\\|"
                                       "cannot open shared object file")
                               (error-message-string e))
         (signal (car e) (cadr e)))))))

(use-package! typescript-mode
  :mode ("\\.tsx\\'" . typescript-tsx-tree-sitter-mode)
  :config
  (setq typescript-indent-level 2)

  (define-derived-mode typescript-tsx-tree-sitter-mode typescript-mode "TypeScript TSX"
    (setq-local indent-line-function 'rjsx-indent-line))

  (add-hook! 'typescript-tsx-tree-sitter-mode-local-vars-hook
             #'+javascript-init-lsp-or-tide-maybe-h
             #'rjsx-minor-mode)
  (map! :map typescript-tsx-tree-sitter-mode-map
        "<" 'rjsx-electric-lt
        ">" 'rjsx-electric-gt))

(after! tree-sitter
  (add-to-list 'tree-sitter-major-mode-language-alist '(typescript-tsx-tree-sitter-mode . tsx)))

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
