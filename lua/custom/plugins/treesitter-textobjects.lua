return {
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-treesitter.configs').setup {
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj
            keymaps = {
              -- Function selection
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              -- Class selection
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
              -- Block selection
              ['ab'] = '@block.outer',
              ['ib'] = '@block.inner',
              -- Parameter/argument selection
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
              -- Conditional selection
              ['ai'] = '@conditional.outer',
              ['ii'] = '@conditional.inner',
              -- Loop selection
              ['al'] = '@loop.outer',
              ['il'] = '@loop.inner',
            },
            selection_modes = {
              ['@parameter.outer'] = 'v', -- charwise
              ['@function.outer'] = 'V', -- linewise
              ['@class.outer'] = '<c-v>', -- blockwise
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              [']f'] = '@function.outer',
              [']k'] = '@class.outer',
              [']o'] = '@loop.outer',
              [']i'] = '@conditional.outer',
            },
            goto_previous_start = {
              ['[f'] = '@function.outer',
              ['[k'] = '@class.outer',
              ['[o'] = '@loop.outer',
              ['[i'] = '@conditional.outer',
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
              ['<leader>A'] = '@parameter.inner',
            },
          },
        },
      }

      -- Setup repeatable motions with ; and , (works for f/F/t/T movements)
      local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'
      vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move_next, { desc = 'Repeat last move (forward)' })
      vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_previous, { desc = 'Repeat last move (backward)' })

      -- Make builtin f/F/t/T also repeatable with ; and ,
      vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f_expr, { expr = true })
      vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F_expr, { expr = true })
      vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t_expr, { expr = true })
      vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T_expr, { expr = true })
    end,
  },
}
