# emacs-config
Configuração pessoal do Emacs

Este repositório contém minha configuração do Emacs focada em:

- ✅ React Native com TypeScript, TSX, JSX
- ✅ Go com suporte completo a LSP
- ✅ Navegação moderna com Vertico + Consult + Project.el
- ✅ Linting, autocomplete, formatação automática
- ✅ EAF para PDF e Navegador embutido

## Pacotes

- `lsp-mode`, `lsp-ui`, `company`, `flycheck`, `go-mode`, `typescript-mode`
- `web-mode`, `prettier-js`, `project.el`, `consult`, `vertico`, `marginalia`
- `tree-sitter`, `magit`, `eaf`

## Requisitos

Instalar:

```bash
npm install -g typescript typescript-language-server eslint prettier
go install golang.org/x/tools/gopls@latest
go install golang.org/x/tools/cmd/goimports@latest

