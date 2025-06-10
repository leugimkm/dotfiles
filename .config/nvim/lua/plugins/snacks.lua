return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      picker = {},
      explorer = {},
      scratch = {},
      terminal = {},
      zen = { enabled = true },
    },
    keys = {
      { "<leader>pf", function() require("snacks").picker.files() end, desc = "Picker find files" },
      { "<leader>pc", function() require("snacks").picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Picker find config files" },
      { "<leader>pg", function() require("snacks").picker.grep() end, desc = "Picker grep" },
      { "<leader>pe", function() require("snacks").explorer() end, desc = "Picker find files" },

      { "<leader>,", function() require("snacks").picker.buffers() end, desc = "Buffers" },
      { "<leader>fT", function() require("snacks").terminal() end, desc = "Terminal" },
      { "<leader>.", function() require("snacks").scratch() end, desc = "Toggle Scratch Buffer" },
      { "<leader>S", function() require("snacks").scratch.select() end, desc = "Select Scratch Buffer" },

      { "gd", function() require("snacks").picker.lsp_definitions() end, desc = "Go to definition" },
      { "gr", function() require("snacks").picker.lsp_references() end, desc = "Go to references" },
      { "gy", function() require("snacks").picker.lsp_type_definitions() end, desc = "Go to type definition" },
      { "gi", function() require("snacks").picker.lsp_implementations() end, desc = "Go to implementation" },

      {"<leader>z", function() require("snacks").zen() end, desc = "Toggle Zen Mode" },
      {"<leader>Z", function() require("snacks").zen.zoom() end, desc = "Toggle Zen Mode" },
    },
  },
}
