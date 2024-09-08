local nvim_tree = _G.safe_require("nvim-tree")

if (nvim_tree == nil) then
    return
end

nvim_tree.setup({
  disable_netrw = true,
  sync_root_with_cwd = false,
  git = {
    ignore = false,
  },
  diagnostics = {
    enable = true,
  },
  update_focused_file = {
    enable = true,
    update_root = false,
    ignore_list = {},
  },
  view = {
    mappings = {
      custom_only = false,
      list = {
        { key = "<Space>", cb = tree_cb("preview") },
      },
    },
  },
  renderer = {
    highlight_git = true,
  },
})
