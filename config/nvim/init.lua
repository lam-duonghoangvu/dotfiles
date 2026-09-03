require("core.keymaps")
require("core.options")
require("core.diagnostics")
require("config.lazy")

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		if vim.fn.argc() == 0 then
			vim.cmd("Neotree filesystem float")
		end
	end,
})
