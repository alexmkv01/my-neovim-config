return {
  'folke/persistence.nvim',
  event = 'BufReadPre', -- or "FileType"
  module = "persistence",
  config = function()
    require("persistence").setup {
      dir = vim.fn.stdpath("data") .. "/sessions/", -- directory where sessions will be saved
      options = {
        "buffers",
        "curdir",
        "folds",
        "help",
        "tabpages",
        "winsize",
        "winpos",
        "terminal",
      }, -- sessionoptions used for saving
    }
  end,

  init = function()
    local augroup = vim.api.nvim_create_augroup("Persistence", { clear = true })
    vim.api.nvim_create_autocmd("VimResized", { -- auto-save when window is resized
      group = augroup,
      callback = function()
        require("persistence").save()
      end,
    })
    vim.api.nvim_create_autocmd("VimLeavePre", { -- auto-save on quit
      group = augroup,
      callback = function()
        require("persistence").save()
      end,
    })

    vim.api.nvim_create_user_command("SaveSession", function()
      require("persistence").save()
    end, {})
  end,

  keys = {
    { "<leader>s", function() require("persistence").load() end, desc = "Restore last session" },
  },
}
