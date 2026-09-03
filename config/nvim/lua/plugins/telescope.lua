return {
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			require("telescope").setup({
				defaults = {
					sorting_strategy = "ascending",
					layout_config = {
						prompt_position = "top",
					},
					file_ignore_patterns = { "%.git/" },
				},
			})

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", function()
				builtin.find_files({
					hidden = true,
					no_ignore = true,
				})
			end, { desc = "[F]ind [F]iles" })
			vim.keymap.set("n", "<leader>ft", builtin.builtin, { desc = "[F]ind [T]elescope builtin" })
			vim.keymap.set({ "n", "v" }, "<leader>fw", function()
				builtin.grep_string({
					additional_args = function()
						return { "--hidden" }
					end,
				})
			end, { desc = "[F]ind current [W]ord" })
			vim.keymap.set("n", "<leader>fg", function()
				builtin.live_grep({
					additional_args = function()
						return { "--hidden" }
					end,
				})
			end, { desc = "[F]ind by [G]rep" })
			vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
			vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "[F]ind [R]esume" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find existing [B]uffers" })
		end,
	},
}
