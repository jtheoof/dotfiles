-- autocmd! remove all autocommands, if entered under a group it will clear that group
vim.cmd [[
  augroup _general_settings
    autocmd!
    autocmd FileType qf,help,netrw,lspinfo nnoremap <silent> <buffer> q :close<CR>
    autocmd InsertEnter * set cursorline
    autocmd InsertLeave * set nocursorline
    autocmd FocusLost * execute ":silent! wa"
  augroup end
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
  augroup _git
    autocmd!
    autocmd FileType gitcommit setlocal wrap
    autocmd FileType gitcommit setlocal spell
  augroup end
  augroup _markdown
    autocmd!
    autocmd FileType markdown setlocal wrap
    autocmd FileType markdown setlocal spell
  augroup end
]]

