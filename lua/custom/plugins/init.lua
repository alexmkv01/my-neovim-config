return {
  {
    'nvimtools/none-ls.nvim',
    dependencies = {
      'nvimtools/none-ls-extras.nvim',
    },
    config = function()
      local null_ls = require 'null-ls'
      -- Only non-Python formatters here.
      -- Python linting: ruff_lsp (single source of truth)
      -- Python formatting: conform.nvim
      local sources = {
        null_ls.builtins.formatting.prettier.with { filetypes = { 'json', 'yaml', 'markdown' } },
        null_ls.builtins.formatting.shfmt.with { args = { '-i', '4' } },
      }

      local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
      null_ls.setup {
        sources = sources,
        on_attach = function(client, bufnr)
          if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = augroup,
              buffer = bufnr,
              callback = function()
                -- Skip formatting for Python files (handled by conform.nvim)
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
  -- nvim-lint configured in kickstart/plugins/lint.lua (mypy only, ruff via ruff_lsp)
  require 'custom.plugins.lazygit',
  require 'custom.plugins.octo',
  require "custom.plugins.snacks",
  require "custom.plugins.breadcrumbs",
  require "custom.plugins.persistence",
  require 'custom.plugins.flash',

  {
    'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    config = function()
      require('lsp_lines').setup()

      -- Toggle lsp_lines on/off with <leader>tl
      local lsp_lines_enabled = true
      vim.keymap.set('n', '<leader>tl', function()
        lsp_lines_enabled = not lsp_lines_enabled
        vim.diagnostic.config {
          virtual_lines = lsp_lines_enabled and { only_current_line = true } or false,
        }
        -- Force the lsp_lines show handler to re-run so it picks up the new config
        -- and correctly sets up (or tears down) the CursorMoved autocmd.
        vim.diagnostic.show()
      end, { desc = '[T]oggle [L]SP lines diagnostics' })
    end,
  },

  {
    'h3pei/copy-file-path.nvim',
    config = function()
      vim.keymap.set('n', '<leader>fp', ':CopyRelativeFilePath<CR>', { desc = '[F]ile [P]ath (copy relative)' })
    end,
  },
}
