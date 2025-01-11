-- See :help *nvim-tree.disable_netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- @USAGE:
-- local foo = safe_require('foo')
-- if not foo then return end
_G.safe_require = function(module_name)
	local package_exists, module = pcall(require, module_name)
	if not package_exists then
		vim.defer_fn(function()
			vim.schedule(function()
				vim.notify('Could not load module: ' .. module_name, 'error', { title = 'Module Not Found' })
			end)
		end, 1000)
		return nil
	else
		return module
	end
end

-- @USAGE: :lua safe_reload('foo')
function _G.safe_reload(module)
	package.loaded[module] = nil
	return safe_require(module)
end

require("user/options")
require("user/reload")
require("user/keymaps")
require("user/autocommands")
require("user/neovide")

require("user/lazy")

-- Plugins
-- require("user/plugins")
-- require("user/lualine")
-- require("user/cmp")
-- require("user/comment")
-- require("user/dashboard")
-- require("user/nvim-autopairs")
-- require("user/nvim-tree")
-- require("user/telescope")
-- require("user/treesitter")
-- require("user/colorscheme")
