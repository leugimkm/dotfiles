return {
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    dependencies = { "echasnovski/mini.icons" },
    opts = {},
    keys = {
      { "<leader>fb", "<Cmd>FzfLua buffers sort_mru=true sort_lastused=true<CR>", desc = "Buffers" },
      { "<leader>ff", "<Cmd>FzfLua files<CR>", desc = "Find files" },
      { "<leader>fg", "<Cmd>FzfLua live_grep<CR>", desc = "Live grep" },
      { "<leader>fr", "<Cmd>FzfLua oldfiles<CR>", desc = "Recently opened files" },
      { "<leader>fh", "<Cmd>FzfLua help_tags<CR>", desc = "Help tags" },
      { "<leader>fk", "<Cmd>FzfLua keymaps<CR>", desc = "Key maps" },
      { "<leader>fc", function() require("fzf-lua").files({ cwd=vim.fn.stdpath("config") }) end, desc = "Find config files" },
    },
  },
  {
    "stevearc/oil.nvim",
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    lazy = false,
    opts = {
      default_file_explorer = false,
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      keymaps = {
        ["<C-c>"] = false,
        ["q"] = "actions.close",
      },
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name, _)
          return name == ".." or name == ".git"
        end
      },
      float = {
        padding = 4,
        max_width = 0.8,
        max_height = 0.8,
      }
    },
    keys = {
      { "<leader>oe", "<Cmd>Oil --float<CR>", desc = "Open directory" },
    },
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
}
