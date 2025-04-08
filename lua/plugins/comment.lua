---- comment.nvim: Smart commenting plugin for Neovim. ----
---- Define the config function specific to the Comment plugin. ----
local function comment_config()
	local comment = require("Comment")
	---- ... ----
	comment.setup({
		-- Define line & block comment toggling commands. --
		toggler = {
			line = "<leader>/",
			block = "<leader>?",
		},

		--[ Define line & block comment toggling commands that chain w/ native
		--] Vim motions.
		opleader = {
			line = "<leader>/",
			block = "<leader>?",
		},
	})
end

---- Define the Lua table to pass to Lazy for plugin management. ----
return {
	-- Define the plugin installation source. --
	"numToStr/Comment.nvim",
	-- Define the event trigger(s) for the plugin. --
	event = "VeryLazy",
	-- Define the plugin-specific configuration --
	config = comment_config,
}
