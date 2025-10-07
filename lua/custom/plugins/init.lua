return {
  {
    'nvimtools/none-ls.nvim',
    dependencies = {
      'nvimtools/none-ls-extras.nvim',
    },
    config = function()
      local null_ls = require 'null-ls'
      local sources = {
        null_ls.builtins.formatting.prettier.with { filetypes = { 'json', 'yaml', 'markdown' } },
        null_ls.builtins.formatting.shfmt.with { args = { '-i', '4' } },
        -- Remove ruff_format as it conflicts with W292 (removes trailing newlines)
        -- Only use ruff for diagnostics/linting
        require 'none-ls.diagnostics.ruff',
      }

      local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
      null_ls.setup {
        sources = sources,
        -- Format on save (but not for Python - handled by ruff LSP)
        on_attach = function(client, bufnr)
          if client.supports_method 'textDocument/formatting' then
            vim.apiнын .nvim_clear_autocmds { group = augroup, buffer = bufnr }
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = augroup,
              buffer = bufnr,
              callback = function()
                -- Skip formatting for Python files (handled by ruff LSP)
                if vim.bo.filetype ~= 'python' then
                  vim.lsp.buf.format()
                end
              end,
            })
          end
        end,
      }
    end,
  },
  {
    'jay-babu/mason-null-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('mason-null-ls').setup {
        ensure_installed = {
          'ruff', -- Python linter/formatter
          'mypy', -- Python type checker
          'prettier', -- Web formatter
          'shfmt', -- Shell script formatter
        },
        automatic_installation = true,
      }
    end,
  },
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = lint.linters_by_ft or {}
    end,
  },
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('bufferline').setup {
        options = {
          mode = 'buffers',
          separator_style = 'slant',
          always_show_bufferline = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          color_icons = true,
        },
      }

      -- Keymaps for buffer navigation
      vim.keymap.set('n', '<S-Tab>', ':BufferLineCycleNext<CR>', { desc = 'Next buffer' })
      vim.keymap.set('n', '<C-S-Tab>', ':BufferLineCyclePrev<CR>', { desc = 'Previous buffer' })
      vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { desc = 'Delete buffer' })
      vim.keymap.set('n', '<leader>bo', ':BufferLineCloseOthers<CR>', { desc = 'Close other buffers' })
      vim.keymap.set('n', '<leader>bp', ':BufferLineTogglePin<CR>', { desc = 'Pin buffer' })
    end,
  },
  require 'custom.plugins.ai',
  require 'custom.plugins.lazygit',
  require 'custom.plugins.octo',
  {
    'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    config = function()
      require('lsp_lines').setup()
    end,
  },
}