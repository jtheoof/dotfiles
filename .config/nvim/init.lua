-- See :help *nvim-tree.disable_netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("user/plugins")
require("user/options")
require("user/reload")
require("user/autocommands")

-- Plugins
require("user/lualine")
require("user/cmp")
require("user/comment")
require("user/firenvim")
require("user/lsp")
require("user/nvim-autopairs")
require("user/nvim-tree")
require("user/telescope")
require("user/treesitter")
require("user/mason")

-- Keymaps
require("user/keymaps")

-- Colorscheme
require("user/colorscheme")
