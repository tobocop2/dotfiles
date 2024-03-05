

-- -----------------------------------------------------------------------------------------------
-- General configuration
-- -----------------------------------------------------------------------------------------------
-- Basic settings
vim.opt.hlsearch = true
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.spelllang = "en_gb"
vim.opt.swapfile = false

-- use nvim-tree instead
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Use system clipboard
vim.opt.clipboard = "unnamed"

-- Display settings
vim.opt.termguicolors = true
vim.opt.background = "light"

-- scroll a bit extra horizontally and vertically when at the end/bottom
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.wrap = false

-- Title
vim.opt.title = true -- set the title of window to the value of the titlestring
vim.opt.titlestring = "%<%F%=%l/%L - nvim" -- what the title of the window will be set to

-- Persist undo
vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"
vim.opt.undofile = true

-- Tab stuff
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true

-- Search configuration
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.gdefault = true

-- scroll a bit extra horizontally and vertically when at the end/bottom
vim.opt.sidescrolloff = 8
vim.opt.scrolloff = 8

-- open new split panes to right and below (as you probably expect)
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Highlight trailing characters
vim.opt.listchars = {
	-- eol = "↲",
	tab = "▸ ",
	trail = "·",
}
vim.opt.list = true

-- -----------------------------------------------------------------------------------------------
-- Keymap settings
-- -----------------------------------------------------------------------------------------------
-- Basic keys
vim.g.mapleader = ","
vim.keymap.set("n", "<space>", ":")
vim.keymap.set("n", "<leader>ec", ":e $MYVIMRC<CR>")

-- Easier redo
-- vim.keymap.set("n", "q", "<C-r>")

-- Search navigation
-- n is always forward, N is always backward
-- ' is now forward and ; is backward
vim.keymap.set("n", "n", "v:searchforward ? 'n' : 'N'", { expr = true })
vim.keymap.set("n", "N", "v:searchforward ? 'N' : 'n'", { expr = true })
vim.keymap.set("n", ";", "getcharsearch().forward ? ',' : ';'", { expr = true })
vim.keymap.set("n", "'", "getcharsearch().forward ? ';' : ','", { expr = true })

-- Search and Replace
vim.keymap.set("n", "<leader>h", ":%s/")
vim.keymap.set("n", "<leader>l", ":nohlsearch<CR><C-L>")

-- nvim-tree
vim.keymap.set("n", "<C-t>", ":NvimTreeFocus<CR>")
vim.keymap.set("n", "<C-f>", ":NvimTreeFindFile<CR>")
vim.keymap.set("n", "<C-c>", ":NvimTreeClose<CR>")

-- toggle line numbers and wrap
vim.keymap.set("n", "<leader>n", ":set nonumber! relativenumber!<CR>")
vim.keymap.set("n", "<leader>w", ":set wrap! wrap?<CR>")

-- Moving between splits and resizing
vim.keymap.set("n", "<C-j>", "<C-W><C-J>")
vim.keymap.set("n", "<C-k>", "<C-W><C-K>")
vim.keymap.set("n", "<C-l>", "<C-W><C-L>")
vim.keymap.set("n", "<C-H>", "<C-W><C-H>")
vim.keymap.set("n", "<C-w>k", ":resize +15<CR>")
vim.keymap.set("n", "<C-w>j", ":resize -15<CR>")
vim.keymap.set("n", "<C-w>h", ":vertical:resize -15<CR>")
vim.keymap.set("n", "<C-w>l", ":vertical:resize +15<CR>")


-- Close the current buffer
vim.keymap.set("n", "<leader>bd", ":Bclose<cr>")

-- Close all the buffers
vim.keymap.set("n", "<leader>ba", ":bufdo bd<cr>")

--  Go to last accessed buffer
vim.keymap.set("n", "<leader>bl", ":b#<cr>")

vim.keymap.set("n", "<leader>bn", ":bnext<cr>")
vim.keymap.set("n", "<leader>bp", ":bprevious<cr>")

-- Go to buffer by name or number
vim.keymap.set("n", "<leader>bb", ":b<Space>")

-- List all buffers and provide quick way to open new buffer
vim.keymap.set("n", "<leader>lsb", ":buffers<CR>:buffer<Space>")

-- List all buffers and provide quick way to vertically split new buffer
vim.keymap.set("n", "<leader>lsv", ":buffers<CR>:vert sb<Space>")

-- List all buffers and provide quick way to easily delete buffer
vim.keymap.set("n",  "<leader>lsd", ":buffers<CR>:bd<Space>")

-- Vertically split by name or number
vim.keymap.set("n", "<leader>vs", ":vert sb<Space>")


vim.keymap.set("n", "<leader>be", ':e <c-r>=expand("%:p:h")<cr>/')

vim.keymap.set("n", "<leader>ve", ':vsp <c-r>=expand("%:p:h")<cr>/')

-- Switch CWD to the directory of the open buffer
vim.keymap.set("n", "<leader>cd", ':cd %:p:h<cr>:pwd<cr>')

-- Remove file open in current buffer from the filesystem.
vim.keymap.set("n", "<leader>rm", "!rm -f %:p:r %")
