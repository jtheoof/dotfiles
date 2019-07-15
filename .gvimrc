" vim:set sts=4 sw=4 et:

set guioptions= " turn off every option

if has("gui_gtk2") || has("gui_gtk3")
    set guifont=Noto\ Sans\ Mono\ Medium\ 13
elseif has("gui_win32")
    set guifont=Consolas:h10
elseif has("gui_macvim") || has("gui_vimr")
    set guifont=Monaco:h12
endif
