-- Editor settings. Read top-to-bottom; each block has one purpose.

-- Display
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.wrap = false
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true
vim.opt.showmode = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.list = true
vim.opt.listchars = { tab = '▸ ', trail = '·', nbsp = '␣' }

-- Window title shows current file and line count
vim.opt.title = true
vim.opt.titlestring = '%<%F%=%l/%L - nvim'

-- Behavior
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamed'
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath('cache') .. '/undo'
vim.opt.spelllang = 'en_gb'
vim.opt.confirm = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.breakindent = true

-- Search
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.gdefault = true

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Decision view
vim.opt.inccommand = 'split'

-- Disable netrw in favor of nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
