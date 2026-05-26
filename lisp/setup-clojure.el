;; === Configuração de Clojure + CIDER ===

;; Força o lein a usar Java 21 (o Java 25 do Guix quebra o orchard/cider-nrepl)
(let ((java21 "/usr/lib/jvm/java-21-openjdk-amd64/bin/java"))
  (when (file-executable-p java21)
    (setenv "LEIN_JAVA_CMD" java21)
    (setenv "JAVA_HOME" "/usr/lib/jvm/java-21-openjdk-amd64")))

;; --- clojure-mode ---
(when (require 'clojure-mode nil 'noerror)

  ;; Paredit em todos os buffers Clojure
  (when (fboundp 'enable-paredit-mode)
    (add-hook 'clojure-mode-hook       #'enable-paredit-mode)
    (add-hook 'clojurescript-mode-hook #'enable-paredit-mode)
    (add-hook 'clojurec-mode-hook      #'enable-paredit-mode)
    (add-hook 'cider-repl-mode-hook    #'enable-paredit-mode))

  ;; Rainbow delimiters (opcional, instale emacs-rainbow-delimiters via Guix)
  (when (require 'rainbow-delimiters nil 'noerror)
    (add-hook 'clojure-mode-hook       #'rainbow-delimiters-mode)
    (add-hook 'cider-repl-mode-hook    #'rainbow-delimiters-mode))

  ;; Indentação correta para macros comuns do Clojure
  (define-clojure-indent
    (defroutes 'defun)
    (GET 2) (POST 2) (PUT 2) (DELETE 2) (HEAD 2) (ANY 2)
    (context 'defun)))

;; --- CIDER ---
(when (require 'cider nil 'noerror)

  ;; REPL: prefere não abrir em janela separada ao lado do código
  (setq cider-repl-pop-to-buffer-on-connect 'display-only)

  ;; Histórico do REPL persiste entre sessões
  (setq cider-repl-history-file (expand-file-name ".cider-history" user-emacs-directory))
  (setq cider-repl-history-size 1000)

  ;; Pretty-print padrão
  (setq cider-repl-use-pretty-printing t)

  ;; Mostra resultados inline (eldoc style)
  (setq cider-show-error-buffer 'only-in-repl)

  ;; Ativa eldoc (documentação inline)
  (add-hook 'cider-mode-hook      #'eldoc-mode)
  (add-hook 'cider-repl-mode-hook #'eldoc-mode)

  ;; Atalhos extras úteis
  ;; C-c C-k  → compila o buffer inteiro
  ;; C-c C-e  → avalia expressão antes do cursor
  ;; C-c C-z  → vai para o REPL
  ;; C-c M-j  → abre o REPL (cider-jack-in)
  ;; C-c C-d d → documentação do símbolo
  ;; M-.       → vai para definição
  ;; M-,       → volta

  (message "CIDER carregado com sucesso!"))

(provide 'setup-clojure)
