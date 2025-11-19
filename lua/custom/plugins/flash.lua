return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  opts = {
    modes = {
      char = {
        enabled = false,
      },
    },
    search = {
      mode = 'search',
      incremental = false,
    },
    label = {
      uppercase = false,
      before = true,
      after = true,
    },
    highlight = {
      backdrop = true,
      matches = true,
    },
  },
  keys = {
    {
      'f',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').jump()
      end,
      desc = 'Flash',
    },
  },
}
