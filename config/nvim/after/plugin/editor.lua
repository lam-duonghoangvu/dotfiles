vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.diff" },
})

-- Git diff
require("mini.diff").setup({ view = { style = "sign" } })
