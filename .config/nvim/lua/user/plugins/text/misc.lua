return {
  "christoomey/vim-tmux-navigator",
  "farmergreg/vim-lastplace",
  "numToStr/Comment.nvim",
  "tpope/vim-fugitive",
  "tpope/vim-repeat",
  "tpope/vim-surround",
  "tpope/vim-unimpaired",
  config = function()
    require("Comment").setup()
  end,
}
