" vim:set sts=4 sw=4 et:

command! Format %!python -m json.tool

set textwidth=100

au WinEnter * set colorcolumn=100
au WinLeave * set colorcolumn=
