return {
  "ibhagwan/fzf-lua",
  dependencies = { "echasnovski/mini.icons" },
  opts = {},
  keys = {
    { "<leader>fb", "<Cmd>FzfLua buffers sort_mru=true sort_lastused=true<CR>", desc = "Buffers" },
    { "<leader>ff", function() require("fzf-lua").files() end, desc = "Find Files" },
    { "<leader>fg", function() require("fzf-lua").live_grep() end, desc = "Find by grepping cwd" },
    { "<leader>fc", function() require("fzf-lua").files({ cwd=vim.fn.stdpath("config") }) end, desc = "Find Config Files" },
  }
}
