local blink = require("blink.cmp")

blink.setup({
	snippets = { preset = "luasnip" },

	keymap = {
		preset = "default",
		["<C-p>"] = { "select_prev", "fallback" },
		["<C-n>"] = { "select_next", "fallback" },
		["<CR>"] = { "accept", "fallback" },
	},

	completion = {
		list = {
			selection = { preselect = true, auto_insert = false },
		},

		menu = {
			border = "rounded",
			winblend = 0,
			winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
			scrollbar = false,
			draw = {
				gap = 1,
				columns = {
					{ "kind_icon" },
					{ "label", "label_description", gap = 1 },
					{ "kind", gap = 1 },
				},
			},
		},
		ghost_text = { enabled = true },
	},

	sources = {
		default = { "lsp", "snippets", "buffer" },
	},

	cmdline = {
		enabled = true,
		keymap = { preset = "cmdline" },
		completion = { menu = { auto_show = true } },
		sources = function()
			local type = vim.fn.getcmdtype()
			-- Use buffer source for `/` and `?` (search)
			if type == "/" or type == "?" then
				return { "buffer" }
			end
			-- Use cmdline & path source for ':' (command-line)
			if type == ":" or type == "@" then
				return { "cmdline", "path" }
			end
			return {}
		end,
	},
})
