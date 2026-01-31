return {
  {
    'quarto-dev/quarto-nvim',
    ft = { 'markdown' },
    dependencies = {
      'jmbuhr/otter.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      lspFeatures = {
        enabled = true,
        languages = { 'python' },
        chunks = 'all',
        diagnostics = {
          enabled = true,
          triggers = { 'BufWritePost' },
        },
        completion = {
          enabled = true,
        },
      },
      codeRunner = {
        enabled = true,
        default_method = 'molten',
      },
    },
    config = function(_, opts)
      require('quarto').setup(opts)
      
      -- Manual command to activate notebook LSP if auto-activation fails
      vim.api.nvim_create_user_command('NotebookLSP', function()
        print('[Notebook] Manual activation requested')
        require('quarto').activate()
        vim.defer_fn(function()
          require('otter').activate({'python'}, true)
          vim.b.otter_activated = true
          vim.notify('✓ Notebook LSP manually activated!', vim.log.levels.INFO)
          print('[Notebook] Manual activation complete')
        end, 300)
      end, { desc = 'Manually activate notebook LSP' })
    end,
  },
  {
    'jmbuhr/otter.nvim',
    ft = { 'markdown' },
    opts = {
      buffers = {
        set_filetype = true,
      },
      handle_leading_whitespace = true,
    },
  },
}
