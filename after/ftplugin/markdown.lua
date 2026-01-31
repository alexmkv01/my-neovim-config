-- Auto-activate LSP for Jupyter notebooks converted to markdown
-- This runs every time a markdown file is opened

local md_file = vim.api.nvim_buf_get_name(0)
local ipynb_file = md_file:gsub('%.md$', '.ipynb')

-- Only activate if there's a corresponding .ipynb file
if vim.fn.filereadable(ipynb_file) == 1 then
  -- Check if already activated to avoid re-activating
  if not vim.b.otter_activated then
    print('[Notebook] Found notebook: ' .. vim.fn.fnamemodify(ipynb_file, ':t'))
    
    -- Delay to ensure plugins are loaded
    vim.defer_fn(function()
      -- Load quarto if not already loaded
      local has_quarto, quarto = pcall(require, 'quarto')
      local has_otter, otter = pcall(require, 'otter')
      
      if not has_quarto then
        print('[Notebook] ERROR: quarto.nvim not loaded')
        return
      end
      
      if not has_otter then
        print('[Notebook] ERROR: otter.nvim not loaded')
        return
      end
      
      print('[Notebook] Activating LSP...')
      
      -- Activate quarto
      local ok_quarto, err_quarto = pcall(function()
        quarto.activate()
      end)
      
      if not ok_quarto then
        print('[Notebook] ERROR activating quarto: ' .. tostring(err_quarto))
        return
      end
      
      print('[Notebook] Quarto ✓')
      
      -- Activate otter with delay
      vim.defer_fn(function()
        local ok_otter, err_otter = pcall(function()
          otter.activate({'python'}, true)
        end)
        
        if ok_otter then
          vim.b.otter_activated = true
          print('[Notebook] Otter ✓ - LSP active!')
          vim.notify('✓ Notebook LSP activated!', vim.log.levels.INFO)
        else
          print('[Notebook] ERROR activating otter: ' .. tostring(err_otter))
        end
      end, 300)
    end, 100)
  else
    print('[Notebook] LSP already active')
  end
end
