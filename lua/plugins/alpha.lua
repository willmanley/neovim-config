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
		dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
		dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
		dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
		dashboard.button("c", "  Configuration", ":e $MYVIMRC<CR>"),
		dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
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
	-- Define the plugin-specific configuration. ----
	config = alpha_config,
}
