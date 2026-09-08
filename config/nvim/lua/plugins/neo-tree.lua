require("neo-tree").setup({
	window = {
		position = "current",
	},
	filesystem = {
		hijack_netrw_behavior = "open_default",
		filtered_items = {
			visible = true,
			hide_dotfiles = false,
			hide_gitignored = false,
		},
	},
})

vim.keymap.set("n", "<leader>nf", "<cmd>Neotree toggle filesystem float<CR>", { silent = true })
