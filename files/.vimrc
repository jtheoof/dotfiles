" Name:     Jeremy Attali's .vimrc
" Author:   Jeremy Attali
" URL:      
" License:  MIT license (see end of this file)
" Created:  In Paris
" Modified: 2011 Apr 14
" Comment:  Big thanks to amix.dk: http://amix.dk/vim/vimrc.html

runtime macros/matchit.vim    " smarter use of '%'

" Pathogen {{{1
"---------------------------------------------------------------------
" Needed on some linux distros.
" " see
" http://www.adamlowe.me/2009/12/vim-destroys-all-other-rails-editors.html
filetype off 
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
"1}}}

filetype plugin on            " put filetype plugin back on after pathogen
filetype indent on            " enable indents on filetype (ex: html, tpl, ...)
set nocompatible              " use vim defaults
syntax on                     " enable syntax
let g:reload_on_write = 0

" Main options {{{1
"---------------------------------------------------------------------
"set autochdir                      " Automatically follow current directory
set backspace=indent,eol,start                 " more powerful backspacing
set nobackup                       " do not keep a backup file
set cursorline                     "Highlight current line"
set clipboard=unnamed                " copy things to general clipboard
set diffopt+=vertical 			   " make vertical default split
set esckeys                        " allow usage of curs keys within insert mode 
set encoding=utf8				   " utf-8 encoding
set ignorecase                     " ignore case when searching
set smartcase                      " ignore case only if all chars are lower case
set incsearch                      " do incremental searching
set foldlevel=0                    " fold to level 0 when opening file
set foldmethod=marker              " basic marker as default folding method
set history=1000                   " history back trace
set hlsearch                       " highlight searches
set laststatus=2                   " allways show status line
set ruler                          " show the cursor position all the time
set number                         " show line numbers
set modeline                       " last lines in document sets vim mode
set modelines=5                    " number lines checked for modelines
set nolazyredraw                   " don't redraw while executing macros
set nostartofline                  " don't jump to first character when paging
set nowrap                         " don't wrap to new line
set omnifunc=syntaxcomplete#Complete
set shortmess=atI                  " Abbreviate messages
set showcmd                        " display incomplete commands
set tags=tags;/,.tags;/,TAGS;/
set title                          " show title in console title bar
set ttyfast                        " smoother changes
"set viminfo='10,\"100			   " 10 marks, 100 lines
set viminfo='10,\"100,:20,% 	   " 10 marks, 100 lines, up to 20 command lins and save/restore buffer list
"set whichwrap=b,s,h,l,<,>,[,]                  " move freely between files
set wildmenu
set wildchar=<Tab> wildmenu wildmode=full
set wildcharm=<C-Z>
set wildmode=longest,full

" Indentation
set tabstop=4
set shiftwidth=4
set noexpandtab 					" most important part.
set copyindent
set preserveindent
set smarttab
set autoindent

" Don't flash errors and disable sound
set novisualbell
set noerrorbells
"set noerrorbells visualbell t_vb=

let mapleader=","
"1}}}

" Functions {{{1
"---------------------------------------------------------------------

" Quickfix toggle window
command! -bang -nargs=? QFix call QFixToggle(<bang>0)
function! QFixToggle(forced)
  if exists("g:qfix_win") && a:forced == 0
    cclose
    unlet g:qfix_win
  else
    botright cwindow
    let g:qfix_win = bufnr("$")
  endif
endfunction

map <C-F9> :QFix<CR>

"1}}}

" GUI {{{1
"---------------------------------------------------------------------
if has("gui_running")
    set background=dark             " adapt colors for background
    "colorscheme solarized
    "set guifont=Monaco\ 8
    colorscheme zenburn
	if has("gui_gtk2")
		set guifont=Ubuntu\ Mono\ 8
	elseif has("gui_win32")
	    set guifont=Consolas:h10
	endif

    "set guioptions-=m               " remove menu bar
    "set guioptions-=T               " remove toolbar
    "set guioptions-=r               " remove right-hand scroll bar
    set guioptions=                  " turns off every option

    " If the current buffer has never been saved, it will have no name,
    " call the file browser to save it, otherwise just save it.
    "map <silent> <C-S> :if expand("%") == ""<CR>:browse confirm w<CR>:else<CR>:w<CR>:endif<CR>
    map <silent> <C-S> :w<CR>
    imap <silent> <C-S> <Esc>:w<CR>a
