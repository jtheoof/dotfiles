" vim:set sts=4 sw=4 et:

set guioptions= " turn off every option

if has("gui_gtk2")
    set guifont=Consolas\ 10
elseif has("gui_win32")
    set guifont=Consolas:h10
endif
