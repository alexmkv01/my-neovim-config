return {
  "folke/snacks.nvim",
  lazy = false,
  opts = {
    -- The snacks that you want to enable.
    -- The value can be a boolean, a table of options or a function that returns a table of options.
    image = { enabled = true }, -- enable the image viewer
    scratch = { enabled = true },
    terminal = { enabled = true },
    dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
    },
    -- You can also pass options to the plugins.
    -- For example to configure `zen.nvim` which is part of snacks.
    zen = {
      window = {
        options = {
          -- set the width to 100 characters.
          textwidth = 100,
        },
      },
    },
  },
}