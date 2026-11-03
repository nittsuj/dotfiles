-- Leader must be set before lazy.nvim loads plugins
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.expandtab = true
opt.smartindent = true
opt.termguicolors = true
opt.ignorecase = true
opt.smartcase = true

opt.signcolumn = "yes"      -- no jump when signs show
opt.cursorline = true
opt.scrolloff = 8
opt.splitright = true
opt.splitbelow = true
opt.undofile = true         -- undo survives restart
opt.updatetime = 250
opt.clipboard = "unnamedplus"
