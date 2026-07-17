return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		lazy = false,
		config = function()
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

			vim.keymap.set("n", "<leader>nf", ":Neotree filesystem float<CR>", { silent = true })
			vim.keymap.set("n", "<leader>nb", ":Neotree buffers float<CR>", { silent = true })
			vim.keymap.set("n", "<leader>ng", ":Neotree git_status float<CR>", { silent = true })
		end,
	},
}
