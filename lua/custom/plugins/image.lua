return {
  '3rd/image.nvim',
  version = '1.1.0', -- Pinned for stability with molten.nvim
  cond = function()
    return not vim.g.headless
  end,
  opts = {
    backend = 'kitty',
    integrations = {
      markdown = {
        enabled = false, -- Only use for molten, not markdown files
      },
    },
    max_width = 100,
    max_height = 12,
    max_height_window_percentage = math.huge, -- Important for molten
    max_width_window_percentage = math.huge,
    window_overlap_clear_enabled = true,
    window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },
  },
}