else
    colorscheme wombat256			 " use wombat for non gui vim sessions

endif
" }}}

" OS Specific {{{1
"---------------------------------------------------------------------
if has("unix")
	let g:ackprg="ack-grep -H --nocolor --nogroup --column"
elseif has("win32")
endif
" }}}

" Main leader commands {{{1
"---------------------------------------------------------------------
" With a map leader it's possible to do extra key combinations
" like <Leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" change to directory containing current file
nmap <Leader>cd :cd %:p:h<CR>

" Fast saving
nmap <Leader>w :w!<CR>

" Splitting windows the right way
" Thanks to: http://technotales.wordpress.com/2010/04/29/vim-splits-a-guide-to-doing-exactly-what-you-want/

" window
nmap <Leader>sw<Left>  :topleft  vnew<CR>
nmap <Leader>sw<Right> :botright vnew<CR>
nmap <Leader>sw<Up>    :topleft  new<CR>
nmap <Leader>sw<Down>  :botright new<CR>

" buffer
nmap <Leader>s<Left>   :leftabove  vnew<CR>
nmap <Leader>s<Right>  :rightbelow vnew<CR>
nmap <Leader>s<Up>     :leftabove  new<CR>
nmap <Leader>s<Down>   :rightbelow new<CR>

" Fast editing of .vimrc
map <Leader>ve :e! $MYVIMRC<CR>

" Fast reload of .vimrc
map <Leader>vs :so $MYVIMRC<CR>
map <Leader>vv :so $MYVIMRC<CR>

" Opening closing tabs
map <Leader>tc :tabclose<CR>
map <Leader>td ,bd,tc
map <Leader>tt :tabnew %<CR>
map <Leader>tn :tabnew<CR>

map <Leader>fc :cs find s <C-R>=expand("<cword>")<CR><CR>

"1}}}

" Mappings {{{1
"---------------------------------------------------------------------
" Don't do this because it causes problems to open with ":lw or :cw

"map <S-Enter> O<Esc>
"map <CR> o<Esc>

map <Home> ^

map <C-Right> <C-w><Right>
map! <C-Right>  <Esc> <C-w><Right>
map <C-Left> <C-w><Left>
map! <C-Left>  <Esc> <C-w><Left>
map <C-Up> <C-w><Up>
map! <C-Up> <Esc> <C-w><Up>
map <C-Down> <C-w><Down>
map! <C-Down>  <Esc> <C-w><Down>
map <PageUp> <C-U>
map <PageDown> <C-D>

map <S-Down> <C-E>
map <S-Up> <C-Y>

"map <C-D> <Esc>dd
imap <C-D> <Esc>dda
map <C-K> :let @/ = ""<CR>

map <F1> :Explore<CR>
map <C-F1> :tabe **/<cfile><CR>
map <F2> <C-]>
map g<F2> g<C-]>
map <C-F2> g]
"map <F5> <Esc>:w<CR>:!%:p<CR>
nnoremap <F4> :call HighlightWord()<CR>
nnoremap <C-F4> :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
map <F5> <Esc>:w<CR>
imap <F5> <Esc>:w<CR>a
map <F7> :make<CR>
imap <F7> <Esc>:make<CR>a
map <F9> :TlistToggle<CR>
map <F12> :! tidy -qmi -xml -utf8 % <CR>
map <C-F12> :r ! python -mjson.tool < % <CR>ggdd

" map control-backspace to delete the previous word
imap <C-BS> <C-W>

" map control-del to remove word after cursor
imap <C-Del> <Esc><Right>dwi

