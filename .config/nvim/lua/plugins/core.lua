return {
  {"fterm", name="fterm", dev = true, opts = {
    keymap = {
      mode = "n", lhs = "<leader>ft", opts = { noremap = true, silent = true }
    }
  }},
  { "echasnovski/mini.statusline", version = "*", opts = {} },
  { "echasnovski/mini.trailspace", version = "*", opts = {} },
  { "folke/trouble.nvim", cmd = "Trouble", opts = {} },
  { "nvzone/showkeys", cmd = "ShowkeysToggle", opts = { maxkeys = 5 } },
  {
    "echasnovski/mini.pairs",
    version = "*",
    opts = {
      mappings = {
        ["`"] = {
          action = "closeopen",
          pair = "``",
          neigh_pattern = "[^||`].",
          register = { cr = false }
        },
      },
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      skip_unbalanced = true,
      markdown = true,
    },
  },
  {
    "stevearc/oil.nvim",
    opts = {},
    dependencies = {{ "echasnovski/mini.icons", opts = { }}},
    lazy = false,
  },
}
