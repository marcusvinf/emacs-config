;;; init.el --- Configuração do Emacs -*- lexical-binding: t; -*-
;;
;;; Commentary:
;; Este arquivo configura o Emacs com pacotes essenciais e melhorias.
;;
;;; Code:

(require 'package)
;;; init.el --- Configuração do Emacs -*- lexical-binding: t; -*-

;; Adiciona os repositórios MELPA, GNU ELPA e MELPA Stable
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu"   . "https://elpa.gnu.org/packages/")
        ("melpa-stable" . "https://stable.melpa.org/packages/")))

(package-initialize)

;; Garante que o conteúdo dos pacotes está atualizado
(unless package-archive-contents
  (package-refresh-contents))

;; Instala e ativa o use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t) ;; <-- essa linha garante instalação automática em todosp

;; Magit (Interface para Git)
(use-package magit
  :ensure t
  :bind(("C-x g" . magit-status)))

;; Ctrl + Shift + K do vscode
(defun delete-line-and-move-to-beginning ()
  "Delete the current line without copying it to the `kill-ring'.
Moves the cursor to the beginning of the next line and reindents."
  (interactive)
  (delete-region (line-beginning-position) (line-beginning-position 2))
  (indent-according-to-mode))

;; Cria diretório base de backup
(defvar my/backup-root-dir "~/.emacs.d/backups/")
(make-directory my/backup-root-dir t)

(defun my/backup-file-name (file)
  "Gera um caminho de backup baseado na estrutura original do FILE."
  (let* ((backup-file (expand-file-name file))
         (backup-path (concat my/backup-root-dir backup-file))
         (backup-dir (file-name-directory backup-path)))
    (make-directory backup-dir t)
    (concat backup-path "~")))

