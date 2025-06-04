---- Neogen: Automatic docstring generation plugin for Neovim. ----
---- Define the config function specific to the Neogen plugin. ----
local function neogen_config()
	---- Configure Neogen. ----
	local neogen = require("neogen")
	neogen.setup({
		-- Enable integration with LuaSnip as the snippet engine. --
		snippet_engine = "luasnip",

		---- Configure docstring templates for specific languages. ----
		languages = {
			-- Configure Google Style Guide docstrings for Python. --
			python = {
				template = {
					annotation_convention = "google_docstrings",
					-- 👇 Add this to force docstring placement inside the function
					location = "after",
				},
			},
			-- Configure LuaDoc docstrings for Lua. --
			lua = {
				template = {
					annotation_convention = "ldoc",
				},
			},
			-- Configure JSdoc docstrings for JS. --
			javascript = {
				template = {
					annotation_convention = "jsdoc",
				},
			},
			-- Configure RustDoc style docstrings for Rust. --
			rust = {
				template = {
					annotation_convention = "rustdoc",
				},
			},
		},

		---- Configure doc generation behavior. ----
		enable_placeholders = true,
		placeholders_hl = "Comment",
		-- Enable automatic docstring generation triggers. --
		enabled = true,
	})

	---- Create keymaps for auto-generating docstrings. ----
	-- Generate function documentation. --
	vim.keymap.set("n", "<leader>df", function()
		neogen.generate({ type = "func" })
	end, { desc = "Generate function docstring" })

	-- Generate class documentation. --
	vim.keymap.set("n", "<leader>dc", function()
		neogen.generate({ type = "class" })
	end, { desc = "Generate class docstring" })

	-- Generate type documentation. --
	vim.keymap.set("n", "<leader>dt", function()
		neogen.generate({ type = "type" })
	end, { desc = "Generate type docstring" })

	-- Generate file documentation. --
	vim.keymap.set("n", "<leader>dF", function()
		neogen.generate({ type = "file" })
	end, { desc = "Generate file docstring" })
end

---- Define the Lua table to pass to Lazy for plugin management. ----
return {
	-- Define the plugin installation source. --
	"danymat/neogen",
	-- Define when to load the plugin. --
	event = { "BufReadPre", "BufNewFile" },
	-- Define the plugin dependencies. --
	dependencies = {
		-- TreeSitter for parsing code structure --
		"nvim-treesitter/nvim-treesitter",
		-- LuaSnip for snippet handling --
		"L3MON4D3/LuaSnip",
	},
	-- Define the plugin-specific configuration. --
	config = neogen_config,
}
