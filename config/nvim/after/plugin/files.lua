require("mini.files").setup({
	windows = {
		preview = true,
		width_focus = 25,
		width_nofocus = 12,
		width_preview = 25,
	},
})

vim.api.nvim_create_autocmd("User", {
	pattern = "MiniFilesWindowOpen",
	callback = function(args)
		vim.api.nvim_win_set_config(args.data.win_id, { border = "rounded" })
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "MiniFilesBufferCreate",
	callback = function(args)
		local buf = args.data.buf_id
		vim.keymap.set("n", "<CR>", function()
			require("mini.files").go_in({ close_on_file = true })
		end, { buffer = buf, desc = "Open file / enter dir" })
		vim.keymap.set("n", "<Esc>", function()
			require("mini.files").close()
		end, { buffer = buf, desc = "Close explorer" })
	end,
})

vim.keymap.set("n", "<leader>e", function()
	local mf = require("mini.files")
	if mf.close() then
		return
	end
	local file = vim.api.nvim_buf_get_name(0)
	local reveal = file ~= "" and vim.uv.fs_stat(file) ~= nil
	mf.open(reveal and file or vim.fn.getcwd(), false)
	mf.reveal_cwd()
end, { desc = "File explorer" })

-- Git status colouring
local git_ns = vim.api.nvim_create_namespace("mini_files_git")
local git_marks = {
	[" M"] = { " M", "Changed" },
	["M "] = { "M ", "Changed" },
	["MM"] = { "MM", "Changed" },
	["A "] = { "A ", "Added" },
	["AM"] = { "AM", "Added" },
	["AA"] = { "AA", "Removed" },
	["C "] = { "C ", "Added" },
	["D "] = { "D ", "Removed" },
	[" D"] = { " D", "Removed" },
	["R "] = { "R ", "Changed" },
	["U "] = { "U ", "Removed" },
	["UU"] = { "UU", "Removed" },
	["??"] = { "??", "Added" },
	["!!"] = { "", "Comment" },
}

local function git_apply(buf_id, root, status)
	if not vim.api.nvim_buf_is_valid(buf_id) then
		return
	end
	vim.api.nvim_buf_clear_namespace(buf_id, git_ns, 0, -1)
	for line = 1, vim.api.nvim_buf_line_count(buf_id) do
		local entry = MiniFiles.get_fs_entry(buf_id, line)
		if entry then
			local rel = entry.path:sub(#root + 2)
			local code = status[rel]
			if not code and entry.fs_type == "directory" then
				for path, c in pairs(status) do
					-- roll a child's status up to its folder, but not "ignored"
					if c ~= "!!" and path:sub(1, #rel + 1) == rel .. "/" then
						code = c
						break
					end
				end
			end
			local mark = code and git_marks[code]
			if mark then
				local text = vim.api.nvim_buf_get_lines(buf_id, line - 1, line, false)[1] or ""
				local col = text:find(entry.name, 1, true)
				if col then
					vim.api.nvim_buf_set_extmark(buf_id, git_ns, line - 1, col - 1, {
						end_col = col - 1 + #entry.name,
						hl_group = mark[2],
					})
				end
				if mark[1] ~= "" then
					vim.api.nvim_buf_set_extmark(buf_id, git_ns, line - 1, 0, {
						virt_text = { { mark[1], mark[2] } },
						virt_text_pos = "right_align",
					})
				end
			end
		end
	end
end

local function git_refresh(buf_id)
	local first = MiniFiles.get_fs_entry(buf_id, 1)
	local root = first and vim.fs.root(first.path, ".git")
	if not root then
		return
	end
	vim.system(
		{ "git", "-C", root, "--no-optional-locks", "status", "--porcelain", "--ignored" },
		{ text = true },
		function(out)
			if out.code ~= 0 then
				return
			end
			local status = {}
			for l in out.stdout:gmatch("[^\r\n]+") do
				local xy, path = l:sub(1, 2), l:sub(4)
				path = path:match("%->%s*(.*)") or path
				path = path:gsub('^"(.*)"$', "%1")
				status[path] = xy
			end
			vim.schedule(function()
				git_apply(buf_id, root, status)
			end)
		end
	)
end

vim.api.nvim_create_autocmd("User", {
	pattern = { "MiniFilesBufferCreate", "MiniFilesBufferUpdate" },
	callback = function(args)
		git_refresh(args.data.buf_id)
	end,
})
