-- Notification
vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.notify" },
})

require("mini.notify").setup({
	-- Remove default timestamp shown
	content = {
		format = function(notif)
			return notif.msg
		end,
	},
	-- Remove obvious "Notification" title
	window = { config = { title = "" } },
})
