" File: qfixtoggle.vim
" Author: Jason Heddings (vim at heddway dot com)
" Version: 1.0
" Last Modified: 05 October, 2005
"
" See ':help qfixtoggle' for more information.
"   
"if exists("g:QFixToggle_Loaded")

if exists("g:Tabula_BoldStatement")
  finish
endif
let g:QFixToggle_Loaded = 1


" set the default options for the plugin
if !exists("g:QFixToggle_Height")
  let g:QFixToggle_Height = 8
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" toggles the quickfix window.
command -bang -nargs=0 QFix call QFixToggle(<bang>0)
function! QFixToggle(forced)
  if exists("g:QFixToggle_Bufnr") && a:forced == 0
    cclose
  else
    execute "copen " . g:QFixToggle_Height
  endif
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" perform setup operations for the quickfix window
function QFixToggle_Setup()
  let g:QFixToggle_Bufnr = bufnr("$")
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" called to determine if the quickfix window is closed
function QFixToggle_Closed()
  if exists("g:QFixToggle_Bufnr") && expand("<abuf>") == g:QFixToggle_Bufnr
    unlet! g:QFixToggle_Bufnr
  endif
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" used to track the quickfix window
augroup QFixToggle
  autocmd BufWinEnter quickfix call QFixToggle_Setup()
  autocmd BufWinLeave * call QFixToggle_Closed()
augroup END