;; Configurações de backup
(setq make-backup-files t
      backup-by-copying t
      version-control t
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      backup-directory-alist `(("." . ,my/backup-root-dir)))

;; Override da função de nome de backup
(advice-add 'make-backup-file-name :override #'my/backup-file-name)

;;emacs-eaf

(add-to-list 'load-path "~/.emacs.d/site-lisp/emacs-application-framework/")
(require 'eaf)
(setq-default eaf-python-command "~/.eaf-venv/bin/python3")

(require 'eaf-browser)
(require 'eaf-pdf-viewer)

;; Flycheck (Linter)
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))
;;ripgrep
(use-package rg
  :ensure t
  :config
  (global-set-key (kbd "C-c s") 'counsel-rg)
  (rg-enable-default-bindings))

(setq project-find-functions '(project-try-vc)) ;;

;; Project.el (Gerenciamento de Projetos)
(use-package project
  :ensure t
  :bind (("C-x p f" . project-find-file)
         ("C-x p s" . project-shell)
         ("C-x p b" . project-list-buffers)
         ("C-x p k" . project-kill-buffers)
         ("C-x p g" . project-find-regexp)
         ("C-x p r" . project-query-replace-regexp)))
(setq project-list-file "~/Documentos/projects")
;; Interface moderna de minibuffer: vertico + consult + marginalia
(use-package vertico
  :ensure t
  :init
  (vertico-mode 1)) ;; Ativa vertico

(use-package orderless
  :ensure t
  :init
  (setq completion-styles '(orderless)))

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

(use-package consult
  :ensure t
  :bind (
         ;; Busca no buffer atual
         ("C-s" . consult-line)
         ;; Busca em todos arquivos do projeto (usa ripgrep)
         ("C-M-s" . consult-ripgrep)
         ;; Buscar arquivo no projeto
         ("C-x p f" . consult-project-buffer)
         ;; Alternar entre buffers
         ("C-x b" . consult-buffer)
         ;; Buscar e trocar entre arquivos abertos recentemente
         ("C-x C-r" . consult-recent-file)
         ;; Buscar por símbolo no buffer atual
         ("M-s l" . consult-line-symbol-at-point)))

;; Opcional: integração com project.el
(setq consult-project-function #'consult--default-project-function)
(setq consult-ripgrep-args
      "rg --null --line-buffered --color=never --max-columns=1000 --path-separator / --smart-case --no-heading --line-number .")

;;Syntax
;; Ativar syntax highlighting
(global-font-lock-mode 1)

(use-package lsp-mode
  :ensure t
  :init
  ;; Prefixo para comandos LSP
  (setq lsp-completion-provider :capf
        lsp-eldoc-render-all t)
  (setq lsp-keymap-prefix "C-c l")

  ;; Caminho para o servidor Lua (já estava certo)
  (setq lsp-clients-lua-language-server-bin "/home/marcus-souza/Documentos/anotations-and-mine/lua-language-server-3.13.6-linux-x64/bin/lua-language-server")

  ;; Desativa alguns recursos pesados se quiser leveza
  (setq lsp-enable-symbol-highlighting t
        lsp-enable-on-type-formatting nil
        lsp-modeline-code-actions-enable t
        lsp-headerline-breadcrumb-enable t)

  ;; Para arquivos grandes ou projetos pesados:
  (setq lsp-idle-delay 0.500
        lsp-log-io nil)

  :hook ((php-mode . lsp)
         (lua-mode . lsp)
         (go-mode . lsp)
         (web-mode . lsp)
         (typescript-mode . lsp)
         (js-mode . lsp))
  :commands lsp)

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns x))
  :ensure t
  :config
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-envs '("PATH" "GOPATH" "GOROOT")))

(use-package php-mode
  :ensure t
  :mode "\\.php\\'"
  :config
  (setq php-mode-coding-style 'psr2)) ;; Estilo PSR-2 para PHP

(use-package lua-mode
  :ensure t
  :mode "\\.lua\\'"
  :interpreter "lua")

;; Tree-sitter para linguagens modernas
(use-package tree-sitter
  :ensure t
  :config
  (global-tree-sitter-mode)
  (add-to-list 'tree-sitter-major-mode-language-alist '(php-mode . php)))

(use-package tree-sitter-langs
  :ensure t)

;; Melhorar o highlighting
(use-package highlight-numbers
  :ensure t
  :hook (prog-mode . highlight-numbers-mode))

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package hl-todo
  :ensure t
  :hook (prog-mode . hl-todo-mode))

(use-package typescript-mode
  :ensure t
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp))

;; Pacote para melhor integração com LSP
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-position 'bottom
        lsp-ui-sideline-enable t
        lsp-ui-sideline-show-diagnostics t
        lsp-ui-sideline-show-hover t))

(use-package web-mode
  :ensure t
  :mode ("\\.tsx\\'" "\\.jsx\\'" "\\.js\\'" "\\.ts\\'")
  :hook ((web-mode . prettier-js-mode))
  :config
  (setq web-mode-enable-auto-pairing t
        web-mode-enable-auto-closing t
        web-mode-enable-auto-quoting nil ; evita conflito no JSX
        web-mode-enable-auto-opening t
        web-mode-enable-auto-expanding t
        web-mode-enable-auto-close-style 2 ;; <div> -> </div>
        web-mode-enable-current-element-highlight t)

  (setq web-mode-content-types-alist
        '(("jsx" . "\\.js[x]?\\'") ("tsx" . "\\.ts[x]?\\'")))

  (add-hook 'web-mode-hook
            (lambda ()
              (when (or (string-suffix-p ".tsx" buffer-file-name)
                        (string-suffix-p ".jsx" buffer-file-name))
                (setq-local web-mode-enable-auto-closing t)
                (setq-local web-mode-enable-auto-close-style 2)
                (setq-local web-mode-enable-auto-pairing t)
                (lsp)))))

(use-package prettier-js
  :hook ((js-mode . prettier-js-mode)
         (web-mode . prettier-js-mode)
         (typescript-mode . prettier-js-mode)))

(use-package go-mode
  :ensure t
  :mode "\\.go\\'"
  :hook ((go-mode . lsp)
         (before-save . lsp-format-buffer)
         (before-save . lsp-organize-imports))
  :config
  (setq gofmt-command "goimports"))

;; Pacote para autocompletar
(use-package company
  :ensure t
  :hook (lsp-mode . company-mode)
  :config
  (setq company-minimum-prefix-length 1
        company-idle-delay 0.0)) ;; sem delay para autocompletar

;; Global set
(global-set-key (kbd "C-S-k") 'delete-line-and-move-to-beginning)

(electric-pair-mode 1)
(setq electric-pair-pairs
      '((?\{ . ?\})
        (?\( . ?\))
        (?\[ . ?\])
        (?\" . ?\")
        (?\` . ?\`)
        (?\< . ?\>)))  ;; inclui < e >


(provide 'init)
;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(vertico-posframe prettier-js go-mode web-mode lsp-ui typescript-mode hl-todo rainbow-delimiters highlight-numbers tree-sitter-langs tree-sitter lua-mode php-mode exec-path-from-shell lsp-mode consult marginalia orderless rg which-key projectile pos-tip org-modern org-kanban org-bullets magit flycheck dash-functional danneskjold-theme counsel company async all-the-icons ag)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
