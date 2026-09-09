vim.diagnostic.config({
	virtual_text = false,
	virtual_lines = { current_line = true },
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		header = "",
		prefix = "",
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})
