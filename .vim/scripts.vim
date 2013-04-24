" Handle new filetypes
if did_filetype()
    finish
endif
" Node {{{

if getline(1) =~# '^#!.*\<node\>'
    setfiletype javascript
endif

" }}}
