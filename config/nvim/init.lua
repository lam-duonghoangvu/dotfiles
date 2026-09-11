require("options")
require("keymaps")
require("commands")
require("diagnostics")

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		if vim.fn.argc() == 0 then
			require("fzf-lua").files()
		end
	end,
})
