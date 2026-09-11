vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.pairs" },
	{ src = "https://github.com/nvim-mini/mini.diff" },
})

-- Writing experience
require("mini.pairs").setup()

-- Git diff
require("mini.diff").setup({
	view = {
		style = "sign",
	},
})
