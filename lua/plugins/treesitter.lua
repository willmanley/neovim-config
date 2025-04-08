---- Treesitter: A syntax parsing system for Neovim. ----
---- Define the config function specific to the Treesitter plugin. ----
local function treesitter_config()
	local configs = require("nvim-treesitter.configs")
	configs.setup({
		---- Define language-specific parsers that are to be installed. ----
		ensure_installed = {
			"lua",
			"python",
			"rust",
			"html",
			"javascript",
			"css",
		},
		sync_install = false,
		auto_install = true,

		---- Define syntax highlighting configuration. ----
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},

		---- Define language-aware auto-indenting configuration. ----
		indent = {
			enable = true,
			disable = { "python", "yaml" },
		},

		---- Define language-aware incremental selection keymappings. ----
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<leader>i",
				node_incremental = "<leader>ii",
				scope_incremental = "<leader>is",
				node_decremental = "<leader>id",
			},
		},

		---- Define text object configuration settings. ----
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
					["ad"] = "@conditional.inner",
					["id"] = "@conditional.outer",
					["al"] = "@loop.outer",
					["il"] = "@loop.inner",
				},
			},
			move = {},
		},

		---- Define language comment string configuration. ----
		context_commentstring = {
			enable = true,
			enable_autocmd = false,
		},

		---- Define Autotag configuration. ----
		autotag = {
			enable = true,
		},
	})

	---- Setup rainbow-delimiters.nvim separately ----
	require("rainbow-delimiters.setup")({
		strategy = {
			[""] = require("rainbow-delimiters").strategy["global"],
			html = require("rainbow-delimiters").strategy["local"],
		},
		query = {
			[""] = "rainbow-delimiters",
			lua = "rainbow-blocks",
		},
		highlight = {
			-- Custom highlight groups (can use your colorscheme's groups)
			"RainbowDelimiterRed",
			"RainbowDelimiterYellow",
			"RainbowDelimiterBlue",
			"RainbowDelimiterOrange",
			"RainbowDelimiterGreen",
			"RainbowDelimiterViolet",
			"RainbowDelimiterCyan",
		},
	})
end

---- Define the Lua table to pass to Lazy for plugin management. ----
return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		-- Plugin used for "rainbow" delimiters.
		{
			"HiPhish/rainbow-delimiters.nvim",
			config = function()
				-- Configuration moved to main treesitter config function
			end,
		},
		-- Plugin used to enable text object handling. --
		"nvim-treesitter/nvim-treesitter-textobjects",
		-- Plugin to enable autotagging for HTML/XML tags. --
		"windwp/nvim-ts-autotag",
	},
	config = treesitter_config,
}
