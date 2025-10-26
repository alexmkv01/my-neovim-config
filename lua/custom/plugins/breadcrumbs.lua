return {
  {
    "SmiteshP/nvim-navic",
    dependencies = "neovim/nvim-lspconfig",
    opts = {
      lsp = {
        auto_attach = true,
      },
      highlight = true,
      separator = " > ",
      depth_limit = 5,
    },
    config = function(_, opts)
      require("nvim-navic").setup(opts)
    end,
  },
  {
    "LunarVim/breadcrumbs.nvim",
    dependencies = "SmiteshP/nvim-navic",
    opts = {},
    config = function()
      require("breadcrumbs").setup()
    end,
  },
}
