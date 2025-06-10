-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.lazyvim_python_lsp = "pyright"
vim.g.lazyvim_python_ruff = "ruff"

local set = vim.opt

set.clipboard = "unnamedplus"
set.cursorline = false
set.colorcolumn = "80"
set.conceallevel = 0
set.timeoutlen = 1000
set.ttimeoutlen = 0
