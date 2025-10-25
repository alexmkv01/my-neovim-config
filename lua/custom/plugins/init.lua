return {
	{
		'nvimtools/none-ls.nvim',
		dependencies = {
			'nvimtools/none-ls-extras.nvim',
		},
		config = function()
			local null_ls = require 'null-ls'
			local sources = {
				null_ls.builtins.formatting.prettier.with { filetypes = { 'json', 'yaml', 'markdown' } },
				null_ls.builtins.formatting.shfmt.with { args = { '-i', '4' } },
				-- Remove ruff_format as it conflicts with W292 (removes trailing newlines)
				-- Only use ruff for diagnostics/linting
				require 'none-ls.diagnostics.ruff',
			}

			local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
			null_ls.setup {
				sources = sources,
				-- Format on save (but not for Python - handled by ruff LSP)
				on_attach = function(client, bufnr)
					if client.supports_method 'textDocument/formatting' then
						vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
						vim.api.nvim_create_autocmd('BufWritePre', {
							group = augroup,
							buffer = bufnr,
							callback = function()
								-- Skip formatting for Python files (handled by ruff LSP)
								if vim.bo.filetype ~= 'python' then
									vim.lsp.buf.format()
								end
							end,
						})
					end
				end,
			}
		end,
	},
	{
		'jay-babu/mason-null-ls.nvim',
		event = { 'BufReadPre', 'BufNewFile' },
		config = function()
			require('mason-null-ls').setup {
				ensure_installed = {
					'ruff', -- Python linter/formatter
					'mypy', -- Python type checker
					'prettier', -- Web formatter
					'shfmt', -- Shell script formatter
				},
				automatic_installation = true,
			}
		end,
	},
	{
		'mfussenegger/nvim-lint',
		event = { 'BufReadPre', 'BufNewFile' },
		config = function()
			local lint = require 'lint'
			lint.linters_by_ft = lint.linters_by_ft or {}
		end,
	},
	require 'custom.plugins.ai',
	require 'custom.plugins.lazygit',
	require 'custom.plugins.octo',
	require 'custom.plugins.snacks',
	{
		'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
		config = function()
			require('lsp_lines').setup()
		end,
	},
	{
		'nvim-pack/nvim-spectre',
		dependencies = {
			'folke/trouble.nvim', -- for enhanced quickfix list
		},
		config = function()
			require('spectre').setup {
				-- default config, but you can customize here
			}

			vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>',
				{ desc = 'Toggle Spectre' })
			vim.keymap.set('n', '<leader>sw',
				'<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
				{ desc = 'Search current word' })
			vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>',
				{ desc = 'Search current word' })
			vim.keymap.set('n', '<leader>sp',
				'<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
				{ desc = 'Search on current file' })
		end,
	},
}
