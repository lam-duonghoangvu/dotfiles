local virtual_text_config = {
	spacing = 4,
	source = "if_many",
	prefix = "●",
}

vim.diagnostic.config({
	virtual_text = virtual_text_config,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		header = "",
		prefix = "",
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󱔁 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

vim.keymap.set("n", "<leader>td", function()
	local current = vim.diagnostic.config().virtual_text
	if current then
		vim.diagnostic.config({ virtual_text = false })
		vim.notify("Inline diagnostics disabled", vim.log.levels.INFO)
	else
		vim.diagnostic.config({ virtual_text = virtual_text_config })
		vim.notify("Inline diagnostics enabled", vim.log.levels.INFO)
	end
end, { desc = "Toggle inline diagnostics" })
