return {
  'GCBallesteros/jupytext.nvim',
  config = function()
    require('jupytext').setup({
      style = 'markdown',
      output_extension = 'md',
      force_ft = 'markdown',
      custom_language_formatting = {},
      jupytext_executable = vim.fn.expand('~/.config/nvim/.venv/bin/jupytext'),
    })
  end,
}
