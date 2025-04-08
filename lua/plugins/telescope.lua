---- Telescope: a fuzzy-finding plugin. ----
---- Define the config function specific to the Telescope plugin. ----
local function telescope_config()
	local telescope = require("telescope")
	local actions = require("telescope.actions")
	local themes = require("telescope.themes")
	telescope.setup({
		---- Defaults: to be applied to all pickers unless overridden. ----
		defaults = {
			---- Keybindings. ----
			mappings = {
				-- Insert mode keybindings. --
				i = {
					-- Allow use of escape key to close Telescope. --
					["<esc>"] = actions.close,
				},
			},
			---- File filtering patterns to ignore from Telescope queries. ----
			file_ignore_patterns = { ".git" },
		},
		---- Picker-specific configurations - overrides defaults. ----
		pickers = {},
		---- Configurations for telescope extensions. ----
		extensions = {
			---- UI-Select integration: dropdown UI (e.g. code actions). ----
			["ui-select"] = themes.get_dropdown({}),
		},
	})
	---- Load UI-Select extension after core Telescope configuration. ----
	telescope.load_extension("ui-select")
end

---- Define Telescope key mappings: ----
vim.keymap.set("n", "<leader>tf", function()
	require("telescope.builtin").find_files()
end, { noremap = true, silent = true, desc = "Telescope file search." })
vim.keymap.set("n", "<leader>tg", function()
	require("telescope.builtin").live_grep()
end, { noremap = true, silent = true, desc = "Telescope file grep." })
vim.keymap.set("n", "<leader>tk", function()
	require("telescope.builtin").keymaps()
end, { noremap = true, silent = true, desc = "Telescope keymaps." })

---- Define the Lua table to pass to Lazy for plugin management. ----
return {
	-- Define the plugin installation source. --
	"nvim-telescope/telescope.nvim",
	-- Define the events upon which to trigger the plugin. --
	event = "VeryLazy",
	-- Define the plugin dependencies. --
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-ui-select.nvim" },
	},
	-- Define the plugin-specific configuration. --
	config = telescope_config,
}
