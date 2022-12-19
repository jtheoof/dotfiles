local packer = require("packer")

-- Have packer use a popup window
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})

return packer.startup(function(use)
  use("wbthomason/packer.nvim")

  -- colorscheme
  use("shaunsingh/nord.nvim") -- https://github.com/shaunsingh/nord.nvim
  use("nvim-lualine/lualine.nvim") -- https://github.com/nvim-lualine/lualine.nvim

  -- utils
  use("nvim-lua/plenary.nvim") -- https://github.com/nvim-lua/plenary.nvim

  -- common
  use("christoomey/vim-tmux-navigator")
  use("farmergreg/vim-lastplace")
  use("ntpeters/vim-better-whitespace")
  use("numToStr/Comment.nvim")
  use("tpope/vim-fugitive")
  use("tpope/vim-repeat")
  use("tpope/vim-surround")
  use("tpope/vim-unimpaired")
  use("windwp/nvim-autopairs")

  -- Dashboard
  use("glepnir/dashboard-nvim")

  -- completion
  use({
    "hrsh7th/nvim-cmp", -- The completion plugin
    "hrsh7th/cmp-nvim-lsp", -- The LSP plugin
    "hrsh7th/cmp-buffer", -- buffer completions
    "hrsh7th/cmp-path", -- path completions
    "hrsh7th/cmp-cmdline", -- cmdline completions
    "hrsh7th/cmp-vsnip",
    "hrsh7th/vim-vsnip",
  })

  -- Telescope
  use({
    "nvim-telescope/telescope.nvim",
    tag = "0.1.0",
    requires = { { "nvim-lua/plenary.nvim" } },
  })
  use({
    "nvim-telescope/telescope-frecency.nvim",
    config = function()
      require("telescope").load_extension("frecency")
    end,
    requires = { "kkharji/sqlite.lua" },
  })

  -- Treesitter
  use({
    "nvim-treesitter/nvim-treesitter",
    "nvim-treesitter/playground",
    run = ":TSUpdate",
  })

  -- nvim-tree
  use({
    "nvim-tree/nvim-tree.lua",
    requires = {
      "nvim-tree/nvim-web-devicons", -- optional, for file icons
    },
    tag = "nightly", -- optional, updated every week. (see issue #1193)
  })

  -- LSP
  use({
    "neovim/nvim-lspconfig", -- Collection of common configurations for the Nvim LSP client
    "williamboman/mason.nvim", -- Portable package manager for Neovim that runs everywhere Neovim runs.
    "folke/trouble.nvim",
    "simrat39/symbols-outline.nvim",
    "j-hui/fidget.nvim", -- Visualize lsp progress
    config = function()
      require("fidget").setup()
    end,
  })

  -- Firefox
  use({
    "glacambre/firenvim",
    run = function()
      vim.fn["firenvim#install"](0)
    end,
  })
end)
