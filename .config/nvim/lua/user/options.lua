-- Vim Options {{{

-- Text editing
vim.opt.autowrite = true
vim.opt.autowriteall = true
vim.opt.formatoptions = "tcqrn1j"
vim.opt.cmdheight = 1
vim.opt.wrap = false

-- Vim specific
vim.opt.timeoutlen = 2000
--vim.opt.omnifunc=syntaxcomplete#Complete
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Display
vim.opt.diffopt:append({ "vertical" })

vim.opt.cursorline = true
vim.opt.foldlevel = 0
vim.opt.foldmethod = "marker"
vim.opt.lazyredraw = true
vim.opt.number = true
vim.opt.scrolloff = 3
vim.opt.shortmess = "atToO"
vim.opt.showcmd = true
vim.opt.showmode = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true
vim.opt.title = true
--vim.opt.ruler=false

--vim.opt.viminfo='5000,:5000,@5000,/5000,h

--set whichwrap=<,>,h,l,[,]         -- move freely between lines (wrap)
--vim.opt.wildchar=<Tab> wildmenu wildmode=full
--vim.opt.wildcharm=<C-Z>
--vim.opt.wildmode=longest,full

-- Backup
vim.opt.backup = false
vim.opt.wb = true
vim.opt.swapfile = false
vim.opt.undofile = true

-- Spelling
vim.opt.spellfile = "~/.config/nvim/spell/en.utf-8.add"

-- Clipboard
vim.opt.clipboard:append({ "unnamedplus" })

-- Search
vim.opt.gdefault = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.grepprg = "rg --vimgrep"

-- Indentation
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.softtabstop = 0
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- Tags
vim.opt.tags = "./tags;/"

-- List invisible chars
vim.opt.listchars = { tab = "▸ ", trail = "—", extends = ">", precedes = "<", nbsp = "¤" }
vim.opt.list = true

-- Leader
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

-- }}}
-- Plugin Options {{{
-- netrw {{{

vim.g.netrw_keepdir = 0
vim.g.netrw_sort_options = "i"
vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 1
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 25

-- }}}
-- ntpeters/vim-better-whitespace {{{

vim.g.better_whitespace_enabled = 0

-- }}}
-- christoomey/vim-tmux-navigator {{{

vim.g.tmux_navigator_no_mappings = 1
vim.g.tmux_navigator_save_on_switch = 2

-- }}}
-- }}}
