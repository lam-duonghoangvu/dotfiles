require("options")
require("keymaps")
require("commands")
require("diagnostics")
require("pack")

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		if vim.fn.argc() == 0 then
			require("mini.files").open(vim.fn.getcwd())
		end
	end,
})
