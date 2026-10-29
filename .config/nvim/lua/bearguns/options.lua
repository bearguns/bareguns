local opt = vim.opt
local g = vim.g

g.mapleader = " "
opt.guicursor = ""
opt.nu = true
opt.relativenumber = true

-- Tabs v Spaces
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

-- Lines and indentation
opt.smartindent = true
opt.wrap = false
opt.backspace = "indent,eol,start"

-- UI Basics
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.cursorline = true

-- Let me copypasta freely
opt.clipboard:append("unnamedplus")
opt.scrolloff = 8
opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Reload clean buffers when another process (for example Codex) edits them.
-- Modified buffers are intentionally left alone so local work is never lost.
opt.autoread = true

-- Searching
opt.hlsearch = false
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- New splits right or below so cursor "lands" in split window
opt.splitright = true
opt.splitbelow = true

opt.updatetime = 250

-- Completion: see :h lsp-completion and :h ins-autocompletion
opt.completeopt = "menuone,popup,fuzzy,noselect"

-- Statusline: use %{%...%} so embedded highlight groups are evaluated.
-- See :h stl-%{
vim.opt.statusline = table.concat({
	" %f",
	" %m%r",
	"%=",
	"%{%v:lua.vim.lsp.status()%} ",
	"%{%v:lua.vim.diagnostic.status()%} ",
	" %l:%c ",
}, "")
