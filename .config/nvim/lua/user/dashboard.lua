local api = vim.api
local keymap = vim.keymap
local dashboard = require("dashboard")

dashboard.custom_header = {
  "                                                       ",
  "                                                       ",
  "                                                       ",
  " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
  " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
  " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
  " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
  " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
  " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
  "                                                       ",
  "                                                       ",
  "                                                       ",
  "                                                       ",
}

dashboard.custom_center = {
  {
    icon = "  ",
    desc = "Find  File                              ",
    action = "Telescope find_files",
    shortcut = "<Leader> f f  ",
  },
  {
    icon = "  ",
    desc = "Recently opened files                   ",
    action = "Telescope frecency",
    shortcut = "<Leader> f r  ",
  },
  {
    icon = "  ",
    desc = "Project grep                            ",
    action = "Telescope grep",
    shortcut = "<Leader> f G  ",
  },
  {
    icon = "  ",
    desc = "Project git grep                        ",
    action = "Telescope git_grep",
    shortcut = "<Leader> f G  ",
  },
  {
    icon = "  ",
    desc = "Open Nvim config                        ",
    action = "tabnew $MYVIMRC | tcd %:p:h",
    shortcut = "<Leader> e n n",
  },
  {
    icon = "  ",
    desc = "New file                                ",
    action = "enew",
    shortcut = "e             ",
  },
  {
    icon = "  ",
    desc = "Quit Nvim                               ",
    action = "qa",
    shortcut = "q             ",
  },
}

api.nvim_create_autocmd("FileType", {
  pattern = "dashboard",
  group = api.nvim_create_augroup("dashboard_enter", { clear = true }),
  callback = function()
    keymap.set("n", "q", ":qa<CR>", { buffer = true, silent = true })
    keymap.set("n", "e", ":enew<CR>", { buffer = true, silent = true })
  end,
})
