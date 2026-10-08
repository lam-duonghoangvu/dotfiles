vim.opt.mouse = "a" -- enable mouse support
vim.opt.clipboard:append("unnamedplus") -- use system clipboard

vim.opt.number = true -- line number
vim.opt.relativenumber = true -- relative line numbers
vim.opt.wrap = false -- do not wrap lines by default
vim.opt.scrolloff = 10 -- keep 10 lines above/below cursor
vim.opt.sidescrolloff = 10 -- keep 10 lines to left/right of cursor

vim.opt.tabstop = 2 -- tabwidth
vim.opt.shiftwidth = 2 -- indent width
vim.opt.softtabstop = 2 -- soft tab stop not tabs on tab/backspace
vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.smartindent = true -- smart auto-indent

vim.opt.ignorecase = true -- case insensitive search

vim.opt.cmdheight = 0 -- hide command row if not use
vim.opt.report = 9999 -- never print "N lines" messages (would force hit-enter with cmdheight=0)
vim.opt.statusline = " %f %=%l/%L, %v" -- left: path, right: line/total, column (expand tabs into spaces)

vim.opt.writebackup = false -- do not write to a backup file
vim.opt.swapfile = false -- do not create a swapfile
vim.opt.undofile = true -- keep undo history (default dir: ~/.local/state/nvim/undo)
vim.opt.updatetime = 300 -- faster completion (default: 4000ms)

vim.diagnostic.config({
	virtual_text = true,
	float = {
		border = "single",
		header = "",
		prefix = "",
	},
	severity_sort = true,
})
