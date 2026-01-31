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
          if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
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
    end,
  },

  {
    'h3pei/copy-file-path.nvim',
    config = function()
      vim.keymap.set('n', '<leader>fp', ':CopyRelativeFilePath<CR>', { desc = '[F]ile [P]ath (copy relative)' })
    end,
  },
}
