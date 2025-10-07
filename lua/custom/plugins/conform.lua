return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        python = { "ruff_isort", "ruff_format", "ruff_fix" },
        lua = { "stylua" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        sh = { "shfmt" },
      },
      format_on_save = {
        timeout_ms = 1000,
        lsp_fallback = true,
      },
      formatters = {
        ruff_isort = {
          command = vim.fn.expand("~/.local/share/nvim/mason/bin/ruff"),
          args = { 
            "check", 
            "--select", "I,F401",  -- I for import sorting, F401 for unused imports
            "--fix",
            "--stdin-filename", "$FILENAME", 
            "-" 
          },
          stdin = true,
        },
        ruff_format = {
          command = vim.fn.expand("~/.local/share/nvim/mason/bin/ruff"),
          args = { "format", "--stdin-filename", "$FILENAME", "-" },
          stdin = true,
        },
        ruff_fix = {
          command = vim.fn.expand("~/.local/share/nvim/mason/bin/ruff"),
          args = { 
            "check", 
            "--fix",
            "--stdin-filename", "$FILENAME", 
            "-" 
          },
          stdin = true,
        },
      },
    },
  },
}