" Visual and select mode map
vmap <Tab> >gv
vmap <BS> <gv
vmap <Space> zf
vmap ! y<Esc>:%s/<C-R>"/

" Navigate through tags
map <M-b> :tselect<CR>
map <M-n> :tnext<CR>
map <M-m> :tprevious<CR>
map <M-Home> :tselect<CR>
map <M-PageDown> :tnext<CR>
map <M-PageUp> :tprevious<CR>

" Alt-right/left to navigate forward/backward in the tags stack
map <M-Left> <C-T>
map <M-Right> <C-]>
" Alt-up/down to navigate through history
map <M-Down> <C-o>
map <M-Up> <C-i>

" Map Ctrl-Space to cscope find current word
nmap <C-@><C-@> :cs find s <C-R>=expand("<cword>")<CR><CR>

"1}}}

" Auto commands {{{1
"---------------------------------------------------------------------

" This autocommand jumps to the last known position in a file
" just after opening it, if the '"' mark is set:
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Auto name title to filename opened
" autocmd BufRead * let &titlestring = hostname() . "[vim(" . expand("%:t") . ")]"

" Auto save when focus is lost
autocmd FocusLost * execute ":silent! wa"
" Auto change directory on Buffer Entering
" autocmd BufEnter * execute ":silent! lcd %:p:h"

" Local completion
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

" Local indentations
autocmd FileType html setlocal softtabstop=2 shiftwidth=2 
autocmd FileType tpl setlocal softtabstop=2 shiftwidth=2 
autocmd FileType smarty setlocal softtabstop=2 shiftwidth=2 
"1}}}

" Files, backups and undo {{{1
"---------------------------------------------------------------------
" Turn backup off, since most stuff is in SVN, git anyway...
set nobackup
set nowb
set noswapfile

"Persistent undo
try
    if MySys() == "windows"
      set undodir=C:\Windows\Temp
    else
      set undodir=~/.vim/undodir
    endif

    set undofile
catch
endtry
"1}}}
    
" Spell checking {{{1
"---------------------------------------------------------------------

" Use :mkspell! ~/.vim/spell/en.utf-8.add to regenerate spelling binary files

" Pressing ,ss will toggle and untoggle spell checking
map <Leader>ss :setlocal spell!<CR>

