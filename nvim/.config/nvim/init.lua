-- Entry point. Order matters:
--   1. Set leader before loading any plugin or keymap.
--   2. Load options and keymaps so they apply during plugin setup.
--   3. Bootstrap lazy.nvim, then declare specs via `lua/plugins/*.lua`.
--   4. Apply colorscheme after lazy has installed/loaded it.

vim.g.mapleader = ','
vim.g.maplocalleader = ','
vim.g.have_nerd_font = true

require('options')
require('keymaps')
require('autocmds')

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  { import = 'plugins' },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘', config = '🛠', event = '📅', ft = '📂', init = '⚙',
      keys = '🗝', plugin = '🔌', runtime = '💻', require = '🌙',
      source = '📄', start = '🚀', task = '📌', lazy = '💤 ',
    },
  },
})

pcall(vim.cmd.colorscheme, 'base16-tomorrow-night')
