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
        { '<leader>f', group = 'Find' },
        { '<leader>s', group = 'Search', mode = { 'n', 'v' } },
        { '<leader>c', group = 'Code' },
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
      local sorters = require('telescope.sorters')
      local map = vim.keymap.set

      -- Score-bump sorter: same fuzzy file scoring, but adds a penalty to
      -- paths that look like test files so they sink to the bottom of
      -- results for the same query. Patterns cover Python (tests/, test_*.py),
      -- Go (*_test.go), JS/TS (*.test.ts, *.spec.ts), Rust (#[cfg(test)] is
      -- inline only, but tests/ subdir is conventional), and generic /test(s)/.
      local function test_aware_sorter()
        local fuzzy = sorters.get_fuzzy_file()
        return sorters.Sorter:new({
          scoring_function = function(_, prompt, line)
            local base = fuzzy.scoring_function(fuzzy, prompt, line)
            if base == -1 then return -1 end
            local is_test = line:match('^tests?/')
              or line:match('/tests?/')
              or line:match('/test_[^/]+$')
              or line:match('/[^/]+_test%.[^/]+$')
              or line:match('%.test%.[^/]+$')
              or line:match('%.spec%.[^/]+$')
            if is_test then return base + 1.0 end
            return base
          end,
          highlighter = function(_, prompt, display)
            return fuzzy.highlighter(fuzzy, prompt, display)
          end,
        })
      end

      -- Find prefix (the muscle-memory ones from NvChad)
      map('n', '<leader>ff', function()
        builtin.find_files({ sorter = test_aware_sorter() })
      end, { desc = 'find files (tests deprioritized)' })
      map('n', '<leader>fa', function()
        builtin.find_files({ hidden = true, no_ignore = true, sorter = test_aware_sorter() })
      end, { desc = 'find files (incl. hidden / ignored)' })
      map('n', '<leader>fw', builtin.live_grep,  { desc = 'find word (live grep)' })
      map('n', '<leader>fb', builtin.buffers,    { desc = 'find buffers' })
      map('n', '<leader>fo', builtin.oldfiles,   { desc = 'find old files' })
      map('n', '<leader>fh', builtin.help_tags,  { desc = 'find help tags' })
      map('n', '<leader>fc', builtin.commands,   { desc = 'find commands' })
      map('n', '<leader>fk', builtin.keymaps,    { desc = 'find keymaps' })
      map('n', '<leader>fz', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
          winblend = 10, previewer = false,
        }))
      end, { desc = 'fuzzy in current buffer' })

      -- Search prefix (kickstart-flavored, kept around)
      map('n', '<leader>ss', builtin.builtin,     { desc = 'pickers' })
      map({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = 'search current word' })
      map('n', '<leader>sd', builtin.diagnostics, { desc = 'diagnostics' })
      map('n', '<leader>sr', builtin.resume,      { desc = 'resume last picker' })
      map('n', '<leader>sn', function()
        builtin.find_files({ cwd = vim.fn.stdpath('config') })
      end, { desc = 'search nvim config' })

      map('n', '<leader><leader>', builtin.buffers, { desc = 'find buffer' })

      -- <leader>/ is mini.comment toggle (NvChad muscle memory).
      -- Use <leader>fz for fuzzy in current buffer.
    end,
  },

  -- Mini suite, but only the pieces we want. Statusline is owned by lualine.
  {
    'nvim-mini/mini.nvim',
    config = function()
      require('mini.ai').setup({ n_lines = 500 })
      require('mini.surround').setup()
      require('mini.comment').setup({
        mappings = {
          comment = '<leader>/',
          comment_line = '<leader>/',
          comment_visual = '<leader>/',
          textobject = '<leader>/',
        },
      })
    end,
  },

  -- Format-on-save for Python, Rust, TS/JS/JSON/Markdown.
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      { '<leader>cf', function() require('conform').format({ async = true, lsp_format = 'fallback' }) end, mode = '', desc = 'format buffer' },
      { '<leader>fm', function() require('conform').format({ async = true, lsp_format = 'fallback' }) end, mode = '', desc = 'format buffer (NvChad alias)' },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local enabled = {
          python = true, rust = true, go = true,
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
        go     = { 'goimports', 'gofumpt' },
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
