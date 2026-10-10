vim.pack.add({
	{ src = "https://github.com/Saghen/blink.cmp", version = vim.version.range("1") },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/folke/lazydev.nvim" },
})

-- Autocomplete
require("blink.cmp").setup({ cmdline = { completion = { menu = { auto_show = true } } } })

-- Autoformat
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_organize_imports", "ruff_format" },
		go = { "gofmt" },
		["_"] = { "dprint" },
	},
	format_on_save = {},
})

-- LSP for Neovim Lua
require("lazydev").setup()
