vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  virtual_text = { severity = { max = vim.diagnostic.severity.WARN } },
  virtual_lines = { severity = { min = vim.diagnostic.severity.ERROR } },
  float = { border = "rounded", source = true, focusable = false },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚",
      [vim.diagnostic.severity.WARN] = "󰀪",
      [vim.diagnostic.severity.INFO] = "󰋽",
      [vim.diagnostic.severity.HINT] = "󰌶",
    },
  },
})

local function on_attach(bufnr)
  local map = function(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = "LSP: " .. desc })
  end
  map("K", vim.lsp.buf.hover, "Hover documentation")
  map("gK", vim.lsp.buf.signature_help, "Signature help")
  map("cr", vim.lsp.buf.rename, "[r]ename")
  map("ca", vim.lsp.buf.code_action, "[c]ode [a]ction")
  map("[d", vim.diagnostic.goto_prev, "Prev diagnostic")
  map("]d", vim.diagnostic.goto_next, "Next diagnostic")
  map("<leader>cd", vim.diagnostic.open_float, "Show floating diagnostic")
  map("<leader>cl", vim.diagnostic.setloclist, "Show diagnostic list")
  -- map("gd", vim.lsp.buf.definition, "[g]oto [d]efinition")
  -- map("gr", vim.lsp.buf.references, "[g]oto [r]eferences")
  -- map("gi", vim.lsp.buf.implementation, "[g]oto [i]mplementation")
  -- map("gy", vim.lsp.buf.type_definition, "[g]oto t[y]pe definition")
  -- map("gD", vim.lsp.buf.declaration, "[g]oto [D]eclaration")
  map("gd", "<Cmd>FzfLua lsp_definitions<CR>", "[g]oto [d]efinition")
  map("gr", "<Cmd>FzfLua lsp_references<CR>", "[g]oto [r]eferences")
  map("gi", "<Cmd>FzfLua lsp_implementations<CR>", "[g]oto [i]mplementation")
  map("gy", "<Cmd>FzfLua lsp_typedefs<CR>", "[g]oto t[y]pe definition")
  map("gD", "<Cmd>FzfLua lsp_declarations<CR>", "[g]oto [D]eclaration")
  map("gl", "<Cmd>FzfLua lsp_document_diagnostics<CR>", "Show document diagnostics")
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("_lsp_attach", { clear = true }),
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
    on_attach(ev.buf)
  end,
})

vim.lsp.config.lua_ls = { settings = { Lua = { diagnostics = { globals = { "vim" } } } } }
vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })

-- NOTE: Install formatters manually: stylua, prettier, ruff
return {
  "mason-org/mason-lspconfig.nvim",
  dependencies = { { "mason-org/mason.nvim", opts = {} }, "neovim/nvim-lspconfig" },
  opts = {
    ensure_installed = {
      "astro",
      "bashls",
      "clangd",
      "cssls",
      "eslint",
      "html",
      "jsonls",
      "lua_ls",
      "mdx_analyzer",
      "pyright",
      "rust_analyzer",
      "tailwindcss",
      "ts_ls",
      "yamlls",
    },
  },
}
