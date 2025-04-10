---- todo-comments: A plugin for highlighting and searching code comments. ----
local function todo_comments_config()
	local todo = require("todo-comments")

	---- Configure the plugin with custom settings. ----
	todo.setup({
		-- Whether to show the  comment type icon in the sign colunmn. --
		signs = false,
		-- Set the priority of the icon within the sign column. --
		sign_priority = 8,
		-- Specify "keywords" to be picked up as action comment types. --
		keywords = {
			-- Specify action comments for fixes and how they display. --
			FIX = {
				-- Specify the icon to display in the sign column. --
				icon = " ", -- icon used for the sign, and in search results
				-- Specify the highlight color (see colors block). --
				color = "error",
				-- Define aliases that will also be picked up. --
				alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
			},
			-- Specify action comments for todo's and how they display. --
			TODO = { icon = " ", color = "info" },
			-- Specify action comments for hacks and how they display. --
			HACK = { icon = " ", color = "warning" },
			-- Specify action comments for warnings and how they display. --
			WARN = {
				icon = " ",
				color = "warning",
				alt = { "WARNING", "XXX" },
			},
			-- Specify action comments to optimize and how they display. --
			PERF = {
				icon = " ",
				alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" },
			},
			-- Specify action comments for notes and how they display. --
			NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
			-- Specify action comments for tests and how they display. --
			TEST = {
				icon = "⏲ ",
				color = "test",
				alt = { "TESTING", "PASSED", "FAILED" },
			},
		},
		-- Specify the GUI display for action comments. --
		gui_style = {
			-- Display style for action comment foreground (block). --
			fg = "NONE", -- The gui style to use for the fg highlight group.
			-- Display style for action comment background (text). --
			bg = "BOLD", -- The gui style to use for the bg highlight group.
		},
		-- Define whether to allow default action keyword aliases. --
		merge_keywords = true,
		-- Specify how action comments should be highlighted. --
		highlight = {
			-- Enable multiline action comments. --
			multiline = true,
			multiline_pattern = "^.",
			multiline_context = 10,
			-- Style to comment before the action word. --
			before = "fg",
			-- Style to highlight the action word (comment type). --
			keyword = "wide",
			-- Style to highlight after the action word (comment body). --
			after = "fg",
			-- Pattern / table to use for highlighting. --
			pattern = [[.*<(KEYWORDS)\s*:]],
			-- Only highlight action words as comments. --
			comments_only = true,
			-- Maximum line length to render. --
			max_line_len = 400,
			-- File types to exclude from action comments. --
			exclude = {},
		},
		-- Define the highlight color groups to use for each action type. --
		colors = {
			error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
			warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
			info = { "DiagnosticInfo", "#2563EB" },
			hint = { "DiagnosticHint", "#10B981" },
			default = { "Identifier", "#7C3AED" },
			test = { "Identifier", "#FF00FF" },
		},
		-- Define the regex used to search by comment action type. --
		search = {
			command = "rg",
			args = {
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
			},
			pattern = [[\b(KEYWORDS):]],
		},
	})
end

---- Create custom keymaps for working with TODO comments. ----
-- Create a keymap to list all TODO comments in the project. --
vim.keymap.set("n", "<leader>tt", "<cmd>TodoTelescope<cr>", {
	desc = "Telescope TODO comments.",
})

---- Define the Lua table to pass to Lazy for plugin management ----
return {
	-- Define the plugin installation source. --
	"folke/todo-comments.nvim",
	-- Define the event trigger(s) for the plugin. --
	event = { "BufReadPost", "BufNewFile" },
	-- Define the plugin dependencies. --
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	-- Define the plugin-specific configuration. --
	config = todo_comments_config,
}
