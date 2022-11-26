local packer = require("packer")

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

return packer.startup(function()
  use 'wbthomason/packer.nvim'

  -- colorscheme
  use 'shaunsingh/nord.nvim' -- https://github.com/shaunsingh/nord.nvim

  -- lualine.nvim: https://github.com/nvim-lualine/lualine.nvim
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  -- common
  use 'farmergreg/vim-lastplace'
  use 'ntpeters/vim-better-whitespace'
  use 'christoomey/vim-tmux-navigator'
  use 'tpope/vim-commentary'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'
  use 'tpope/vim-unimpaired'
  --use 'tpope/vim-vinegar'

  --  -- cmp plugins
  use "hrsh7th/nvim-cmp" -- The completion plugin
  use "hrsh7th/cmp-buffer" -- buffer completions
  use "hrsh7th/cmp-path" -- path completions
  use "hrsh7th/cmp-cmdline" -- cmdline completions

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- LSP
  use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP

  -- Fiefox
  use {
    'glacambre/firenvim',
    run = function() vim.fn['firenvim#install'](0) end
}
end)
