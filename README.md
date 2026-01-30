# My Neovim Config

Personal Neovim configuration based on kickstart.nvim with extensive customizations.

## Features

- LSP integration with auto-completion
- DAP debugging support for Python and Go
- Git integration with LazyGit and Octo
- Advanced navigation with Flash and Telescope
- Session management with Persistence
- Smooth scrolling and enhanced UI

## Plugin List

### Core & Plugin Management

- **lazy.nvim** - Plugin manager

### Completion & Snippets

- **blink.cmp** - Completion engine
- **LuaSnip** - Snippet engine

### LSP (Language Server Protocol)

- **nvim-lspconfig** - LSP configuration
- **mason.nvim** - LSP/DAP/linter installer
- **mason-lspconfig.nvim** - Mason + lspconfig integration
- **mason-tool-installer.nvim** - Auto-install tools via Mason
- **lazydev.nvim** - Lua LSP for Neovim development
- **fidget.nvim** - LSP progress notifications
- **lsp_lines.nvim** - Show diagnostics as virtual lines

### Formatting & Linting

- **conform.nvim** - Code formatting
- **nvim-lint** - Async linting
- **none-ls.nvim** (null-ls fork) - Code actions & diagnostics
- **none-ls-extras.nvim** - Extra sources for none-ls
- **mason-null-ls.nvim** - Mason + null-ls integration

### Debugging (DAP)

- **nvim-dap** - Debug Adapter Protocol
- **nvim-dap-ui** - UI for nvim-dap
- **nvim-dap-python** - Python debugging support
- **nvim-dap-go** - Go debugging support
- **mason-nvim-dap.nvim** - Mason + DAP integration
- **nvim-nio** - Async I/O library for DAP

### Navigation & Search

- **telescope.nvim** - Fuzzy finder
- **telescope-fzf-native.nvim** - FZF sorter for Telescope
- **telescope-ui-select.nvim** - Telescope UI for vim.ui.select
- **flash.nvim** - Navigation with search labels
- **neo-tree.nvim** - File explorer

### Git Integration

- **gitsigns.nvim** - Git signs in gutter
- **lazygit.nvim** - LazyGit integration
- **octo.nvim** - GitHub integration

### Treesitter & Syntax

- **nvim-treesitter** - Syntax highlighting & parsing
- **nvim-treesitter-textobjects** - Textobjects based on treesitter

### UI & Appearance

- **catppuccin** - Color scheme (Mocha flavor with transparency)
- **noice.nvim** - UI for messages/cmdline/popups
- **nvim-notify** - Notification manager
- **nui.nvim** - UI component library
- **nvim-web-devicons** - File icons
- **breadcrumbs.nvim** - Breadcrumb navigation bar
- **nvim-navic** - LSP-based breadcrumbs
- **which-key.nvim** - Keybinding popup

### Editor Enhancements

- **mini.nvim** - Collection of minimal plugins (statusline, surround, ai textobjects)
- **nvim-autopairs** - Auto-close brackets/quotes
- **todo-comments.nvim** - Highlight TODO comments
- **trouble.nvim** - Diagnostics & references list
- **guess-indent.nvim** - Auto-detect indentation
- **neoscroll.nvim** - Smooth scrolling
- **persistence.nvim** - Session management
- **snacks.nvim** - Collection of small QoL plugins
- **markview.nvim** - Markdown preview
- **copy-file-path.nvim** - Copy file paths easily
- **toggleterm.nvim** - Terminal management

### Utilities

- **plenary.nvim** - Lua utility functions (required by many plugins)

## Installation

1. Backup your existing Neovim config:

```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

2. Clone this repository:

```bash
git clone https://github.com/alexmkv01/my-neovim-config.git ~/.config/nvim
```

3. Start Neovim and let lazy.nvim install plugins:

```bash
nvim
```

## Requirements

- Neovim >= 0.9.0
- Git
- A Nerd Font (for icons)
- ripgrep (for telescope grep)
- fd (optional, for telescope file search)
- A C compiler (for treesitter)

## Key Customizations

- Custom keybindings for navigation and workflow
- Flash navigation on `f` key
- H/L buffer cycling
- Disabled arrow keys in normal mode (vim training wheels off!)
- Treesitter-based folding
- Transparent background
- Python-focused LSP setup with pylsp and ruff
