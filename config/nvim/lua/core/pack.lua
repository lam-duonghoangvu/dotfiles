vim.pack.add({
	-- Colorscheme
	{ src = "https://github.com/catppuccin/nvim", version = vim.version.range("1") },

	-- Files
	{ src = "https://github.com/echasnovski/mini.files" },

	-- Fuzzy finder
	{ src = "https://github.com/ibhagwan/fzf-lua" },

	-- File icons
	{ src = "https://github.com/echasnovski/mini.icons" },

	-- Treesitter
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },

	-- LSP
	{ src = "https://github.com/j-hui/fidget.nvim" },
	{ src = "https://github.com/folke/lazydev.nvim" },

	-- Completion
	{ src = "https://github.com/Saghen/blink.cmp", version = vim.version.range("1") },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },

	-- Formatting
	{ src = "https://github.com/stevearc/conform.nvim" },

	-- Editing
	{ src = "https://github.com/echasnovski/mini.pairs" },

	-- Gitsigns
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },

	-- Harpoon
	{ src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
})

require("plugins.catppuccin")
require("plugins.icons")
require("plugins.files")
require("plugins.fzf")
require("plugins.treesitter")
require("plugins.lsp")
require("plugins.lazydev")
require("plugins.blink")
require("plugins.autoformat")
require("plugins.pairs")
require("plugins.gitsigns")
require("plugins.harpoon")
