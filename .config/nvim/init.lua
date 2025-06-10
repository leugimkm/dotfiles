local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.o.winborder = "rounded"

require("config.options")
require("config.autocmds")
require("lazy").setup({
  ui = { border = "rounded" },
  spec = { { import = "plugins" } },
  rocks = { enabled = false },
  checker = { enabled = true },
})
require("config.keymaps")

vim.cmd("colorscheme gruvbox")
vim.lsp.enable({
  "clangd",
  "html",
  "jsonls",
  "lua_ls",
  "pyright",
  "rust_analizer",
  "typescript",
})
local capabilities = require("blink.cmp").get_lsp_capabilities()
vim.lsp.config("*", {
  capabilities = capabilities
})
