(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(diary-date-forms
   '((day "/" month "[^/0-9]")
     (day "/" month "/" year "[^0-9]")
     (day " *" monthname "[^,0-9]")
     (day " *" monthname ", *" year "[^0-9]")
     (dayname "\\W")))
 '(ispell-alternate-dictionary "/home/fede/COMMON.TXT")
 '(lsp-tailwindcss-major-modes '(css-mode))
 '(org-extend-today-until 4)
 '(org-journal-date-format "%A, %d %B %Y")
 '(org-journal-file-type 'weekly)
 '(package-selected-packages '(mixed-pitch lsp-tailwindcss)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ts-fold-replacement-face ((t (:foreground nil :box nil :inherit font-lock-comment-face :weight light)))))
