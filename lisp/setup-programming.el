;; Tenta carregar o Magit de forma segura
(if (require 'magit nil 'noerror)
    (global-set-key (kbd "C-x g") 'magit-status)
  (message "Aviso: Magit não encontrado"))

;; Tenta carregar flycheck de forma segura
(if (require 'flycheck nil 'noerror)
    (add-hook 'after-init-hook #'global-flycheck-mode)
  (message "Aviso: Flycheck não encontrado no load-path"))

;; Configuração C
(setq-default c-basic-offset 4)

;; Lua Mode
(if (require 'lua-mode nil 'noerror)
    (add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode)))

;; --- Configuração de Projetos (Project.el) ---

;; Garante que o project.el use o diretório atual como base
(setq project-vc-merge-submodules nil)

;; Opcional: Se quiser que o C-x p f ignore arquivos que o Git ignora
(setq project-read-file-name-function 'project--read-file-cp)

;; Integração com o IBuffer: organiza buffers por projeto automaticamente!
(add-hook 'ibuffer-mode-hook
          (lambda ()
            (setq ibuffer-filter-groups
                  (append (ibuffer-project-generate-filter-groups)
                          ibuffer-filter-groups))
            (ibuffer-update nil t)))

(provide 'setup-programming)
