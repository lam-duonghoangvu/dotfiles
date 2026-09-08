local parsers = {
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
	"gitignore",
}

local group = vim.api.nvim_create_augroup("Treesitter", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = group,
	callback = function()
		if vim.bo.buftype ~= "" then
			return
		end

		pcall(vim.treesitter.start, 0)
	end,
})

pcall(function()
	require("nvim-treesitter").install(parsers)
end)

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(event)
		if event.data.spec and event.data.spec.name == "nvim-treesitter" then
			if not event.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end
	end,
})
