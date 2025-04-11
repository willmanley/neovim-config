---- Alpha.nvim: a fast and fully customizable dashboard plugin. ----
---- Define the config function specific to the Alpha dashboard. ----
local function alpha_config()
	local dashboard = require("alpha.themes.dashboard")

	---- Configure start screen header (ASCII Art!). ----
	dashboard.section.header.val = {
		"                                                     ",
		"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
		"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
		"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
		"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
		"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
		"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
		"                                                     ",
	}

	---- Configure start screen buttons. ----
	dashboard.section.buttons.val = {
		-- Create a startup shortcut to jump straight to my portfolio. --
		dashboard.button(
			"p",
			"💼  Teleport to your Portfolio Project.",
			":cd /Users/willmanley/Desktop/projects/portfolio/ | Neotree<CR>"
		),
		dashboard.button(
			"c",
			"⚙️  Teleport to your NeoVim configuration.",
			":cd /Users/willmanley/.config/nvim/ | Neotree<CR>"
		),
		dashboard.button("q", "👋  Quit Neovim", ":qa<CR>"),
	}

	---- Configure start screen footer ----
	dashboard.section.footer.val = "I solemnly swear that I am up to no good!"

	-- Apply the configuration. --
	require("alpha").setup(dashboard.config)
end

---- Define the Lua table to pass to Lazy for plugin management. ----
return {
	-- Define the plugin installation source. ----
	"goolord/alpha-nvim",
	-- Define event to trigger the plugin (Vim startup w/out file opened). ----
	event = "VimEnter",
	-- Define the plugin dependencies. ----
	dependencies = {
		"nvim-neo-tree/neo-tree.nvim",
	},
	-- Define the plugin-specific configuration. ----
	config = alpha_config,
}
