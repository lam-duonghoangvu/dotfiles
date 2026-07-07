return {
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
      require('telescope').setup({
        defaults = {
          sorting_strategy = "ascending",
          layout_config = {
            prompt_position = "top",
          },
          file_ignore_patterns = { "%.git/" },
        },
      })

      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', function()
        builtin.find_files({ hidden = true })
      end, { desc = 'Telescope find files' })

      vim.keymap.set('n', '<leader>fg', function()
        builtin.live_grep({
          additional_args = function(opts)
            return { "--hidden" }
          end
        })
      end, { desc = 'Telescope live grep' })

      vim.keymap.set('n', '<leader>fd', function()
        builtin.diagnostics({ bufnr = 0 })
      end, { desc = 'Telescope document diagnostics' })

      vim.keymap.set('n', '<leader>fD', builtin.diagnostics, { desc = 'Telescope workspace diagnostics' })
    end,
  },
}
