vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim" },
	{ src = "https://github.com/nvim-mini/mini.icons" },
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

-- File icons
require("mini.icons").setup()
