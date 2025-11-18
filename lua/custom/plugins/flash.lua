return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  opts = {
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
      's',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').jump()
      end,
      desc = 'Flash',
    },
  },
}
