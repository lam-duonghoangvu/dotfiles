vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.files" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
})

-- File explorer
require("mini.files").setup({
	-- Remove file icons
	content = { prefix = function() end },
	mappings = { close = "<Esc>", go_in_plus = "<CR>" },
})

vim.keymap.set("n", "<leader>e", function()
	if not MiniFiles.close() then
		MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
	end
end, { desc = "File explorer" })

-- Fuzzy finder
require("fzf-lua")

vim.keymap.set("n", "<leader>ff", FzfLua.files, { desc = "[F]ind [F]iles" })
vim.keymap.set("n", "<leader>fg", FzfLua.live_grep, { desc = "[F]ind by [G]rep" })
vim.keymap.set("n", "<leader>fd", FzfLua.diagnostics_workspace, { desc = "[F]ind [D]iagnostics" })
vim.keymap.set("n", "<leader>fr", FzfLua.resume, { desc = "[F]ind [R]esume" })
