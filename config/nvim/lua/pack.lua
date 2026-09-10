vim.pack.add({
	-- Colorscheme
	{ src = "https://github.com/catppuccin/nvim", version = vim.version.range("1") },

	-- File Icons
	{ src = "https://github.com/nvim-mini/mini.icons" },

	-- Files Explorer
	{ src = "https://github.com/nvim-mini/mini.files" },

	-- Fuzzy Finder
	{ src = "https://github.com/ibhagwan/fzf-lua" },

	-- Notifications
	{ src = "https://github.com/nvim-mini/mini.notify" },

	-- Treesitter
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },

	-- LSP
	{ src = "https://github.com/folke/lazydev.nvim" },

	-- Completion
	{ src = "https://github.com/Saghen/blink.cmp", version = vim.version.range("1") },

	-- Formatting
	{ src = "https://github.com/stevearc/conform.nvim" },

	-- Editing
	{ src = "https://github.com/nvim-mini/mini.pairs" },

	-- Git diff
	{ src = "https://github.com/nvim-mini/mini.diff" },
})
