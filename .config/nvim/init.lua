-- See :help *nvim-tree.disable_netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("user/plugins")
require("user/options")
require("user/reload")
require("user/autocommands")
require("user/neovide")

-- Plugins
require("user/lualine")
require("user/cmp")
require("user/comment")
-- require("user/dashboard")
require("user/firenvim")
require("user/nvim-autopairs")
require("user/nvim-tree")
require("user/telescope")
require("user/treesitter")

-- Keymaps
require("user/keymaps")

-- Colorscheme
require("user/colorscheme")
