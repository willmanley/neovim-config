---- nvim-cmp: Neovim's completion plugin with snippets support ----
---- Define the config function specific to the nvim-cmp plugin. ----
local function cmp_config()
	---- Load required modules ----
	local cmp = require("cmp")
	local luasnip = require("luasnip")
	local lspkind = require("lspkind")

	---- Configure snippet engine ----
	require("luasnip.loaders.from_vscode").lazy_load()

	---- Helper function to check if text exists before cursor ----
	local has_words_before = function()
		local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
		return col ~= 0
			and vim.api
					.nvim_buf_get_lines(0, line - 1, line, true)[1]
					:sub(col, col)
					:match("%s")
				== nil
	end

	---- Configure completion behavior ----
	cmp.setup({
		-- Enable snippet support --
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},

		-- Configure window appearance --
		window = {
			-- Completion window styling --
			completion = cmp.config.window.bordered({
				border = "rounded",
				winhighlight = "Normal:CmpNormal",
			}),
			-- Documentation window styling --
			documentation = cmp.config.window.bordered({
				border = "rounded",
				winhighlight = "Normal:CmpDocNormal",
			}),
		},

		-- Configure completion sources --
		sources = cmp.config.sources({
			-- LSP suggestions --
			{ name = "nvim_lsp", priority = 1000 },
			-- Snippet suggestions --
			{ name = "luasnip", priority = 750 },
			-- Buffer word suggestions --
			{ name = "buffer", priority = 500 },
			-- File path suggestions --
			{ name = "path", priority = 250 },
		}),

		-- Configure formatting of completion items --
		formatting = {
			format = lspkind.cmp_format({
				mode = "symbol_text",
				maxwidth = 50,
				ellipsis_char = "...",
				-- Show source in completion menu --
				menu = {
					nvim_lsp = "[LSP]",
					luasnip = "[Snippet]",
					buffer = "[Buffer]",
					path = "[Path]",
				},
			}),
		},

		-- Configure completion behavior --
		completion = {
			-- Show completion menu even with single item --
			completeopt = "menu,menuone,noinsert",
		},

		-- Configure key mappings --
		mapping = cmp.mapping.preset.insert({
			-- Scroll documentation up --
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			-- Scroll documentation down --
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			-- Open completion menu --
			["<C-Space>"] = cmp.mapping.complete(),
			-- Close completion menu --
			["<C-e>"] = cmp.mapping.abort(),
			-- Confirm selection --
			["<CR>"] = cmp.mapping.confirm({ select = false }),

			-- Navigate through completions --
			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				elseif has_words_before() then
					cmp.complete()
				else
					fallback()
				end
			end, { "i", "s" }),

			-- Navigate backwards through completions --
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, { "i", "s" }),
		}),

		-- Configure sorting behavior --
		sorting = {
			priority_weight = 2,
			comparators = {
				cmp.config.compare.offset,
				cmp.config.compare.exact,
				cmp.config.compare.score,
				cmp.config.compare.recently_used,
				cmp.config.compare.kind,
				cmp.config.compare.sort_text,
				cmp.config.compare.length,
				cmp.config.compare.order,
			},
		},

		-- Configure experimental features --
		experimental = {
			-- Enable ghost text --
			ghost_text = true,
		},
	})

	---- Configure specific completion menu for command mode ----
	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "path" },
			{ name = "cmdline" },
		}),
	})

	---- Configure specific completion menu for search mode ----
	cmp.setup.cmdline({ "/", "?" }, {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = "buffer" },
		},
	})
end

---- Define the Lua table to pass to Lazy for plugin management. ----
return {
	-- Define the plugin installation source --
	"hrsh7th/nvim-cmp",
	-- Define when to load the plugin --
	event = { "InsertEnter", "CmdlineEnter" },
	-- Define the plugin dependencies --
	dependencies = {
		-- LSP completion source
		"hrsh7th/cmp-nvim-lsp",
		-- Buffer word completion source
		"hrsh7th/cmp-buffer",
		-- Path completion source
		"hrsh7th/cmp-path",
		-- Command line completion source
		"hrsh7th/cmp-cmdline",
		-- Snippet engine
		"L3MON4D3/LuaSnip",
		-- VSCode snippet collection
		"rafamadriz/friendly-snippets",
		-- VSCode-like pictograms
		"onsails/lspkind.nvim",
	},
	-- Define the plugin-specific configuration --
	config = cmp_config,
}
