return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local nvim_tree = require('nvim-tree')
    nvim_tree.setup({
      disable_netrw = true,
      sync_root_with_cwd = false,
      git = {
        ignore = false,
      },
      diagnostics = {
        enable = true,
        icons = not vim.g.have_nerd_font and { hint = "H", info = "I", warning = "W", error = "E" } or nil,
      },
      update_focused_file = {
        enable = true,
        update_root = false,
        ignore_list = {},
      },
      renderer = {
        highlight_git = true,
        icons = not vim.g.have_nerd_font and {
          show = { file = false, folder = false, git = false },
          glyphs = { folder = { arrow_closed = ">", arrow_open = "v" } },
        } or nil,
      },
    })
  end,
}
