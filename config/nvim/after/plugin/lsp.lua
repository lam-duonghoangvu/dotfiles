vim.pack.add({
	{ src = "https://github.com/Saghen/blink.cmp", version = vim.version.range("1") },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/folke/lazydev.nvim" },
})

-- Autocomplete
require("blink.cmp").setup({
	completion = {
		menu = {
			border = "single",
			draw = {
				columns = {
					{ "label", "label_description", gap = 1 },
					{ "kind", gap = 1 },
				},
			},
		},
	},

	cmdline = { completion = { menu = { auto_show = true } } },
})

-- Autoformat
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_format", "ruff_organize_imports" },
		go = { "gofmt" },
		javascript = { "dprint" },
		typescript = { "dprint" },
		javascriptreact = { "dprint" },
		typescriptreact = { "dprint" },
		markdown = { "dprint" },
	},
	format_on_save = {},
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
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim" } },
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
