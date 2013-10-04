" Vim syntax file
" Language:	    Intersec tpl file
" Maintainer:	Jeremy Attali <jeremy.attali@gmail.com>
" URL:		    
" Last Change:  2013-05-22
" License:      MIT
" Changes:      First introduction

runtime! syntax/html.vim

" JST {{{

syn region jstBlock containedin=ALL start="<%=" keepend end="%>" contains=@htmlJavaScript,htmlCssStyleComment,htmlScriptTag,@htmlPreproc
syn region jstBlock containedin=ALL start="<%" keepend end="%>" contains=@htmlJavaScript,htmlCssStyleComment,htmlScriptTag,@htmlPreproc

" }}}
" Init {{{

" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_tpl_syn_inits")
  if version < 508
    let did_tpl_syn_inits = 1
  endif
endif

let b:current_syntax = "tpl"

" }}}
