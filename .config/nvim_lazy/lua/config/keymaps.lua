-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", "<leader>y", [[+y]])
map("v", "<leader>y", [[+y]])
map("n", "<leader>Y", [[+y]])

map("n", "<S-H>", "<Cmd>bprevious<CR>", { desc = "Prev buffer" })
map("n", "<S-L>", "<Cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-X>", "<Cmd>bdelete<CR>", { desc = "Delete buffer" })
