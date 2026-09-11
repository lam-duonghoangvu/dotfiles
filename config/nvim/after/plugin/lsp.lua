vim.pack.add({
	{ src = "https://github.com/Saghen/blink.cmp", version = vim.version.range("1") },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/folke/lazydev.nvim" },
})

-- Autocomplete
local blink = require("blink.cmp")

blink.setup({
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
		default = { "lsp", "buffer" },
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

-- Autoformat
local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_format", "ruff_organize_imports" },
		go = { "gofmt", "goimports" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "prettierd", "prettier", stop_after_first = true },
		javascriptreact = { "prettierd", "prettier", stop_after_first = true },
		typescriptreact = { "prettierd", "prettier", stop_after_first = true },
		markdown = { "prettierd", "prettier", stop_after_first = true },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

-- LSP
vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
})

vim.lsp.config("ruff", {
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
})

vim.lsp.config("gopls", {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_markers = { "go.work", "go.mod", ".git" },
})

vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc", ".stylua.toml", "stylua.toml", ".git" },
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

vim.lsp.enable({ "ruff", "gopls", "lua_ls" })

-- LSP for Neovim Lua
require("lazydev").setup({
	library = {
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
	},
})
