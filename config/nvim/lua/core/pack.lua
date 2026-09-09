vim.pack.add({
	-- Colorscheme
	{ src = "https://github.com/catppuccin/nvim", version = vim.version.range("1") },

	-- File Icons
	{ src = "https://github.com/nvim-mini/mini.icons" },

	-- Files Explorer
	{ src = "https://github.com/nvim-mini/mini.files" },

	-- Harpoon
	{ src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },

	-- Fuzzy Finder
	{ src = "https://github.com/ibhagwan/fzf-lua" },

	-- Notifications
	{ src = "https://github.com/nvim-mini/mini.notify" },

	-- Treesitter
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },

	-- LSP
	{ src = "https://github.com/folke/lazydev.nvim" },

	-- Completion & Snippets
	{ src = "https://github.com/Saghen/blink.cmp", version = vim.version.range("1") },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },

	-- Formatting
	{ src = "https://github.com/stevearc/conform.nvim" },

	-- Editing
	{ src = "https://github.com/nvim-mini/mini.pairs" },

	-- Gitsigns
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
})

require("plugins.catppuccin")
require("plugins.icons")
require("plugins.files")
require("plugins.harpoon")
require("plugins.fzf")
require("plugins.notify")
require("plugins.treesitter")
require("plugins.lsp")
require("plugins.lazydev")
require("plugins.blink")
require("plugins.autoformat")
require("plugins.pairs")
require("plugins.gitsigns")
