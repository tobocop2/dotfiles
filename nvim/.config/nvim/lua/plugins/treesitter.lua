-- Treesitter on the classic `master` branch API (compatible with nvim 0.10+).
-- The `main` branch needs nvim 0.12; switch when Neovim catches up.

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    lazy = false,
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = {
        'bash', 'c', 'diff', 'html', 'lua', 'luadoc',
        'markdown', 'markdown_inline', 'query',
        'toml', 'vim', 'vimdoc', 'yaml',
        'python',
        'rust',
        'go', 'gomod', 'gosum', 'gowork',
        'javascript', 'typescript', 'tsx',
        'json', 'jsonc',
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },
}
