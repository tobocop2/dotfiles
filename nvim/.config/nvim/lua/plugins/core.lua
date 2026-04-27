-- Foundational plugins from kickstart.nvim, minus statusline/colorscheme
-- (those are owned by plugins/ui.lua so we can swap in lualine + base16).

return {
  -- Detect tab vs space automatically
  { 'NMAC427/guess-indent.nvim', opts = {} },

  -- Git change indicators in the sign column
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- Show pending keybinds in a popup after timeout
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },
      spec = {
        { '<leader>b', group = 'Buffer' },
        { '<leader>a', group = 'AI' },
        { '<leader>s', group = 'Search', mode = { 'n', 'v' } },
        { '<leader>d', group = 'Diagnostics' },
        { 'gr', group = 'LSP', mode = { 'n' } },
      },
    },
  },

  -- Highlight TODO / NOTE / FIX / etc. in comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  -- Fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function() return vim.fn.executable('make') == 1 end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup({
        extensions = {
          ['ui-select'] = { require('telescope.themes').get_dropdown() },
        },
      })

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require('telescope.builtin')
      local map = vim.keymap.set
      map('n', '<leader>sh', builtin.help_tags,   { desc = 'search help' })
      map('n', '<leader>sk', builtin.keymaps,     { desc = 'search keymaps' })
      map('n', '<leader>sf', builtin.find_files,  { desc = 'search files' })
      map('n', '<leader>ss', builtin.builtin,     { desc = 'search builtins' })
      map({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = 'search current word' })
      map('n', '<leader>sg', builtin.live_grep,   { desc = 'live grep' })
      map('n', '<leader>sd', builtin.diagnostics, { desc = 'search diagnostics' })
      map('n', '<leader>sr', builtin.resume,      { desc = 'resume last picker' })
      map('n', '<leader>s.', builtin.oldfiles,    { desc = 'recent files' })
      map('n', '<leader>sc', builtin.commands,    { desc = 'search commands' })
      map('n', '<leader><leader>', builtin.buffers, { desc = 'find buffer' })

      map('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
          winblend = 10, previewer = false,
        }))
      end, { desc = 'fuzzy in current buffer' })

      map('n', '<leader>sn', function()
        builtin.find_files({ cwd = vim.fn.stdpath('config') })
      end, { desc = 'search nvim config' })
    end,
  },

  -- Mini suite, but only the pieces we want. Statusline is owned by lualine.
  {
    'nvim-mini/mini.nvim',
    config = function()
      require('mini.ai').setup({ n_lines = 500 })
      require('mini.surround').setup()
    end,
  },

  -- Format-on-save for Python, Rust, TS/JS/JSON/Markdown.
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      { '<leader>f', function() require('conform').format({ async = true, lsp_format = 'fallback' }) end, mode = '', desc = 'format buffer' },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local enabled = {
          python = true, rust = true,
          javascript = true, javascriptreact = true,
          typescript = true, typescriptreact = true,
          json = true, jsonc = true, yaml = true,
          markdown = true,
          lua = true,
        }
        if enabled[vim.bo[bufnr].filetype] then
          return { timeout_ms = 1000, lsp_format = 'fallback' }
        end
      end,
      default_format_opts = { lsp_format = 'fallback' },
      formatters_by_ft = {
        python = { 'ruff_format', 'ruff_organize_imports' },
        rust   = { 'rustfmt' },
        lua    = { 'stylua' },
        javascript     = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        typescript     = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        json = { 'prettierd', 'prettier', stop_after_first = true },
        jsonc = { 'prettierd', 'prettier', stop_after_first = true },
        yaml = { 'prettierd', 'prettier', stop_after_first = true },
        markdown = { 'prettierd', 'prettier', stop_after_first = true },
      },
    },
  },
}
