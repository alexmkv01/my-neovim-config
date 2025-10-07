return {
  'pwntester/octo.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('octo').setup()

    -- Keymaps for Octo commands
    local keymap = vim.keymap.set
    keymap('n', '<leader>ol', ':Octo issue list<CR>', { desc = 'Octo: List issues' })
    keymap('n', '<leader>oi', ':Octo issue create<CR>', { desc = 'Octo: Create issue' })
    keymap('n', '<leader>op', ':Octo pr list<CR>', { desc = 'Octo: List PRs' })
    keymap('n', '<leader>or', ':Octo pr create<CR>', { desc = 'Octo: Create PR' })
    keymap('n', '<leader>opm', ':Octo pr merge<CR>', { desc = 'Octo: Merge PR' })
    keymap('n', '<leader>opc', ':Octo pr checkout<CR>', { desc = 'Octo: Checkout PR' })
    keymap('n', '<leader>opd', ':Octo pr diff<CR>', { desc = 'Octo: Show PR diff' })
    keymap('n', '<leader>opb', ':Octo pr browser<CR>', { desc = 'Octo: Open PR in browser' })
    keymap('n', '<leader>os', ':Octo search is:pr author:@me<CR>', { desc = 'Octo: Search my PRs' })
    keymap('n', '<leader>on', ':Octo notification list<CR>', { desc = 'Octo: List notifications' })
    keymap('n', '<leader>oo', ':Octo ', { desc = 'Octo: Open command prompt' })

    -- Commands that take args
    keymap('n', '<leader>oe', function()
      vim.cmd('Octo issue edit ' .. vim.fn.input('Issue number or URL: '))
    end, { desc = 'Octo: Edit issue' })

    keymap('n', '<leader>ope', function()
      vim.cmd('Octo pr edit ' .. vim.fn.input('PR number or URL: '))
    end, { desc = 'Octo: Edit PR' })
  end,
}