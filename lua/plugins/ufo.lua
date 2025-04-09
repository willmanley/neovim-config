---- nvim-ufo: An advanced code-folding plugin. ----
local function ufo_config()
	local ufo = require("ufo")

	---- Define a custom handler for displaying folded code. ----
	local handler = function(virtText, lnum, endLnum, width, truncate)
		local newVirtText = {}
		local suffix = (" 󰁂 %d lines"):format(endLnum - lnum)
		local sufWidth = vim.fn.strdisplaywidth(suffix)
		local targetWidth = width - sufWidth
		local curWidth = 0

		-- ... --
		for _, chunk in ipairs(virtText) do
			local chunkText = chunk[1]
			local chunkWidth = vim.fn.strdisplaywidth(chunkText)

			-- ... --
			if targetWidth > curWidth + chunkWidth then
				table.insert(newVirtText, chunk)
			else
				chunkText = truncate(chunkText, targetWidth - curWidth)
				local hlGroup = chunk[2]
				table.insert(newVirtText, { chunkText, hlGroup })
				chunkWidth = vim.fn.strdisplaywidth(chunkText)
				-- ... --
				if curWidth + chunkWidth < targetWidth then
					suffix = suffix
						.. (" "):rep(targetWidth - curWidth - chunkWidth)
				end
				break
			end
			curWidth = curWidth + chunkWidth
		end

		-- Add the fold count suffix with a subtle highlight
		table.insert(newVirtText, { suffix, "Comment" })

		return newVirtText
	end

	---- Configure basic UFO  with custom fold display. ----
	ufo.setup({
		-- Utilize treesitter & indent for code folding engines. --
		-- Note: Can choose LSP for a language-aware engine also. --
		provider_selector = function(bufnr, filetype, buftype)
			return { "treesitter", "indent" }
		end,
		-- Start with all folds open. --
		open_fold_hl_timeout = 0,
		-- Utilize the custom fold text handler. --
		fold_virt_text_handler = handler,
		enable_fold_end_virt_text = false,
	})

	---- Set native folding configuration in NeoVim. ----
	-- Set the fold level upon opening a file (high = unfolded). --
	vim.o.foldlevel = 99
	vim.o.foldlevelstart = 99
	-- Enable code folding capabilities. -
	vim.o.foldenable = true
	-- Define the depth of indenting to display in the code column. --
	vim.o.foldcolumn = "0"
	-- Define the fold column characters to be displayed.--
	vim.o.fillchars = [[eob: ,fold: ,foldopen:▾,foldsep: ,foldclose:▸]]

	---- Create custom keymaps for precise code folding operations. ----
	-- Create a keymap to fold the target block/scope inwards (fold). --
	vim.keymap.set("n", "<leader>fi", "zc", { desc = "Fold current block" })

	-- Create a keymap to fold the target block/scope outwards (unfold). --
	vim.keymap.set("n", "<leader>fo", "zo", { desc = "Unfold current block" })

	-- Create a keymap to fold everything in the file inwards (folded). --
	vim.keymap.set(
		"n",
		"<leader>Fi",
		ufo.closeAllFolds,
		{ desc = "Fold all in file" }
	)
	-- Create a keymap to fold everything in the file outwords (unfolded). --
	vim.keymap.set(
		"n",
		"<leader>Fo",
		ufo.openAllFolds,
		{ desc = "Unfold all in file" }
	)
	-- Create a keymap to bring up a preview window of folded code. --
	vim.keymap.set("n", "<leader>fp", function()
		local winid = require("ufo").peekFoldedLinesUnderCursor()
		if not winid then
			vim.lsp.buf.hover()
		end
	end, { desc = "Preview folded code" })
end

---- Define the Lua table to pass to Lazy for plugin management ----
return {
	-- Define the plugin installation source. --
	"kevinhwang91/nvim-ufo",
	-- Define the event trigger(s) for the plugin. --
	event = "BufReadPost",
	-- Define the plugin dependencies. --
	dependencies = {
		"kevinhwang91/promise-async",
		"nvim-treesitter/nvim-treesitter",
	},
	-- Define the plugin-specific configuration. --
	config = ufo_config,
}
