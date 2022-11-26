-- Helper Functions {{{

function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

function nmap(shortcut, command)
  map('n', shortcut, command)
end

function imap(shortcut, command)
  map('i', shortcut, command)
end

function vmap(shortcut, command)
  map('v', shortcut, command)
end

function xmap(shortcut, command)
  map('x', shortcut, command)
end

function cmap(shortcut, command)
  map('c', shortcut, command)
end

function tmap(shortcut, command)
  map('t', shortcut, command)
end

-- }}}
-- Normal Mode {{{

nmap('-', ':Explore<CR>')
nmap('<C-b>', ':Lexplore<CR>')

-- Normal wrapping navigation
nmap('j', 'gj')
nmap('k', 'gk')
nmap('gj', 'j')
nmap('gk', 'k')
nmap('<Up>', 'gk')
nmap('<Down>', 'gj')

nmap('<C-Right>', '<C-w><Right>')
nmap('<C-Left>', '<C-w><Left>')
nmap('<C-Up>', '<C-w><Up>')
nmap('<C-Down>', '<C-w><Down>')

-- Clear search
nmap('<C-k>', ":let @/=''<CR>")

-- Useful navigation
nmap('<PageUp>', '<C-U>')
nmap('<PageDown>', '<C-D>')
nmap('<S-Down>', '3<C-E>')
nmap('<S-Up>', '3<C-Y>')

-- Make U more consistent with vim logic
nmap('U', ':redo<CR>')
nmap('ycf', ':let @* = expand("%:p")<CR>:let @+ = expand("%:p")<CR>')
nmap('t', 'yyp')

-- Pane splitting
nmap('<C-F11>', ':split<CR>')
nmap('<C-F12>', ':vsplit<CR>')

-- Navigate back and forth like in a browser
nmap('<A-Left>', '<C-o>')
nmap('<A-Right>', '<C-i>')

-- }}}
-- Insert Mode {{{

-- Move to first non-blank character
imap('<Home>', '<Esc>^i')

-- Save the file
imap('<C-S>', '<Esc>:w<CR>a')

imap('<C-Left>', '<Esc>bi')
imap('<C-Right>', '<Esc>lea')
imap('<S-Down>', '<Esc>3<C-E>a')
imap('<S-Up>', '<Esc>3<C-Y>a')

-- map control-backspace to delete the previous word
imap('<C-BS>', '<C-W>')
imap('', '<C-W>') -- Hack for alacritty
-- map control-del to remove word after cursor
imap('<C-Del>', '<C-O>"_de')

-- }}}
-- Visual Mode {{{

-- Better indentation
vmap('<', '<gv')
vmap('>', '>gv')
vmap('<Tab>', '>gv')
vmap('<S-Tab>', '<gv')

-- Move text up and down
xmap("J", ":move '>+1<CR>gv-gv")
xmap("K", ":move '<-2<CR>gv-gv")
xmap("<A-j>", ":move '>+1<CR>gv-gv")
xmap("<A-k>", ":move '<-2<CR>gv-gv")
xmap("<A-Down>", ":move '>+1<CR>gv-gv")
xmap("<A-Up>", ":move '<-2<CR>gv-gv")

-- Better paste
vmap("p", '"_dP')

-- }}}
-- Command Mode {{{

-- TODO Investigate: does not work
cmap('<C-BS>', '<C-w>')

-- }}}
-- Terminal Mode {{{

tmap('<Esc>', '<C-\\><C-n>')

-- }}}
-- Leader {{{

nmap('<Leader><Leader>', ':wa<CR>')
nmap('<Leader>w', ':w<CR>')
nmap('<Leader>q', ':q!<CR>')
nmap('<Leader>Q', ':qa!<CR>')

-- Quick edit of common files
nmap('<Leader>ea', ':edit ~/.config/alacritty/alacritty.yml<CR>')
nmap('<Leader>eg', ':edit ~/.gitconfig<CR>')
nmap('<Leader>et', ':edit ~/.tmux.conf<CR>')
nmap('<Leader>ez', ':edit ~/.zshrc<CR>')
nmap('<Leader>enn', ':edit ~/.config/nvim/init.lua<CR>')
nmap('<Leader>ena', ':edit ~/.config/nvim/lua/user/autocommands.lua<CR>')
nmap('<Leader>enp', ':edit ~/.config/nvim/lua/user/plugins.lua<CR>')
nmap('<Leader>enk', ':edit ~/.config/nvim/lua/user/keymaps.lua<CR>')
nmap('<Leader>eno', ':edit ~/.config/nvim/lua/user/options.lua<CR>')

-- Reload configuration
keymap('n', '<Leader>sc', ':lua ReloadConfig()<CR>', { silent = false })

-- Strip all trailing whitespace in the current file
nmap('<Leader>fw', ':StripWhitespace<CR>')
nmap('<Leader>d$', ':StripWhitespace<CR>')

-- Quick toggles
nmap('<Leader>ti', ':set ignorecase!<CR>')
nmap('<Leader>ts', ':set spell!<CR>')
nmap('<Leader>tl', ':set list!<CR>')
nmap('<Leader>tw', ':set wrap!<CR>')

-- }}}
-- Plugins {{{
-- christoomey/vim-tmux-navigator {{{

nmap('<C-Left>', ':<C-U>TmuxNavigateLeft<CR>')
nmap('<C-Down>', ':<C-U>TmuxNavigateDown<CR>')
nmap('<C-Up>', ':<C-U>TmuxNavigateUp<CR>')
nmap('<C-Right>', ':<C-U>TmuxNavigateRight<CR>')

-- }}}
-- }}}
