---- Oceanic Next: a color scheme plugin. ----
---- Define the config function specific to the Oceanic Next colorscheme. ----
local function oceanic_next_config()
	-- Set the colorscheme. --
	vim.cmd.colorscheme("oceanicnext")

	-- Customize highlight groups after loading. --
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

---- Define the Lua table to pass to Lazy for plugin management. ----
return {
	-- Define the plugin installation source. ----
	"mhartington/oceanic-next",
	-- Define when to load the plugin (ensure loads eagerly & first) ----
	lazy = false,
	priority = 1000,
	-- Define the plugin-specific configuration. --
	config = oceanic_next_config,
}
