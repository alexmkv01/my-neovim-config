return {
	'akinsho/toggleterm.nvim',
	version = '*',
	config = function()
		require('toggleterm').setup {
			-- Default direction remains vertical to not affect crush terminal
			hide_numbers = true,
			start_in_insert = false,
			insert_mappings = false,
			terminal_mappings = false,
			shade_terminals = false, -- Prevent darkening crush terminal
		}

		local Terminal = require('toggleterm.terminal').Terminal
		local crush_term -- Declare crush_term here
		local float_term -- Declare float_term here

		_CRUSH_TOGGLE = function()
			if not crush_term then -- Initialize only if it doesn't exist
				crush_term = Terminal:new {
					cmd = 'crush',
					hidden = true,
					direction = 'vertical',
					size = 55,
					on_open = function(term)
						vim.g.crush_bufnr = term.bufnr
						vim.cmd 'vertical resize 55' -- Ensure resize on open
						vim.cmd 'setlocal nofoldenable'
						vim.cmd 'setlocal nornu'
						vim.cmd 'startinsert!'
						vim.api.nvim_buf_set_name(term.bufnr, 'Crush')
						vim.api.nvim_set_option_value('filetype', 'crush', { buf = term.bufnr })

						local opts = { noremap = true, silent = true, buffer = term.bufnr }
						-- <C-l> in Normal mode inside crush: flip focus
						vim.keymap.set('n', '<C-l>', '<cmd>lua _CRUSH_FLIP_FOCUS_ANY_MODE()<CR>', opts)
						-- <C-l> in Terminal mode inside crush: exit terminal mode to normal, then flip focus
						vim.keymap.set('t', '<C-l>', '<C-\\><C-n><cmd>lua _CRUSH_FLIP_FOCUS_ANY_MODE()<CR>', opts)
					end,
					on_close = function()
						vim.g.crush_bufnr = nil
					end,
				}
			end
			crush_term:toggle()
		end

		_CRUSH_FLIP_FOCUS_ANY_MODE = function()
			if vim.g.crush_bufnr and vim.api.nvim_buf_is_valid(vim.g.crush_bufnr) then
				local current_win = vim.api.nvim_get_current_win()
				local crush_win = nil

				local wins = vim.api.nvim_tabpage_list_wins(0)
				for _, win in ipairs(wins) do
					if vim.api.nvim_win_get_buf(win) == vim.g.crush_bufnr then
						crush_win = win
						break
					end
				end

				if crush_win then
					if current_win == crush_win then
						vim.cmd 'wincmd h' -- Currently in Crush, jump left
					else
						vim.api.nvim_set_current_win(crush_win)
						vim.cmd 'startinsert!' -- <<< Add this line to enter insert mode
					end
				else
					vim.cmd 'wincmd p'
				end
			else
				vim.cmd 'wincmd p'
			end
		end

		-- Custom float terminal
		_G._float_toggle = function()
			if not float_term then
				float_term = Terminal:new {
					direction = 'float',
					start_in_insert = true,
					float_opts = {
						border = 'curved',
						winblend = 0,
					},
					on_open = function(term)
						vim.cmd 'startinsert!'
					end,
				}
			end
			float_term:toggle()
		end

		-- Auto-command to map esc in terminal mode to normal mode, except for lazygit
		vim.api.nvim_create_autocmd('TermOpen', {
			pattern = 'term://*',
			callback = function(args)
				local bufnr = args.buf
				local bufname = vim.api.nvim_buf_get_name(bufnr)
				if not bufname:find('lazygit') then
					vim.api.nvim_buf_set_keymap(bufnr, 't', '<esc>', '<C-\\><C-n>', { noremap = true, silent = true })
				end
			end
		})

		-- Keymaps for crush
		vim.keymap.set('n', '<leader>ai', '<cmd>lua _CRUSH_TOGGLE()<CR>', { desc = 'Toggle Crush (Open/Close)' })

		vim.keymap.set('n', '<C-l>', '<cmd>lua _CRUSH_FLIP_FOCUS_ANY_MODE()<CR>',
			{ desc = 'Flip Focus (Editor/Crush)' })
		-- Override ZZ to save all and quit all windows, closing crush/etc.
		vim.keymap.set('n', 'ZZ', function()
			if crush_term and crush_term:is_open() then
				crush_term:toggle()
			end
			if float_term and float_term:is_open() then
				float_term:toggle()
			end
			-- Wipe out terminal buffers to avoid job running errors
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == 'terminal' then
					vim.cmd('bwipeout! ' .. buf)
				end
			end
			vim.cmd 'wqall!'
		end, { desc = 'Close all terminals, wipe buffers, save all, quit all' })
	end,
}
