vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.files" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
})

-- File tree
require("mini.files").setup({
	windows = {
		width_focus = 25,
		width_nofocus = 12,
	},
})

vim.api.nvim_create_autocmd("User", {
	pattern = "MiniFilesWindowOpen",
	callback = function(args)
		vim.api.nvim_win_set_config(args.data.win_id, { border = "rounded" })
	end,
})

vim.keymap.set("n", "<CR>", function()
	MiniFiles.go_in({ close_on_file = true })
end, { desc = "Open file / enter dir" })

vim.keymap.set("n", "<Esc>", function()
	MiniFiles.close()
end, { desc = "Close explorer" })

vim.keymap.set("n", "<leader>e", function()
	if MiniFiles.close() then
		return
	end
	MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
end, { desc = "File explorer" })

-- Fuzzy finder
require("fzf-lua")

vim.keymap.set("n", "<leader>ff", FzfLua.files, { desc = "[F]ind [F]iles" })
vim.keymap.set("n", "<leader>fg", FzfLua.live_grep, { desc = "[F]ind by [G]rep" })
vim.keymap.set("n", "<leader>fd", FzfLua.diagnostics_workspace, { desc = "[F]ind [D]iagnostics" })
vim.keymap.set("n", "<leader>f", FzfLua.resume, { desc = "Resume [F]ind" })
