;; Configuração para Scheme (Geiser)
(setq geiser-active-implementations '(guile))

;; Ativa o Paredit apenas se ele for encontrado
(if (fboundp 'enable-paredit-mode)
    (progn
      (add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)
      (add-hook 'scheme-mode-hook     #'enable-paredit-mode)
      (add-hook 'lisp-mode-hook       #'enable-paredit-mode))
  ;; Se não encontrar a função, tenta carregar o arquivo primeiro
  (when (require 'paredit nil 'noerror)
    (add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)
    (add-hook 'scheme-mode-hook     #'enable-paredit-mode)
    (add-hook 'lisp-mode-hook       #'enable-paredit-mode)))

(provide 'setup-scheme)
