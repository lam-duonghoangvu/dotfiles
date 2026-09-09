local notify = require("mini.notify")

notify.setup({
	content = {
		format = function(notif)
			return notif.msg
		end,
	},
	lsp_progress = {
		enable = true,
	},
	window = {
		config = {
			border = "rounded",
			title = "",
		},
		winblend = 0,
	},
})

vim.notify = notify.make_notify()
