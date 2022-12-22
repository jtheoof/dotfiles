if vim.g.started_by_firenvim then
  vim.opt.relativenumber = true
  vim.opt.spell = true
  vim.cmd [[
    au InsertLeave * ++nested write
  ]]
end
vim.g.firenvim_config = {
  localSettings = {
    [".*"] = {
      takeover = "never",
    },
  },
}
