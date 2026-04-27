-- Visual layer: colorscheme, statusline, file tree, markdown rendering.

return {
  -- Base16 colorschemes; we pick `base16-tomorrow-night` from init.lua
  {
    'RRethy/nvim-base16',
    priority = 1000,
    lazy = false,
  },

  -- Statusline. Replaces kickstart's mini.statusline.
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = 'VimEnter',
    opts = {
      options = {
        theme = 'base16',
        icons_enabled = vim.g.have_nerd_font,
        section_separators = '',
        component_separators = '|',
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
    },
  },

  -- Buffer tabs at the top.
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = 'VimEnter',
    opts = {
      options = {
        mode = 'buffers',
        diagnostics = 'nvim_lsp',
        show_buffer_close_icons = true,
        show_close_icon = false,
        separator_style = 'thin',
        offsets = {
          {
            filetype = 'NvimTree',
            text = 'Files',
            highlight = 'Directory',
            text_align = 'left',
          },
        },
      },
    },
  },

  -- File tree
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cmd = { 'NvimTreeFocus', 'NvimTreeFindFile', 'NvimTreeClose', 'NvimTreeToggle' },
    opts = {
      view = { width = 40 },
      renderer = { group_empty = true },
      filters = { dotfiles = false },
      git = { enable = true },
      update_focused_file = { enable = true },
    },
  },

  -- Markdown preview rendered inside the buffer
  {
    'OXY2DEV/markview.nvim',
    lazy = false,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      preview = {
        modes = { 'n', 'no', 'c' },
        hybrid_modes = { 'n' },
      },
    },
  },
}
