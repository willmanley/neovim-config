---- conform.nvim: Automated formatting plugin for Neovim. ----
---- Define the config function specific to the Conform plugin. ----
local function conform_config()
	---- Configure Mason for installing language-specific tools. ----
	require("mason-tool-installer").setup({
		-- Ensure that the follwoing formatting tools are always installed.--
		ensure_installed = {
			-- Install Stylua for Lua formatting.
			"stylua",
			-- Install ISort for Python import formatting.
			-- "isort",
			-- Install ruff for Python style formatting.
			"ruff",
			-- Install prerrier for JS/CSS/HTML, etc. formatting.
			"prettier",
		},
		auto_update = true,
		run_on_start = true,
	})

	---- Configure Conform formatters. ----
	local conform = require("conform")
	conform.setup({
		---- Point conform to the formatter(s) to use for each file type. ----
		formatters_by_ft = {
			lua = { "stylua" },
			python = {
				-- "isort",
				"ruff_format",
			},
			javascript = { "prettier" },
			typescript = { "prettier" },
			css = { "prettier" },
			html = { "prettier" },
			json = { "prettier" },
			markdown = { "prettier" },
		},

		---- Formatter-specific custom configurations. ----
		formatters = {
			stylua = { prepend_args = { "--column-width", "80" } },
			--[[ 			isort = { prepend_args = { "--line-length", "80" } }, ]]
			ruff_format = { prepend_args = { "format", "--line-length", "80" } },
		},
		-- Enable formatting on buffer writing. --
		format_on_save = {
			enabled = true,
			timeout_ms = 500,
			-- lsp_fallback = true,
		},
	})
	---- Create a custom keypmap for manual formatting. ----
	vim.keymap.set("n", "<leader>fm", function()
		conform.format({
			async = true,
			-- lsp_fallback = true
		})
	end, { desc = "Format document" })
end

---- Define the Lua table to pass to Lazy for plugin management. ----
return {
	-- Define the plugin installation source. --
	"stevearc/conform.nvim",
	-- Define the event trigger(s) for the plugin. --
	event = { "BufWritePre" },
	-- Allows you to see which formatters are available. --
	cmd = { "ConformInfo" },
	-- Define the plugin dependencies. --
	dependencies = {
		"williamboman/mason.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	-- Define the plugin-specific configuration. --
	config = conform_config,
}
