;; 1. Carrega o suporte básico do Guix
(let ((guix-env (expand-file-name "~/.guix-profile/share/emacs/site-lisp/guix-emacs.el")))
  (when (file-exists-p guix-env)
    (load guix-env)))

;; 2. A "MARRETA RECURSIVA" PARA LINKS SIMBÓLICOS
;; Como o seu ls mostrou pastas como magit-4.5.0@, vamos entrar em cada uma.
(let ((site-lisp-dir (expand-file-name "~/.guix-profile/share/emacs/site-lisp")))
  (when (file-directory-p site-lisp-dir)
    (dolist (dir (directory-files site-lisp-dir t))
      ;; Se for um diretório (ou link para um) e não for as pastas do sistema . ou ..
      (when (and (file-directory-p dir)
                 (not (member (file-name-nondirectory dir) '("." ".."))))
        (add-to-list 'load-path dir)
        ;; Força o Emacs a procurar arquivos .el dentro dessas pastas versionadas
        (let ((default-directory dir))
          (normal-top-level-add-subdirs-to-load-path))))))

;; 3. Inicializa os pacotes
(require 'package)
(setq package-enable-at-startup nil)
(package-initialize)

;; 4. Carrega seus arquivos de configuração
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(require 'setup-ui)
(require 'setup-scheme)
(require 'setup-programming)
(require 'setup-clojure)
