-- Global keymaps. LSP-attach keymaps live in plugins/lsp.lua.
local map = vim.keymap.set

-- Quick command-line access
map('n', '<space>', ':')
map('n', '<leader>ec', ':e $MYVIMRC<CR>', { desc = 'edit init.lua' })

-- Search and replace helpers
map('n', '<leader>h', ':%s/', { desc = 'substitute in file' })
map('n', '<leader>l', ':nohlsearch<CR><C-L>', { desc = 'clear highlight + redraw' })
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Search nav: n always forward, N always backward, even after `?`
map('n', 'n', "v:searchforward ? 'nzzzv' : 'Nzzzv'", { expr = true, desc = 'next match (centered)' })
map('n', 'N', "v:searchforward ? 'Nzzzv' : 'nzzzv'", { expr = true, desc = 'prev match (centered)' })

-- Char-search swap: ; goes backward, ' goes forward (mirroring n/N)
map('n', ';', "getcharsearch().forward ? ',' : ';'", { expr = true })
map('n', "'", "getcharsearch().forward ? ';' : ','", { expr = true })

-- Centered scrolling
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')

-- Move selected lines up/down in visual mode
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'move selection down' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'move selection up' })

-- Paste over selection without overwriting the unnamed register
map('x', '<leader>p', '"_dP', { desc = 'paste keeping yank' })

-- Toggle line numbers and wrap
map('n', '<leader>n', ':set nonumber! relativenumber!<CR>', { desc = 'toggle line numbers' })
map('n', '<leader>w', ':set wrap! wrap?<CR>', { desc = 'toggle wrap' })

-- Save and quit (NvChad-style ergonomics)
map({ 'n', 'i', 'v' }, '<C-s>', '<Esc><cmd>w<CR>', { desc = 'save file' })
map('n', '<leader>q', '<cmd>close<CR>', { desc = 'close current window' })

-- Buffer management
map('n', '<Tab>',     ':bnext<CR>',     { desc = 'buffer: next' })
map('n', '<S-Tab>',   ':bprevious<CR>', { desc = 'buffer: prev' })
map('n', '<leader>x', ':bdelete<CR>',   { desc = 'buffer: close' })
map('n', '<leader>bd', ':bdelete<CR>', { desc = 'buffer: delete' })
map('n', '<leader>ba', ':bufdo bd<CR>', { desc = 'buffer: delete all' })
map('n', '<leader>bl', ':b#<CR>', { desc = 'buffer: last' })
map('n', '<leader>bn', ':bnext<CR>', { desc = 'buffer: next' })
map('n', '<leader>bp', ':bprevious<CR>', { desc = 'buffer: prev' })
map('n', '<leader>bb', ':b<Space>', { desc = 'buffer: jump by name/number' })
map('n', '<leader>lsb', ':buffers<CR>:buffer<Space>', { desc = 'list buffers + open' })
map('n', '<leader>lsv', ':buffers<CR>:vert sb<Space>', { desc = 'list buffers + vsplit' })
map('n', '<leader>lsd', ':buffers<CR>:bd<Space>', { desc = 'list buffers + delete' })
map('n', '<leader>vs', ':vert sb<Space>', { desc = 'vertical split by buffer' })

-- File path helpers (insert path of current file's directory at cmdline)
map('n', '<leader>be', ':e <C-r>=expand("%:p:h")<CR>/', { desc = 'edit file in current dir' })
map('n', '<leader>ve', ':vsp <C-r>=expand("%:p:h")<CR>/', { desc = 'vsplit file in current dir' })
map('n', '<leader>cd', ':cd %:p:h<CR>:pwd<CR>', { desc = 'cd to current file dir' })

-- Delete current buffer's file with confirmation. Original mapping was broken
-- (missing : prefix and <CR>); this version asks before deleting and only
-- removes the current file, not adjacent files.
map('n', '<leader>rm', ':!rm -i %<CR>', { desc = 'rm current file (interactive)' })

-- Window resize. <C-{j,k,h,l}> are claimed by tmux-navigator below, so the
-- <C-w>{...} slot is repurposed for resizing instead of focus movement.
map('n', '<C-w>k', ':resize +15<CR>', { desc = 'taller' })
map('n', '<C-w>j', ':resize -15<CR>', { desc = 'shorter' })
map('n', '<C-w>l', ':vertical resize +15<CR>', { desc = 'wider' })
map('n', '<C-w>h', ':vertical resize -15<CR>', { desc = 'narrower' })

-- Tmux navigator: <C-h/j/k/l> moves between nvim splits AND tmux panes.
-- Plugin: christoomey/vim-tmux-navigator (see plugins/navigation.lua).
map('n', '<C-h>', '<cmd>TmuxNavigateLeft<CR>',  { desc = 'focus left  (nvim or tmux)' })
map('n', '<C-j>', '<cmd>TmuxNavigateDown<CR>',  { desc = 'focus down  (nvim or tmux)' })
map('n', '<C-k>', '<cmd>TmuxNavigateUp<CR>',    { desc = 'focus up    (nvim or tmux)' })
map('n', '<C-l>', '<cmd>TmuxNavigateRight<CR>', { desc = 'focus right (nvim or tmux)' })

-- nvim-tree
map('n', '<C-t>', ':NvimTreeFocus<CR>',    { desc = 'tree: focus' })
map('n', '<C-f>', ':NvimTreeFindFile<CR>', { desc = 'tree: reveal current file' })
map('n', '<C-c>', ':NvimTreeClose<CR>',    { desc = 'tree: close' })
map('n', '<leader>e', ':NvimTreeFocus<CR>', { desc = 'tree: focus (NvChad alias)' })

-- Diagnostics
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'prev diagnostic' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'next diagnostic' })
map('n', '<leader>dq', vim.diagnostic.setloclist, { desc = 'diagnostics to loclist' })
