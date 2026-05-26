;; --- Interface Básica ---
(setq inhibit-startup-screen t) ; Remove tela inicial
(menu-bar-mode -1)             ; Remove barra de menu
(tool-bar-mode -1)             ; Remove barra de ferramentas
(scroll-bar-mode -1)           ; Remove barra de rolagem
(show-paren-mode 1)            ; Destaca parênteses correspondentes (essencial para Lisp)
(column-number-mode 1)         ; Mostra o número da coluna na barra inferior

;; --- IBuffer (O melhor visualizador de buffers) ---
(global-set-key (kbd "C-x C-b") 'ibuffer) ; Substitui o list-buffers padrão
(setq ibuffer-expert t)                   ; Não pede confirmação para fechar buffers

;; Organização automática por categorias
(setq ibuffer-saved-filter-groups
      '(("default"
         ("Scheme/Lisp" (or (mode . scheme-mode)
                            (mode . emacs-lisp-mode)
                            (mode . lisp-mode)))
         ("Desenvolvimento" (or (mode . c-mode)
                                (mode . lua-mode)
                                (mode . elixir-mode)))
         ("Configuração" (filename . ".emacs.d"))
         ("Magit" (name . "^magit"))
         ("Documentação" (or (mode . help-mode)
                             (mode . info-mode))))))

;; Ativa os grupos por padrão
(add-hook 'ibuffer-mode-hook
          (lambda ()
            (ibuffer-switch-to-saved-filter-groups "default")))

;; --- Estética ---
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

;; 1. BUSCA EXAUSTIVA DE TEMAS NO GUIX
;; O Guix coloca temas em site-lisp/elpa/doom-themes-xxx/
(let ((site-lisp "~/.guix-profile/share/emacs/site-lisp"))
  (when (file-directory-p site-lisp)
    (add-to-list 'custom-theme-load-path site-lisp)
    ;; Procura dentro da pasta elpa que o Guix cria
    (let ((elpa-dir (expand-file-name "elpa" site-lisp)))
      (when (file-directory-p elpa-dir)
        (dolist (dir (directory-files elpa-dir t))
          (when (and (file-directory-p dir) (string-match-p "doom-themes" dir))
            (add-to-list 'custom-theme-load-path dir)))))))

;; 2. FUNÇÃO DE CARREGAMENTO SEGURO
(defun my/apply-theme ()
  (setq custom-safe-themes t)
  ;; Se o doom-one falhar, tenta o tema nativo tango-dark para não ficar branco
  (condition-case nil
      (load-theme 'doom-one t)
    (error (load-theme 'tango-dark t)))

  ;; Transparência
  (add-to-list 'default-frame-alist '(alpha-background . 85))
  (set-frame-parameter nil 'alpha-background 85))

;; 3. O PULO DO GATO: Carrega o tema após o Emacs estar pronto
(if (daemonp)
    (add-hook 'after-make-frame-functions (lambda (f) (with-selected-frame f (my/apply-theme))))
  (add-hook 'window-setup-hook #'my/apply-theme))

(provide 'setup-ui)
