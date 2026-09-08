vim.api.nvim_create_user_command("PackCheck", function()
	local non_active = vim.iter(vim.pack.get())
		:filter(function(x)
			return not x.active
		end)
		:map(function(x)
			return x.spec.name
		end)
		:totable()

	if #non_active == 0 then
		vim.notify("No non-active plugins found!", vim.log.levels.INFO)
		return
	end

	vim.print("Non-active plugins :")
	print(" ")
	for _, name in ipairs(non_active) do
		print(name)
	end

	print(" ")

	local choice = vim.fn.confirm(
		"Delete ALL non-active plugins from disk?",
		"&Yes\n&No",
		2 -- default = No
	)

	if choice == 1 then
		vim.pack.del(non_active)
		vim.notify("Deleted " .. #non_active .. " non-active plugin(s)", vim.log.levels.INFO)
		print("Non-active plugins deleted!")
		vim.api.nvim_exec_autocmds("User", { pattern = "PackChanged" })
	else
		vim.notify("Cancelled. No plugins were deleted!", vim.log.levels.INFO)
	end
end, { desc = "List non active plugins and select to delete" })
