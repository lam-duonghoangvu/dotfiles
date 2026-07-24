return {
	"stevearc/conform.nvim",
	dependencies = { "williamboman/mason.nvim" },
	opts = {},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_format", "ruff_organize_imports" },
				rust = { "rustfmt" },
				go = { "gofmt", "goimports" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				javascriptreact = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", "prettier", stop_after_first = true },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		})

		-- Auto installing formatters
		local mason_registry = require("mason-registry")
		local formatters = {
			"stylua",
			"ruff",
			"rustfmt",
			"goimports",
			"prettierd",
			"prettier",
		}

		for _, tool in ipairs(formatters) do
			if mason_registry.has_package(tool) then
				local mason_package = mason_registry.get_package(tool)
				if not mason_package:is_installed() then
					mason_package:install()
				end
			end
		end

		vim.keymap.set("n", "<leader>f", function()
			require("conform").format({ bufnr = 0 })
		end)
	end,
}
