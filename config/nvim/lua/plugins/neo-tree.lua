require("neo-tree").setup({
	popup_border_style = "rounded",
	window = {
		position = "current",
	},
	filesystem = {
		filtered_items = {
			visible = true,
			hide_dotfiles = false,
			hide_gitignored = false,
		},
	},
})

vim.keymap.set("n", "<leader>nf", "<cmd>Neotree toggle filesystem float<CR>", { silent = true })
