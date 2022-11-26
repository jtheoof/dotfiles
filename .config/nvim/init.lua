require('user/plugins')
require('user/options')
require('user/reload')
require('user/autocommands')
require('user/telescope')
require('user/cmp')
require('user/keymaps')

require('lualine').setup()

vim.cmd [[colorscheme nord]]
