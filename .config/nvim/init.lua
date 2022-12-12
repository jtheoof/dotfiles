require('user/plugins')
require('user/options')
require('user/reload')
require('user/autocommands')

-- Plugins
require('lualine').setup()
require('user/cmp')
require('user/firenvim')
require('user/lsp')
require('user/nvim-tree')
require('user/telescope')
require('user/treesitter')

-- Keymaps
require('user/keymaps')

-- Colorscheme
vim.cmd [[colorscheme nord]]
