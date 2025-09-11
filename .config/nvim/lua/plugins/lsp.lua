local capabilities = require("blink.cmp").get_lsp_capabilities()

local function configure_diagnostics()
	vim.diagnostic.config({
		underline = true,
		update_in_insert = true,
		severity_sort = true,
		virtual_text = { severity = { max = vim.diagnostic.severity.WARN } },
		virtual_lines = { severity = { min = vim.diagnostic.severity.ERROR } },
		float = { border = "rounded", source = true },
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "󰅚",
				[vim.diagnostic.severity.WARN] = "󰀪",
				[vim.diagnostic.severity.INFO] = "󰋽",
				[vim.diagnostic.severity.HINT] = "󰌶",
			},
		},
	})
end

local function on_attach(bufnr)
	local map = function(keys, func, desc, mode)
		mode = mode or "n"
		vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
	end
	map("K", vim.lsp.buf.hover, "Hover")
	map("gK", vim.lsp.buf.signature_help, "Signature help")
	map("cr", vim.lsp.buf.rename, "Rename")
	map("ca", vim.lsp.buf.code_action, "Code action")
	-- map("gd", vim.lsp.buf.definition, "Goto definition")
	-- map("gy", vim.lsp.buf.type_definition, "Goto type definition")
	-- map("gi", vim.lsp.buf.implementation, "Goto implementation")
	-- map("gr", vim.lsp.buf.references, "Goto references")
	-- map("gD", vim.lsp.buf.declaration, "Goto declaration")
	map("gd", "<Cmd>FzfLua lsp_definitions<CR>", "Goto definition")
	map("gy", "<Cmd>FzfLua lsp_typedefs<CR>", "Goto type definition")
	map("gi", "<Cmd>FzfLua lsp_implementations<CR>", "Goto implementation")
	map("gr", "<Cmd>FzfLua lsp_references<CR>", "Goto references")
	map("gD", "<Cmd>FzfLua lsp_declarations<CR>", "Goto declaration")
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
		configure_diagnostics()
	end,
})

vim.lsp.config.lua_ls = {
	settings = { Lua = { diagnostics = { globals = { "vim" } } } },
}
vim.lsp.config("*", {
	capabilities = capabilities,
})

return {
	"mason-org/mason-lspconfig.nvim",
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
	},
	opts = {
		ensure_installed = {
			-- LSP servers
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
			-- Formatters: manual install
			-- "prettier",
			-- "rust_analyzer"
			-- "stylua",
		},
	},
}
