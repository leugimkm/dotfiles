return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        contrast = "hard",
        italic = {
          strings = false,
        },
        transparent_mode = true,
        overrides = {
          ColorColumn = { bg = "#1d2021" },
        },
      })
        vim.cmd.colorscheme("gruvbox")
    end,
  },
}
