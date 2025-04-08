---- Neo-tree: A file explorer plugin for Neovim. ----
---- Define the config function specific to the Neo-tree plugin. ----
local function neotree_config()
	-- Set up global keybindings for Neo-tree
	vim.keymap.set(
		"n",
		"<leader>fs",
		":Neotree toggle<CR>",
		{ noremap = true, silent = true }
	)
	vim.keymap.set(
		"n",
		"<leader>ft",
		":Neotree focus<CR>",
		{ noremap = true, silent = true }
	)

	local neotree = require("neo-tree")
	neotree.setup({
		---- Define sources available for Neo-tree to display. ----
		sources = {
			-- Enable displaying of the local filesystem. --
			"filesystem",
			-- Enable displaying of the local filesystem's Git status. --
			"git_status",
		},

		---- Define configuration specific to file system sources. ----
		filesystem = {
			---- Enable display of hidden files (dotfiles). ----
			filtered_items = {
				-- Make hidden files visible. --
				visible = true,
				-- Make dotfiles visible (e.g. .gitignore) --
				hide_dotfiles = false,
				-- Make gitignored files visible. --
				hide_gitignored = false,
			},
			-- Follow current file and reveal in tree on buffer change. --
			follow_current_file = {
				enabled = true,
			},
			-- Use libuv file watcher to detect changes. --
			use_libuv_file_watcher = true,
			-- Define window mappings for filesystem source. --
			window = {
				mappings = {
					-- Keymap to toggle a directory open/closed. --
					--["<cr>"] = "open_with_window_picker",
					-- Keymap to create a new file/directory. --
					--["a"] = "add",
					-- Keymap to delete a file/directory. --
					--["d"] = "delete",
					-- Keymap to rename a file/directory. --
					--["r"] = "rename",
					-- Keymap to copy a file/directory. --
					--["c"] = "copy_to_clipboard",
				},
			},
			-- Define what to render for each file in the tree. --
			renderers = {
				file = {
					-- Render an icon specific to the file type. --
					{ "icon" },
					-- Render the name of the file. --
					{ "name" },
					-- ... --
					{ "modified" },
					-- Render the git status of the file. --
					{ "git_status" },
				},
			},
		},

		---- Define configuration specific to local filesystem Git status. ----
		git_status = {
			---- Define file tree symbols for the Git status of each file. ----
			symbols = {
				added = "+",
				modified = "M",
				deleted = "x",
				renamed = "R",
			},
			-- Define window mappings for git source. --
			-- window = {
			--     mappings = {
			--         -- Keymap to stage/unstage a file. --
			--         ["s"] = "toggle_git_status",
			--         -- Keymap to discard changes. --
			--         ["D"] = "git_discard",
			--     }
			-- }
		},

		---- Define the file tree display configuration. ----
		window = {
			-- Set the location of the file tree window. --
			position = "left",
			-- Set the width of the file tree window. --
			width = 30,
			-- Set mappings for within the Neo-tree window
			mappings = {
				-- Add any window-specific mappings here
			},
		},
	})
end

---- Define the Lua table to pass to Lazy for plugin management. ----
return {
	-- Define the plugin installation source. --
	"nvim-neo-tree/neo-tree.nvim",
	-- Define when to load the plugin
	cmd = "Neotree",
	keys = {
		{ "<leader>fs", desc = "Toggle NeoTree" },
		{ "<leader>ft", desc = "Focus NeoTree" },
	},
	-- Define the plugin dependencies. --
	dependencies = {
		-- Required dependency for neo-tree. --
		"nvim-lua/plenary.nvim",
		-- A plugin for icon support for neo-tree. --
		"nvim-tree/nvim-web-devicons",
		-- A plugin for git status indicators. --
		"MunifTanjim/nui.nvim",
	},
	-- Define the plugin-specific configuration. --
	config = neotree_config,
}
