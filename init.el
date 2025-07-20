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
(unless package-archive-contents
  (package-refresh-contents))

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
  :mode ("\\.tsx\\'" "\\.jsx\\'" "\\.js\\'" "\\.ts\\'")
  :hook ((web-mode . prettier-js-mode))
  :config
  (setq web-mode-enable-auto-quoting nil)
  (setq web-mode-content-types-alist
        '(("jsx" . "\\.js[x]?\\'") ("tsx" . "\\.ts[x]?\\'"))))

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

(provide 'init)
;;; init.el ends here
