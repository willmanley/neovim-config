---- Lualine: A NeoVim statusbar plugin. ----
---- Define the config function specific to the Lualine plugin. ----
local function lualine_config()
	local lualine = require("lualine")
	lualine.setup({
		options = {
			-- Lualine colorbar theme choice. --
			theme = "OceanicNext",
		},
	})
end

---- Define the Lua table to pass to Lazy for plugin management. ----
return {
	-- Define the plugin installation source. --
	"nvim-lualine/lualine.nvim",
	-- Define the plugin event trigger(s). --
	event = "VeryLazy",
	-- Define the plugin dependencies. --
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- Define the plugin-specific configuration. --
	config = lualine_config,
}
