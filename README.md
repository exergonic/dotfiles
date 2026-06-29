# dotfiles

Personal configuration files for my development environment.

## Contents

| Directory   | What                                   |
|-------------|----------------------------------------|
| `nvim/`     | Neovim config (lazy.nvim, Mason, LSP) |
| `zsh/`      | Zsh rc files and host-specific configs |
| `bash/`     | Bash rc files (legacy)                 |
| `shell/`    | Shared aliases and functions           |
| `tmux/`     | Tmux configuration                     |
| `powershell/` | PowerShell 7 profile                    |
| `wezterm/`  | WezTerm terminal configuration         |
| `emacs/`    | Emacs configuration                    |
| `vim/`      | Legacy Vim configuration               |
| `firefox/`  | Firefox userChrome customization       |

## Usage

```sh
git clone git@github.com:exergonic/dotfiles ~/.dotfiles
```

### Zsh

Sources `shell/aliases`, `shell/functions`, and `zsh/zshrc.$HOST` automatically.
Requires [Starship](https://starship.rs) prompt (falls back to minimal prompt otherwise).

### Neovim

Plugins managed by [lazy.nvim](https://github.com/folke/lazy.nvim).
- `nvim-treesitter` for syntax highlighting and indentation
- `mason.nvim` + `nvim-lspconfig` for LSP (pyright, ruff)
- `nvim-cmp` for autocompletion
- `neo-tree.nvim` for file explorer
- `nvim-tmux-navigation` for seamless pane movement
