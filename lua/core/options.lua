local opt = vim.opt

-- Session Management
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Line Numbers
opt.relativenumber = true
opt.number = true
opt.nu = true
vim.o.statuscolumn = '%s %l %r '

-- Tabs & Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
vim.bo.softtabstop = 2

-- Line Wrapping

opt.wrap = true
-- Search Settings
opt.ignorecase = true
opt.smartcase = true

-- Cursor Line
opt.cursorline = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
vim.diagnostic.config {
  float = { border = "rounded" }, -- add border to diagnostic popups
}

-- Backspace
opt.backspace = "indent,eol,start"

-- Clipboard
opt.clipboard:append("unnamedplus")

-- Split Windows
opt.splitright = true
opt.splitbelow = true

-- Consider - as part of keyword
opt.iskeyword:append("-")

-- Disable the mouse while in nvim
opt.mouse = ""

-- Folding
opt.foldlevel = 20
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()" -- Utilize Treesitter folds

-- Set highlight on search, but clear on pressing <Esc> in normal mode
opt.hlsearch = true

-- Save undo history
opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
opt.ignorecase = true
opt.smartcase = true

-- Don't show the mode, since it's already in the status lines
opt.showmode = false


-- Override vim options with keymap

vim.keymap.set('n', '<Esc>', '<Esc><Esc><cmd>nohlsearch<CR>')

-- To exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Scrolling
vim.keymap.set('n', '}', '}zz', { desc = 'Move paragraph forward and re-center' })
vim.keymap.set('n', '{', '{zz', { desc = 'Move paragraph forward and re-center' })
opt.scrolloff = 10
