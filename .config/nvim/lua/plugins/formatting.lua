return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      astro = { name = "astro-language-server", timeout_ms = 500, lsp_format = "prefer" },
      c = { name = "clangd", timeout_ms = 500, lsp_format = "prefer" },
      css = { "prettier" },
      html = { "prettier" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      lua = { "stylua" },
      markdown = { "prettier" },
      mdx = { "prettier" },
      python = { "ruff_format", "ruff_fix", "ruff_organize_imports" },
      rust = { name = "rust_analyzer", timeout_ms = 500, lsp_format = "prefer" },
      toml = { "prettier" },
      typescript = { "prettier" },
      yaml = { "prettier" },
    }
  },
  keys = {
    { "<leader>cf", function() require("conform").format() end, desc = "Format" },
  },
}
