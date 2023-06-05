local saga = require("lspsaga")

saga.setup({
  finder_action_keys = {
    open = { 'o', '<CR>' },
    vsplit = 'v',
    split = 'h',
    tabe = 't',
    quit = { 'q', '<ESC>' },
  },
  -- use enter to open file with definition preview
  definition_action_keys = {
    edit = "<CR>",
  },
})
