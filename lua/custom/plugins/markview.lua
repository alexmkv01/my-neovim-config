return {
  "OXY2DEV/markview.nvim",
  lazy = false,

  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },

  config = function()
    require("markview").setup {
      hybrid_modes = { "markdown", "markdown_inline" },
      preview = {
        icon_provider = "internal",
        modes = { "n", "no", "c" },
      },
      markdown = {
        headings = {
          enable = true,
          org_indent = false,
        },
        code_blocks = {
          enable = true,
          pad = 0,
        },
        checkboxes = {
          enable = true,
        },
        list_items = {
          enable = true,
        },
        tables = {
          enable = true,
        },
      },
    }

    -- Keymaps
    local opts = { noremap = true, silent = true }

    -- Toggle preview
    vim.keymap.set("n", "<leader>mp", ":Markview Toggle<CR>", opts)

    -- Toggle hybrid mode (edit + preview)
    vim.keymap.set("n", "<leader>mh", ":Markview HybridToggle<CR>", opts)

    -- Toggle splitview (side-by-side)
    vim.keymap.set("n", "<leader>ms", ":Markview splitToggle<CR>", opts)
  end,
}
