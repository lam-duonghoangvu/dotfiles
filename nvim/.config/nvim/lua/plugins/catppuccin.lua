return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        integrations = {
          neotree = true,
        },
        custom_highlights = function(colors)
          return {
            NeoTreeNormal = { bg = "NONE" },
            NeoTreeNormalNC = { bg = "NONE" },
            NeoTreeEndOfBuffer = { bg = "NONE" },
          }
        end,
      })
      vim.cmd.colorscheme "catppuccin-nvim"
    end,
  },
}
