return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "ts_ls", "pyright" }, 
      })
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- Allows cmp to get hints from your LSP
      "L3MON4D3/LuaSnip",     -- Required snippet engine snippet support
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args) require("luasnip").lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(), -- Force trigger hints
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Enter to accept hint
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item() else fallback() end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim-lsp" }, -- Pull hints from the running LSP
        }),
      })
    end,
  },
  
  {
    "neovim/nvim-lspconfig",
    config = function()
      local servers = { "lua_ls", "ts_ls", "pyright" }
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      
      for _, server in ipairs(servers) do
        vim.lsp.config(server, {
          capabilities = capabilities, -- Pass capabilities here
        }) 
        vim.lsp.enable(server)
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)      -- Go to definition
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)            -- Show documentation
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)  -- Smart rename variable
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- Code actions
        end,
      })
    end,
  }
}
