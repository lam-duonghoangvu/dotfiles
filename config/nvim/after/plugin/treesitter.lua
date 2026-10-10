-- Update parsers when the plugin updates (must be defined before vim.pack.add)
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(event)
		if event.data.spec.name == "nvim-treesitter" and event.data.kind == "update" then
			if not event.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end
	end,
})

vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

require("nvim-treesitter").install({
	"lua",
	"vim",
	"vimdoc",
	"query",
	"python",
	"rust",
	"go",
	"javascript",
	"typescript",
	"tsx",
	"html",
	"css",
})

vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		if vim.bo.buftype == "" then
			pcall(vim.treesitter.start)
		end
	end,
})
