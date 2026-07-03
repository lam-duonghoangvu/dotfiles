return {
  {
    'nvim-telescope/telescope.nvim', version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
      require('telescope').setup({
        defaults = {
          file_ignore_patterns = { "%.git/" },
        },
      })

      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', function()
        builtin.find_files({ hidden = true })
      end, { desc = 'Telescope find files' })

      vim.keymap.set('n', '<leader>fg', function()
        builtin.live_grep({
          additional_args = function(args)
            return vim.list_extend(args, { "--hidden" })
          end
        })
      end, { desc = 'Telescope live grep' })
    end,
  },
}
