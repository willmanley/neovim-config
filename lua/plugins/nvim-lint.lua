---- nvim-lint: Static code analysis and linting plugin for Neovim. ----
---- Define the config function specific to the nvim-lint plugin. ----
local function lint_config()
	---- Configure Mason for installing language-specific tools. ----
	require("mason-tool-installer").setup({
		-- Ensure that the follwoing formatting tools are always installed.--
		ensure_installed = {
			-- Install ruff for Python linting.
			"ruff",
			-- Install LuaCheck for Lua linting.
			"luacheck",
		},
		auto_update = true,
		run_on_start = true,
	})

	---- Load the lint module. ----
	local lint = require("lint")

	---- Define specific linters to use by file type. ----
	lint.linters_by_ft = {
		python = { "ruff" },
		lua = { "luacheck" },
	}

	---- Configure custom settings for linters being used. ----
	-- Luacheck custom configuration.
	lint.linters.luacheck.args = {
		-- Register "vim" as a recognized global (Lua used to config Neovim!).
		"--globals",
		"vim",
	}

	-- Ruff custom configuration...
	-- lint.linters.ruff.args = {
	--     "--select",
	--     "E,F,W,I,N,D,UP,B,A,C4,SIM,ERA,PD,PL",
	--     "--line-length",
	--     "80",
	-- }

	---- Create trigger to run linting automatically. ----
	-- Lint when a file is written, opened, or insert mode is exited.
	vim.api.nvim_create_autocmd(
		{ "BufWritePost", "BufReadPost", "InsertLeave" },
		{
			callback = function()
				lint.try_lint()
			end,
		}
	)

	---- Create a keymap for manual linting. ----
	vim.keymap.set("n", "<leader>ln", function()
		lint.try_lint()
	end, { desc = "Trigger linting" })
end

---- Define the Lua table to pass to Lazy for plugin management. ----
return {
	-- Define the plugin installation source. --
	"mfussenegger/nvim-lint",
	-- Define when to load the plugin. --
	event = { "BufReadPre", "BufNewFile" },
	-- Define the plugin dependencies. --
	dependencies = {
		"williamboman/mason.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	-- Define the plugin-specific configuration. --
	config = lint_config,
}
