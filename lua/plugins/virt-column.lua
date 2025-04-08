---- Virt-column: a ruler plugin. ----
---- Define the config function specific to the virt-column plugin. ----
local function virt_column_config()
	require("virt-column").setup({
		-- Define the ruler character. --
		char = "│",
		-- Define the column at which to rule. --
		virtcolumn = "80",
		-- Define ruler boldness. --
		highlight = "ColorColumn",
	})
end

---- Define the Lua table to pass to Lazy for plugin management. ----
return {
	-- Define the plugin installation source. ----
	"lukas-reineke/virt-column.nvim",
	-- Define the events upon which to trigger the plugin. ----
	event = { "BufNewFile", "BufReadPost" },
	-- Define the plugin-specific configuration. --
	config = virt_column_config,
}
