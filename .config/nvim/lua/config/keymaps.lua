local map = vim.keymap.set

map({"n", "x"}, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down" })
map({"n", "x"}, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down" })
map({"n", "x"}, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up" })
map({"n", "x"}, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up" })

map("n", "<C-h>", "<C-w>h", { remap = true, desc = "Move to the left window" })
map("n", "<C-j>", "<C-w>j", { remap = true, desc = "Move to the lower window" })
map("n", "<C-k>", "<C-w>k", { remap = true, desc = "Move to the upper window" })
map("n", "<C-l>", "<C-w>l", { remap = true, desc = "Move to the right window" })

map("t", "<C-h>", "<Cmd>wincmd h<CR>", { noremap = true, desc = "Move to the left window" })
map("t", "<C-j>", "<Cmd>wincmd j<CR>", { noremap = true, desc = "Move to the lower window" })
map("t", "<C-k>", "<Cmd>wincmd k<CR>", { noremap = true, desc = "Move to the upper window" })
map("t", "<C-l>", "<Cmd>wincmd l<CR>", { noremap = true, desc = "Move to the right window" })

map("n", "sh", "<C-w><", { noremap = true, desc = "Decrease window width" })
map("n", "sl", "<C-w>>", { noremap = true, desc = "Increase window width" })
map("n", "sj", "<C-w>-", { noremap = true, desc = "Decrease window height" })
map("n", "sk", "<C-w>+", { noremap = true, desc = "Increase window height" })

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move down"})
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move up"})
map("n", "J", "mzJ`z", { desc = "Join line below to the current one" })
map("x", "<leader>p", "\"_dP", { desc = "Replace using blackhole register" })

map("n", "<S-h>", "<Cmd>bprevious<CR>", { desc = "Prev buffer" })
map("n", "<S-l>", "<Cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-x>", "<Cmd>bdelete<CR>", { desc = "Delete buffer" })
map("n", "<leader>bn", "<Cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", "<Cmd>bprevious<CR>", { desc = "Prev buffer" })
map("n", "<leader>bd", "<Cmd>bdelete<CR>", { desc = "Delete buffer" })

map("n", "<leader>-", "<C-W>s", { remap = true, desc = "Split window horizontal" })
map("n", "<leader>|", "<C-W>v", { remap = true, desc = "Split window vertical" })

map("n", "<leader><Tab>", "<Cmd>set nolist!<CR>", { silent = true })
map("n", "<leader><CR>", "<Cmd>noh<CR>", { silent = true })
map("n", "<leader>uw", "<Cmd>set wrap!<CR>", { silent = true })
map("n", "<leader>e", "<Cmd>Oil --float<CR>", { desc = "Open parent directory in Oil" })
-- map("n", "<leader>e", "<Cmd>Ex<CR>", { silent = true })

map("n", "+", "<C-a>", { noremap = true, desc = "Increment number" })
map("n", "-", "<C-x>", { noremap = true, desc = "Decrement number" })

map("v", "<", "<gv", { desc = "Indent to the right" })
map("v", ">", ">gv", { desc = "Indent to the left" })

map("n", "<C-d>", "<C-d>zz", { desc = "Scroll downwards" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll upwards" })
map("n", "n", "nzzzv", { desc = "Next result" })
map("n", "N", "Nzzzv", { desc = "Previous result" })

map("n", "<leader>y", "\"+y", { desc = "Copy to system's clipboard" })
map("v", "<leader>y", "\"+y", { desc = "Copy to system's clipboard" })
map("n", "<leader>Y", "\"+Y", { desc = "Copy to system's clipboard" })

map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word" })
