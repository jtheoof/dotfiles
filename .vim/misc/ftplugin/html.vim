" vim:set sts=4 sw=4 et:

command! Format %!tidy -qmi -utf8

let html_no_rendering = 1
setlocal omnifunc=htmlcomplete#CompleteTags
setlocal textwidth=0
setlocal iskeyword+=-
