-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = true,
  keys = {
    {
      '<leader>e',
      function()
        require('neo-tree.command').execute { toggle = true, reveal = true }
      end,
      desc = 'NeoTree Toggle/Reveal',
    },
  },
  opts = {
    -- This helps prevent the race condition
    close_floats_on_escape_or_open = false,

    -- ADDED: This is the correct way to auto-close the window
    -- This listens for the "file opened" event and then runs
    -- the "close" command, which fixes your warnings.
    event_handlers = {
      {
        event = 'file_opened',
        handler = function(file_path)
          -- This closes all floating neo-tree windows
          require('neo-tree.command').execute { action = 'close' }
        end,
      },
    },

    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
      window = {
        position = 'float',
        width = 40,
        auto_resize = 'leave_unchanged', -- This is the critical crash fix
        float_config = {
          relative = 'editor',
          position = '50%',
          size = {
            width = '80%',
            height = '60%',
          },
          border = 'rounded',
        },
        mappings = {
          ['\\'] = 'close_window',
          ['<leader>e'] = 'close_window',
          -- CHANGED: We change these to just "open".
          -- The "and_close" part is now handled by the
          -- event_handler above. This fixes the warnings.
          ['<CR>'] = 'open',
          ['o'] = 'open',
        },
      },
    },
  },
}
