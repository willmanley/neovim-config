---- LSP-Config: Neovim's native Language Server Protocol client plugin. ----
---- Define the config function specific to the LSP-Config plugin. ----
local function lspconfig_config()
	---- Configure Mason for LSP server management ----
	require("mason").setup()
	require("mason-lspconfig").setup({
		-- Define language servers to automatically install --
		ensure_installed = {
			"lua_ls",
			"pyright",
			"rust_analyzer",
		},
		-- Enable automatic installation of servers --
		automatic_installation = true,
	})

	---- Configure diagnostic display settings ----
	vim.diagnostic.config({
		-- Show diagnostic messages inline --
		virtual_text = true,
		-- Configure diagnostic signs --
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "❌",
				[vim.diagnostic.severity.WARN] = "⚠️",
				[vim.diagnostic.severity.HINT] = "💡",
				[vim.diagnostic.severity.INFO] = "ℹ️",
			},
			numhl = {
				[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
				[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
				[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
				[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
			},
			texthl = {
				[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
				[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
				[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
				[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
			},
		},
		-- Underline problematic code --
		underline = true,
		-- Don't update diagnostics in insert mode --
		update_in_insert = false,
		-- Sort diagnostics by severity --
		severity_sort = true,
		-- Configure floating diagnostic window --
		float = {
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	})

	---- Define LSP capabilities (with nvim-cmp integration) ----
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if has_cmp then
		capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
	end

	---- Define LSP attachment handler ----
	local on_attach = function(client, bufnr)
		---- Define buffer-local key mappings ----
		local opts = { noremap = true, silent = true, buffer = bufnr }

		---- Target Navigation ----
		-- Jump to definition --
		vim.keymap.set("n", "<leader>jd", vim.lsp.buf.definition, opts)
		-- Jump to declaration --
		vim.keymap.set("n", "<leader>jD", vim.lsp.buf.declaration, opts)
		-- Jump to implementation --
		vim.keymap.set("n", "<leader>ji", vim.lsp.buf.implementation, opts)
		-- Jump to references --
		vim.keymap.set("n", "<leader>jr", vim.lsp.buf.references, opts)

		---- Target Information ----
		-- Show documentation --
		vim.keymap.set("n", "<leader>dd", vim.lsp.buf.hover, opts)
		-- Show signature help --
		vim.keymap.set("n", "<leader>ds", vim.lsp.buf.signature_help, opts)

		---- Code Actions ----
		-- Rename symbol --
		vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)
		-- Show code actions --
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

		---- Diagnostics ----
		-- Show diagnostic float --
		vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
		-- Go to previous diagnostic --
		vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, opts)
		-- Go to next diagnostic --
		vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, opts)
	end

	---- Configure Lua language server with special settings. ----
	require("lspconfig").lua_ls.setup({
		on_attach = on_attach,
		capabilities = capabilities,
		settings = {
			Lua = {
				diagnostics = { globals = { "vim" } },
			},
		},
	})

	---- Configure all other language servers automatically. ----
	require("mason-lspconfig").setup_handlers({
		function(server_name)
			if server_name ~= "lua_ls" then
				require("lspconfig")[server_name].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end
		end,
	})
end

---- Define the Lua table to pass to Lazy for plugin management. ----
return {
	-- Define the plugin installation source --
	"neovim/nvim-lspconfig",
	-- Define when to load the plugin --
	event = { "BufReadPre", "BufNewFile" },
	-- Define the plugin dependencies --
	dependencies = {
		-- LSP server installer
		"williamboman/mason.nvim",
		-- Bridge between mason and lspconfig
		"williamboman/mason-lspconfig.nvim",
		-- Completion engine integration
		"hrsh7th/nvim-cmp",
		-- LSP completion source.
		"hrsh7th/cmp-nvim-lsp",
	},
	-- Define the plugin-specific configuration --
	config = lspconfig_config,
}
