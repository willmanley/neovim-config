---- gitsigns.nvim: Git change indicators for Neovim. ----
---- Define the config function specific to gitsigns ----
local function gitsigns_config()
	require("gitsigns").setup({
		---- Configure the gutter signs used for git diff visualization. ----
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "▁" },
			topdelete = { text = "▔" },
			changedelete = { text = "▎" },
			untracked = { text = "▎" },
		},

		---- Enable line highlighting ----
		-- Turn line blame off by default (to empower toggling keymap.) --
		current_line_blame = false,
		-- Configure location of git blame staus. --
		current_line_blame_opts = {
			virt_text_pos = "right_align",
			delay = 250,
		},

		---- Configure git visualization keymaps. ----
		on_attach = function(buffer)
			local gs = package.loaded.gitsigns

			---- Preview the git diff code changes ("hunk"). ----
			vim.keymap.set("n", "<leader>gp", function()
				gs.preview_hunk()
			end, { buffer = buffer, desc = "Preview git hunk" })

			---- Toggle line git blame status on/off. ----
			vim.keymap.set("n", "<leader>gb", function()
				gs.toggle_current_line_blame()
			end, { buffer = buffer, desc = "Toggle git blame" })
		end,
	})
end

---- Define the Lua table to pass to Lazy for plugin management ----
return {
	-- Define the plugin installation source --
	"lewis6991/gitsigns.nvim",
	-- Load when opening a file that might have git changes --
	event = { "BufReadPre", "BufNewFile" },
	-- Define the plugin-specific configuration --
	config = gitsigns_config,
}
