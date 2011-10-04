" Highlight all instances of word under cursor, when idle.
" Useful when studying strange source code.
" Type z/ to toggle highlighting on/off.
nnoremap <Leader>hh :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
nnoremap <Leader>hw :call HighlightWord()<CR>
function! AutoHighlightToggle()
  let @/ = ''
  if exists('#auto_highlight')
    au! auto_highlight
    augroup! auto_highlight
    setl updatetime=2000
    echo 'Highlight current word: off'
    return 0
  else
    augroup auto_highlight
      au!
      au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
    augroup end
    setl updatetime=300
    echo 'Highlight current word: ON'
    return 1
  endif
endfunction
function! HighlightWord()
  let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
  echo 'Highlighted current word'
  return 1
endfunction
