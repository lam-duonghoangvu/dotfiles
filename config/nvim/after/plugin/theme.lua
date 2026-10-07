vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim" },
})

-- Colorscheme
require("catppuccin").setup({
	flavour = "mocha",
	transparent_background = true,
	float = {
		transparent = true,
		solid = false,
	},
})
vim.cmd.colorscheme("catppuccin")
