" Custom vim support file to detect file types
"
" Maintainer:	 Jeremy Attali <jeremy.attali@gmail.com>
" Last Change: 2013-05-22

augroup filetypedetect
  au! BufNewFile,BufRead *.tpl setf tpl
augroup END
