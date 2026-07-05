return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "dracula",
          globalstatus = true,
          component_separators = { left = "｜", right = "｜" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { { "mode", separator = { left = "", right = "" }, right_padding = 2 } },
          lualine_b = { "filename", "branch", "diff" },
          lualine_c = { "diagnostics" },
          lualine_x = { "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { { "location", separator = { left = "", right = "" }, left_padding = 2 } },
        },
      })
    end,
  },
}
