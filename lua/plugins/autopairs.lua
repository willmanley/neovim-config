---- nvim-autopairs: Automatic pair completion plugin for Neovim. ----
---- Define the config function specific to the nvim-autopairs plugin. ----
local function autopairs_config()
	local autopairs = require("nvim-autopairs")

	---- Initialize autopairs with default configuration ----
	autopairs.setup({
		---- Define pair completion rules ----
		disable_filetype = { "TelescopePrompt", "spectre_panel" },
		disable_in_macro = true, -- Disable during macro recording
		disable_in_visualblock = true, -- Disable in visual block mode
		ignored_next_char = "[%w%.]", -- Ignore alphanumeric and '.' chars
		enable_moveright = true, -- Enable automatic right movement
		enable_afterquote = true, -- Enable pairing after quote
		enable_check_bracket_line = true, -- Check surrounding pairs
		enable_bracket_in_quote = true, -- Enable brackets in quotes
		check_ts = true, -- Use treesitter for context

		---- Define pair mapping configurations ----
		fast_wrap = {
			map = "<M-e>", -- Alt+e to wrap selections
			chars = { "{", "[", "(", '"', "'" },
			pattern = [=[[%'%"%)%>%]%)%}%,]]=],
			end_key = "$",
			keys = "qwertyuiopzxcvbnmasdfghjkl",
			check_comma = true,
			highlight = "Search",
			highlight_grey = "Comment",
		},

		---- Define pair completion rules ----
		pairs = {
			["("] = { pair = "()", close = true, escape = false },
			["["] = { pair = "[]", close = true, escape = false },
			["{"] = { pair = "{}", close = true, escape = false },
			["'"] = {
				pair = "''",
				close = true,
				escape = true,
				ignore_adjacent = true,
			},
			['"'] = {
				pair = '""',
				close = true,
				escape = true,
				ignore_adjacent = true,
			},
			["`"] = {
				pair = "``",
				close = true,
				escape = true,
				ignore_adjacent = true,
			},
			["<"] = { pair = "<>", close = true, escape = true },
		},
	})

	---- Integrate with nvim-cmp if available ----
	local cmp_autopairs = require("nvim-autopairs.completion.cmp")
	local cmp = require("cmp")
	cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

	---- Custom pair mapping for specific filetypes ----
	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "markdown", "text" },
		callback = function()
			autopairs.disable() -- Disable for prose files
		end,
	})
end

---- Define the Lua table to pass to Lazy for plugin management. ----
return {
	-- Define the plugin installation source --
	"windwp/nvim-autopairs",
	-- Load after nvim-cmp if available --
	event = "InsertEnter",
	-- Define the plugin dependencies --
	dependencies = {
		-- Optional integration with nvim-cmp
		"hrsh7th/nvim-cmp",
	},
	-- Define the plugin-specific configuration --
	config = autopairs_config,
}
