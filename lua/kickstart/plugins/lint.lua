return {

  { -- Linting (mypy only — ruff linting handled by ruff_lsp)
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'

      -- Override the mypy linter entirely with a custom definition.
      -- Key change: cmd is a FUNCTION that dynamically resolves to the project's
      -- .venv/bin/mypy (so it has access to dataframely, etc.), falling back to Mason's.
      lint.linters.mypy = {
        cmd = function()
          local buf_path = vim.api.nvim_buf_get_name(0)
          local dir = buf_path ~= '' and vim.fn.fnamemodify(buf_path, ':h') or vim.fn.getcwd()
          while dir and dir ~= '/' do
            local venv_mypy = dir .. '/.venv/bin/mypy'
            if vim.uv.fs_stat(venv_mypy) then
              return venv_mypy
            end
            dir = vim.fn.fnamemodify(dir, ':h')
          end
          return 'mypy'
        end,
        stdin = false,
        stream = 'both',
        ignore_exitcode = true,
        args = {
          '--show-column-numbers',
          '--show-error-end',
          '--hide-error-context',
          '--no-color-output',
          '--no-error-summary',
          '--no-pretty',
        },
        parser = require('lint.parser').from_pattern(
          '([^:]+):(%d+):(%d+):(%d+):(%d+): (%a+): (.*) %[(%a[%a-]+)%]',
          { 'file', 'lnum', 'col', 'end_lnum', 'end_col', 'severity', 'message', 'code' },
          {
            error = vim.diagnostic.severity.ERROR,
            warning = vim.diagnostic.severity.WARN,
            note = vim.diagnostic.severity.HINT,
          },
          { ['source'] = 'mypy' },
          { end_col_offset = 0 }
        ),
      }

      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
        python = { 'mypy' }, -- ruff linting via ruff_lsp, not here
      }

      -- Run mypy on save and buffer enter (not on every keystroke)
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost' }, {
        group = lint_augroup,
        callback = function()
          if vim.bo.modifiable then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
