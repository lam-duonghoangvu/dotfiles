local fzf = require("fzf-lua")

fzf.setup({
	fzf_opts = {
		["--layout"] = "reverse",
	},
	files = {
		fd_opts = "--color=never --type f --type l --hidden --no-ignore --exclude .git",
	},
	grep = {
		rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --hidden -g !.git/ -e",
	},
})

vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "[F]ind [F]iles" })
vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "[F]ind by [G]rep" })
vim.keymap.set("n", "<leader>fd", fzf.diagnostics_workspace, { desc = "[F]ind [D]iagnostics" })
vim.keymap.set("n", "<leader>f", fzf.resume, { desc = "[F]ind [R]esume" })