" Shortcuts using <Leader>
map <Leader>sn ]s
map <Leader>sp [s
map <Leader>sa zg
map <Leader>s? z=
"1}}}

" Search {{{1
"---------------------------------------------------------------------

" Make searches appear in the middle of the screen
"nnoremap n nzz
"nnoremap N Nzz
"nnoremap * *zz
"nnoremap # #zz
"nnoremap g* g*zz
"nnoremap g# g#zz

" Search within a scope (a {...} program block).
" Version 2010-02-28 from http://vim.wikia.com/wiki/VimTip1530

" Search within top-level block for word at cursor, or selected text.
nnoremap <Leader>[ /<C-R>=<SID>ScopeSearch('[[', 1)<CR><CR>
vnoremap <Leader>[ <Esc>/<C-R>=<SID>ScopeSearch('[[', 2)<CR><CR>gV
" Search within current block for word at cursor, or selected text.
nnoremap <Leader>{ /<C-R>=<SID>ScopeSearch('[{', 1)<CR><CR>
vnoremap <Leader>{ <Esc>/<C-R>=<SID>ScopeSearch('[{', 2)<CR><CR>gV
" Search within current top-level block for user-entered text.
nnoremap <Leader>/ /<C-R>=<SID>ScopeSearch('[[', 0)<CR>
vnoremap <Leader>/ <Esc>/<C-R>=<SID>ScopeSearch('[[', 2)<CR><CR>

" In visual mode, / and ? will update the visual selection just like
" any other cursor-movement command (that is, when in visual mode,
" searching will extend the selection).
" In order to actually search within the visual selection, you will
" need to use the \%V atom, or use the markers defined by the visual
" selection with the \%>'< and \%<'> atoms. This is best done by
" leaving the visual selection with <Esc> before entering your search.
" You may want to consider a mapping to automatically leave visual
" selection and enter the appropriate atoms.
vnoremap <M-/> <Esc>/\%V

" Return a pattern to search within a specified scope, or
" return a backslash to cancel search if scope not found.
" navigator: a command to jump to the beginning of the desired scope
" mode: 0=scope only; 1=scope+current word; 2=scope+visual selection
function! s:ScopeSearch(navigator, mode)
  if a:mode == 0
    let pattern = ''
  elseif a:mode == 1
    let pattern = '\<' . expand('<cword>') . '\>'
  else
    let old_reg = getreg('@')
    let old_regtype = getregtype('@')
    normal! gvy
    let pattern = escape(@@, '/\.*$^~[')
    call setreg('@', old_reg, old_regtype)
  endif
  let saveview = winsaveview()
  execute 'normal! ' . a:navigator
  let first = line('.')
  normal %
  let last = line('.')
  normal %
  call winrestview(saveview)
  if first < last
    return printf('\%%>%dl\%%<%dl%s', first-1, last+1, pattern)
  endif
  return "\b"
endfunction

" CScope {{{2
" cscope commands taken from help cscope
nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-_>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>

" Using 'CTRL-spacebar' then a search type makes the vim window
" split horizontally, with search result displayed in
" the new window.
nmap <C-Space>s :scs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>g :scs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>c :scs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>t :scs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>e :scs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-Space>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-Space>d :scs find d <C-R>=expand("<cword>")<CR><CR>

" Hitting CTRL-space *twice* before the search type does a vertical
" split instead of a horizontal one
nmap <C-Space><C-Space>s
	\:vert scs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space><C-Space>g
	\:vert scs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space><C-Space>c
	\:vert scs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space><C-Space>t
	\:vert scs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space><C-Space>e
	\:vert scs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space><C-Space>i
	\:vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-Space><C-Space>d
	\:vert scs find d <C-R>=expand("<cword>")<CR><CR>
"2}}}

"1}}}

" Programming {{{1
"---------------------------------------------------------------------

" C / C++ Section {{{2
augroup cpp
  " ReadTypes (TagHighlight plugin) on each Read, NewFile.
  " Can probably be done directly in the plugin but I haven't found a way yet.
  " This can lead to slow opening of .c, .cpp and .h files.
  autocmd BufRead,BufNewFile *.[ch] ReadTypes
  autocmd BufRead,BufNewFile *.cpp ReadTypes
  "autocmd BufRead,BufNewFile *.[ch] setlocal tabstop=4 shiftwidth=4 noexpandtab
  "autocmd BufRead,BufNewFile *.cpp setlocal tabstop=4 shiftwidth=4 noexpandtab
augroup END

if has('cscope')
  set cscopetag cscopeverbose

  if has('quickfix')
    set cscopequickfix=s-,c-,d-,i-,t-,e-
  endif

  cnoreabbrev csa cs add
  cnoreabbrev csf cs find
  cnoreabbrev csk cs kill
  cnoreabbrev csr cs reset
  cnoreabbrev css cs show
  cnoreabbrev csh cs help

  command! -nargs=0 Cscope cs add $VIMSRC/src/cscope.out $VIMSRC/src
endif

"2}}}

" Python section {{{2
let python_highlight_all = 1
autocmd FileType python syn keyword pythonDecorator True None False self

"autocmd BufNewFile,BufRead *.jinja set syntax=htmljinja
"autocmd BufNewFile,BufRead *.mako set ft=mako

autocmd FileType python inoremap <buffer> $r return
autocmd FileType python inoremap <buffer> $i import
autocmd FileType python inoremap <buffer> $p print
autocmd FileType python inoremap <buffer> $f #--- PH ----------------------------------------------<esc>FP2xi
autocmd FileType python map <buffer> <Leader>1 /class
autocmd FileType python map <buffer> <Leader>2 /def
autocmd FileType python map <buffer> <Leader>C ?class
autocmd FileType python map <buffer> <Leader>D ?def
"2}}}

" Javascript section {{{2
" Use jquery plugin
autocmd BufRead,BufNewFile *.js set filetype=javascript syntax=javascript.jquery
"2}}}

"1}}}

" Plugins {{{1
"---------------------------------------------------------------------

" Buff Explorer {{{2
let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=1
map <silent> <C-Tab> :BufExplorer<CR>
map <silent> <Leader>o :BufExplorer<CR>
"2}}}

" Zencoding {{{2
let g:user_zen_settings = {
\  'indentation' : '  '
\}
"2}}}

" Fuzzy Finder {{{2
let g:fuf_modesDisable = []
let g:fuf_mrufile_maxItem = 400
let g:fuf_mrucmd_maxItem = 400
nnoremap <silent> sj     :FufBuffer<CR>
nnoremap <silent> sk     :FufFileWithCurrentBufferDir<CR>
nnoremap <silent> sK     :FufFileWithFullCwd<CR>
nnoremap <silent> s<C-k> :FufFile<CR>
nnoremap <silent> sl     :FufCoverageFileChange<CR>
nnoremap <silent> sL     :FufCoverageFileChange<CR>
nnoremap <silent> s<C-l> :FufCoverageFileRegister<CR>
nnoremap <silent> sd     :FufDirWithCurrentBufferDir<CR>
nnoremap <silent> sD     :FufDirWithFullCwd<CR>
nnoremap <silent> s<C-d> :FufDir<CR>
nnoremap <silent> sn     :FufMruFile<CR>
nnoremap <silent> sN     :FufMruFileInCwd<CR>
nnoremap <silent> sm     :FufMruCmd<CR>
nnoremap <silent> su     :FufBookmarkFile<CR>
nnoremap <silent> s<C-u> :FufBookmarkFileAdd<CR>
vnoremap <silent> s<C-u> :FufBookmarkFileAddAsSelectedText<CR>
nnoremap <silent> si     :FufBookmarkDir<CR>
nnoremap <silent> s<C-i> :FufBookmarkDirAdd<CR>
nnoremap <silent> st     :FufTag<CR>
nnoremap <silent> sT     :FufTag!<CR>
nnoremap <silent> s<C-]> :FufTagWithCursorWord!<CR>
nnoremap <silent> s,     :FufBufferTag<CR>
nnoremap <silent> s<     :FufBufferTag!<CR>
vnoremap <silent> s,     :FufBufferTagWithSelectedText!<CR>
vnoremap <silent> s<     :FufBufferTagWithSelectedText<CR>
nnoremap <silent> s}     :FufBufferTagWithCursorWord!<CR>
nnoremap <silent> s.     :FufBufferTagAll<CR>
nnoremap <silent> s>     :FufBufferTagAll!<CR>
vnoremap <silent> s.     :FufBufferTagAllWithSelectedText!<CR>
vnoremap <silent> s>     :FufBufferTagAllWithSelectedText<CR>
nnoremap <silent> s]     :FufBufferTagAllWithCursorWord!<CR>
nnoremap <silent> sg     :FufTaggedFile<CR>
nnoremap <silent> sG     :FufTaggedFile!<CR>
nnoremap <silent> so     :FufJumpList<CR>
nnoremap <silent> sp     :FufChangeList<CR>
nnoremap <silent> sq     :FufQuickfix<CR>
nnoremap <silent> sy     :FufLine<CR>
nnoremap <silent> sh     :FufHelp<CR>
nnoremap <silent> se     :FufEditDataFile<CR>
nnoremap <silent> sr     :FufRenewCache<CR>
nnoremap <silent> s*     :FufCoverageFile<CR>
nnoremap <silent> sc     :%s///n<CR>
"2}}}

"1}}}

" License {{{1
" ---------------------------------------------------------------------
"
" Copyright (c) 2011 Jeremy Attali
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
" THE SOFTWARE.
"1}}}
