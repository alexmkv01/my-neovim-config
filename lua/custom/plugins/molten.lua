return {
  'benlubas/molten-nvim',
  version = '^1.0.0',
  dependencies = { '3rd/image.nvim' },
  build = ':UpdateRemotePlugins',
  lazy = false, -- Load immediately so remote plugin gets registered
  init = function()
    -- Molten configuration
    vim.g.molten_image_provider = 'image.nvim'
    vim.g.molten_output_win_max_height = 20
    vim.g.molten_auto_open_output = false
    vim.g.molten_wrap_output = true
    vim.g.molten_virt_text_output = true
    vim.g.molten_virt_lines_off_by_1 = true
  end,
  config = function()
    -- Helper function to run code cell (skips markdown fence markers)
    local function run_cell()
      -- Save cursor position
      local pos = vim.api.nvim_win_get_cursor(0)
      
      -- Search backwards for code fence start
      vim.fn.search('^```', 'bW')
      local start_line = vim.fn.line('.')
      
      -- Search forward for code fence end
      vim.fn.search('^```', 'W')
      local end_line = vim.fn.line('.')
      
      -- Restore cursor
      vim.api.nvim_win_set_cursor(0, pos)
      
      -- Evaluate the lines between the fences (excluding the fence lines)
      if start_line < end_line then
        vim.fn.MoltenEvaluateRange(start_line + 1, end_line - 1)
      end
    end

    -- Helper function to copy output to clipboard
    local function copy_output()
      -- Check if we're already in an output window
      local current_win = vim.api.nvim_get_current_win()
      local in_output_win = vim.bo.buftype == 'nofile'
      
      if not in_output_win then
        -- Not in output window, need to open it temporarily
        local original_win = current_win
        vim.cmd('noautocmd MoltenEnterOutput')
        vim.defer_fn(function()
          -- Select all and yank
          vim.cmd('normal! ggVGy')
          -- Go back to original window
          vim.api.nvim_set_current_win(original_win)
          -- Close the output window we just opened
          vim.cmd('MoltenHideOutput')
          print('Output copied to clipboard')
        end, 50)
      else
        -- Already in output window, just yank and stay
        vim.cmd('normal! ggVGy')
        print('Output copied to clipboard')
      end
    end

    -- Keybindings for all markdown/python files
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'python', 'markdown' },
      callback = function()
        local opts = { buffer = true, silent = true }

        -- Initialize/deinitialize
        vim.keymap.set('n', '<leader>mi', ':MoltenInit<CR>',
          vim.tbl_extend('force', opts, { desc = '[M]olten [I]nit' }))
        vim.keymap.set('n', '<leader>mD', ':MoltenDeinit<CR>',
          vim.tbl_extend('force', opts, { desc = '[M]olten [D]einit' }))

        -- Evaluate
        vim.keymap.set('n', '<leader>mc', run_cell,
          vim.tbl_extend('force', opts, { desc = '[M]olten run [C]ell' }))
        vim.keymap.set('n', '<leader>ml', ':MoltenEvaluateLine<CR>',
          vim.tbl_extend('force', opts, { desc = '[M]olten evaluate [L]ine' }))
        vim.keymap.set('v', '<leader>mr', ':<C-u>MoltenEvaluateVisual<CR>gv',
          vim.tbl_extend('force', opts, { desc = '[M]olten [R]un visual selection' }))
        vim.keymap.set('n', '<leader>mR', ':MoltenReevaluateCell<CR>',
          vim.tbl_extend('force', opts, { desc = '[M]olten [R]e-run cell' }))
        vim.keymap.set('n', '<leader>ma', ':MoltenReevaluateAll<CR>',
          vim.tbl_extend('force', opts, { desc = '[M]olten run [A]ll cells' }))

        -- Navigation removed - using treesitter text objects instead (]m / [m)

        -- Output management
        vim.keymap.set('n', '<leader>mo', ':MoltenShowOutput<CR>',
          vim.tbl_extend('force', opts, { desc = '[M]olten show [O]utput' }))
        vim.keymap.set('n', '<leader>mw', ':noautocmd MoltenEnterOutput<CR>',
          vim.tbl_extend('force', opts, { desc = '[M]olten enter output [W]indow' }))
        vim.keymap.set('n', '<leader>mh', ':MoltenHideOutput<CR>',
          vim.tbl_extend('force', opts, { desc = '[M]olten [H]ide output' }))
        vim.keymap.set('n', '<leader>md', ':MoltenDelete<CR>',
          vim.tbl_extend('force', opts, { desc = '[M]olten [D]elete cell' }))
        vim.keymap.set('n', '<leader>my', copy_output,
          vim.tbl_extend('force', opts, { desc = '[M]olten [Y]ank (copy) output' }))

        -- Interrupt and restart
        vim.keymap.set('n', '<leader>mx', ':MoltenInterrupt<CR>',
          vim.tbl_extend('force', opts, { desc = '[M]olten interrupt (e[X]it)' }))
        vim.keymap.set('n', '<leader>ms', ':MoltenRestart<CR>',
          vim.tbl_extend('force', opts, { desc = '[M]olten re[S]tart kernel' }))
      end,
    })
  end,
}
