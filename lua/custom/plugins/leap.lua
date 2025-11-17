return {
  'ggandor/leap.nvim',
  config = function()
    require('leap').setup {}

    -- Map 'f' for leap (searches both forward and backward)
    vim.keymap.set({ 'n', 'x', 'o' }, 'f', '<Plug>(leap)')

    -- Disable default vim 'f' and 'F' to avoid conflicts
    vim.keymap.set('n', 'F', '<Nop>')
  end,
}
