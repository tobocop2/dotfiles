# dotfiles

My personal configuration for nvim, tmux, zsh, and git.

The Makefile uses [GNU Stow](https://www.gnu.org/software/stow/) to symlink each
top-level subdirectory into `$HOME` so the configs live here in the repo and
are tracked in git, while the tools find them at their expected paths.

## Layout

```
dotfiles/
├── nvim/    Neovim — kickstart-derived modular config
├── tmux/    tmux (with TPM, vim-tmux-navigator, catppuccin)
├── zsh/     zsh with custom aliases and prompts
└── git/     git config
```

## Install

```sh
make
```

This clones [TPM](https://github.com/tmux-plugins/tpm) for tmux plugin
management, then runs `stow` for every top-level subdirectory. After it
finishes, every config file lives in this repo and `$HOME` holds symlinks
into it.

## Neovim

The Neovim config is a kickstart.nvim-derived setup split into focused modules
(`init.lua` plus `lua/{options,keymaps,autocmds}.lua` and
`lua/plugins/{core,lsp,treesitter,ui,navigation,ai}.lua`).

Out of the box: lazy.nvim plugin manager, nvim-lspconfig + Mason, treesitter,
telescope, blink.cmp, gitsigns, which-key, lualine, bufferline, nvim-tree,
markview. Language support for Python, Rust, TypeScript, and Go installs on
first launch via Mason. Format-on-save is wired for each.

### AI integration

Inline AI assistance via [CodeCompanion](https://github.com/olimorris/codecompanion.nvim)
with two adapters:

- **Anthropic** (default for chat and inline). The API key is resolved from a
  secret manager: macOS Keychain first, then `pass` as a fallback. No plaintext
  key in shell rc files.
- **Ollama** (for local models like `qwen3-coder`, `mistral`). Talks to whatever
  is on `OLLAMA_HOST`, defaulting to `localhost:11434`.

Store the Anthropic key once before launching nvim:

```sh
security add-generic-password -a "$USER" -s anthropic_api_key -U -w "<key>"
# or
pass insert anthropic/api_key
```

For local models:

```sh
ollama pull qwen3-coder
```

To switch models inside a chat, edit the `model` field in the chat header. List
installed Ollama models with `curl localhost:11434/api/tags`.

Keymaps inside nvim:

| Key | Action |
|---|---|
| `,ac` | Toggle Claude chat |
| `,ao` | New Ollama chat |
| `,ae` | Send visual selection to chat |
| `,aa` | CodeCompanion action menu |

## tmux

Configured with TPM and the standard plugin set: tmux-resurrect, tmux-yank,
tmux-sensible, vim-tmux-navigator, catppuccin theme. Prefix is the default
`<C-b>`. `<C-h/j/k/l>` moves between nvim splits and tmux panes seamlessly.
