" Vim script
" Last Change: June 18, 2011
" Author: Peter Odding
" URL: http://peterodding.com/code/vim/reload/

" Support for automatic update using the GLVS plug-in.
" GetLatestVimScripts: 3148 1 :AutoInstall: reload.zip

" Don't source the plug-in when it's already been loaded or &compatible is set.
if &cp || exists('g:loaded_reload')
  finish
endif

let g:reload_version = '0.6.2'

if !exists('g:reload_on_write')
  let g:reload_on_write = 1
endif

command! -bar -nargs=? -complete=file ReloadScript call s:ReloadCmd(<q-args>)

augroup PluginReloadScripts
  autocmd!
  autocmd BufWritePost *.vim nested call s:AutoReload()
  " The nested keyword is so that SwapExists isn't ignored!
  autocmd SwapExists * call xolox#reload#open_readonly()
  autocmd TabEnter * call xolox#reload#windows()
augroup END

function! s:ReloadCmd(arg)
  if a:arg !~ '\S'
    call xolox#reload#script(expand('%:p'))
  else
    call xolox#reload#script(fnamemodify(a:arg, ':p'))
  endif
endfunction

if !exists('s:auto_reload_active')
  function! s:AutoReload()
    if g:reload_on_write
      let s:auto_reload_active = 1
      call xolox#reload#script(expand('%:p'))
      unlet s:auto_reload_active
    endif
  endfunction
endif

" Don't reload the plug-in once it has loaded successfully.
let g:loaded_reload = 1

" vim: ts=2 sw=2 et
