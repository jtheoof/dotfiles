" Name:     Jeremy Attali's .vimrc
" Author:   Jeremy Attali
" URL:
" License:  MIT license (see end of this file)
" Created:  Paris
" Comment:  Big thanks to amix.dk: http://amix.dk/vim/vimrc.html

set nocompatible " be IMproved

" Vundle {{{1

filetype off " required for ftdetect to kick in
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" XXX required!
Bundle 'gmarik/vundle'

" Github
Bundle 'altercation/vim-colors-solarized'
Bundle 'ervandew/supertab'
Bundle 'groenewege/vim-less'
Bundle 'kien/ctrlp.vim'
Bundle 'maksimr/vim-jsbeautify'
Bundle 'mattn/zencoding-vim'
Bundle 'nacitar/terminalkeys.vim'
Bundle 'pangloss/vim-javascript'
Bundle 'SirVer/ultisnips'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/syntastic'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-markdown'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-unimpaired'
Bundle 'xolox/vim-misc'
Bundle 'xolox/vim-session'

" Vim scripts
Bundle 'bufexplorer.zip'

"1}}}
" Init {{{1

filetype plugin indent on    " put filetype plugin back on after pathogen
syntax on                    " enable syntax
runtime macros/matchit.vim   " smarter use of '%'

" 1}}}
" Main options {{{1

" Text editing
set encoding=utf8                       " utf-8 encoding
set formatoptions=tqrn1j                " see help
set number                              " show line numbers
set textwidth=78                        " 78 characters limit
set cmdheight=1                         " slightly bigger command line

set nowrap                              " no wrapping
set hidden                              " allow hidden buffers

" Vim specific
set autoread                            " automatically reload file changes
set autowriteall                        " same as autowrite but for all actions
set backspace=indent,eol,start          " more powerful backspacing
set diffopt+=vertical                   " make vertical default split
set foldlevel=0                         " fold to level 0 when opening file
set foldmethod=marker                   " basic marker as default folding method
set modeline                            " last lines in document sets vim mode
set modelines=5                         " number lines checked for modelines
set omnifunc=syntaxcomplete#Complete    " basic autocomplete from buffers

set noerrorbells                        " no error sounds
set nostartofline                       " don't jump to first char when paging
set novisualbell                        " no visual sounds

" Display
set title            " show title in console title bar
set lazyredraw       " don't redraw while executing macros
set laststatus=2     " always show status line
set scrolloff=3      " make cursor offset
set shortmess=atToO  " abbreviate messages oO is useful see help
set showmode         " show current mode
set splitbelow       " split at the bottom
set splitright       " vsplit on right
set noshowcmd        " do not display incomplete commands
set noruler          " do not show ruler

" History of: file marks, command lines, input line, searches.
" Also disable highlights on start and save buffers.
" history and viminfo are two separate settings.
" Putting the same value only makes it more consistent.
set history=5000
set viminfo='5000,:5000,@5000,/5000,h,%

"set whichwrap=<,>,h,l,[,]         " move freely between lines (wrap)
set wildchar=<Tab> wildmenu wildmode=full
set wildcharm=<C-Z>
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
set wildignore+=*/cache/*,*/undodir/*
set wildignore+=*/.build*/*,*/build/*,*/.deps/*
set wildignore+=*.pch,*.d,*.o,*.Po
set wildmenu
set wildmode=longest,full

" Turn backup off, since most stuff is in SVN, git anyway...
set nobackup
set nowb
set noswapfile

" Persistent undo
if exists("+undofile")
    set undofile
    set undolevels=1000 " maximum number of changes that can be undone
    set undoreload=10000 "maximum number lines to save for undo
    if has("win32")
        set undodir=~/vimfiles/undodir
    else
        set undodir=~/.vim/undodir
    endif
endif

" Spelling
if exists("+spelllang")
    set spelllang=en_us              " english is good enough
    set spellfile=~/.vim/spell/en.utf-8.add
endif

" Status line
set statusline=%t       "tail of the filename
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}] "file format
set statusline+=%h      "help file flag
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
set statusline+=%y      "filetype
set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file

" X Clipboard
if has("unix")
    if has('unnamedplus')
        set clipboard=unnamedplus
    else
        set clipboard=unnamed
    endif
else
    set clipboard=unnamed
endif

" Search
set gdefault     " default global in regex
set ignorecase   " ignore case when searching
set smartcase    " ignore case only if all chars are lower
set incsearch    " do incremental searching
set hlsearch     " highlight searches

" Indentation
set autoindent    " copy indentation from previous line
set expandtab     " transform tabs into spaces
set softtabstop=4
set shiftwidth=4

set cinoptions=
set cinoptions+=L0.5s          " align labels at 0.5 shiftwidth
set cinoptions+=:0.5s,=0.5s    " same for case labels and code following labels
set cinoptions+=g0.5s,h0.5s    " same for C++ stuff
set cinoptions+=t0             " type on the line before the function is not indented
set cinoptions+=(0,Ws          " indent in functions ( ... ) when it breaks
set cinoptions+=m1             " align the closing ) properly
set cinoptions+=j1,J1          " java/javascript -> fixes blocks

" Tags
set tags=tags;/,.tags;/,TAG;/

" List invisible chars
set listchars=eol:\ ,tab:▸\ ,trail:-,extends:>,precedes:<,nbsp:¤
set list

" 1}}}
" Variables {{{1

let mapleader=","
let g:is_posix = 1
" In Debian bug 361177, sh.vim learned a g:is_posix configuration value
" See: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=552108

" 1}}}
" Functions {{{1

" Auto adjust window height
function! AdjustWindowHeight(minheight, maxheight)
    exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

function! StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfunction

function! GitGrep(...)
    let save = &grepprg
    set grepprg=git\ grep\ -n\ $*
    let s = 'grep'
    for i in a:000
        let s = s . ' ' . i
    endfor
    exe s
    let &grepprg = save
endfunction
command! -nargs=? GG call GitGrep(<f-args>)

" 1}}}
" GUI {{{1

if has("gui_running")
    if has("gui_gtk2")
        set guifont=Ubuntu\ Mono\ 10
    elseif has("gui_win32")
        set guifont=Consolas:h10
    endif

    "set guioptions-=m               " remove menu bar
    "set guioptions-=T               " remove toolbar
    "set guioptions-=r               " remove right-hand scroll bar
    set guioptions=                  " turns off every option
endif

set background=dark
colorscheme monokai

" 1}}}
" Mappings {{{1

" Leader {{{2

" With a map leader it's possible to do extra key combinations
" like <Leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Use Ack shortcut
nnoremap <Leader>aa :Ack ''<Left>
" Find current word
nnoremap <Leader># "ayiw:Ack '<C-R>a'<CR>
nnoremap <Leader>aiw :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:exec("Ack '\\b".expand("<cword>")."\\b'")<CR>
nnoremap <Leader>aiW :let @/='\<<C-R>=expand("<cWORD>")<CR>\>'<CR>:exec("Ack '\\b".expand("<cWORD>")."\\b'")<CR>
vnoremap <Leader>a y<Esc>:Ack '<C-R>"'<CR>:let @/='<C-R>"'<CR>

" change to directory containing current file
nmap <Leader>cd :cd %:p:h<CR>

" Quick save
nnoremap <Leader>w :w<CR>
nnoremap <silent> <Leader><Leader> :wa<CR>

" Use <Leader>W to “strip all trailing whitespace in the current file”
nnoremap <Leader>W :%s/\s\+$//<CR>:let @/=''<CR>

" Highlight current work
nnoremap <Leader>hcw :call HighlightWord()<CR>

" Fast editing of common files
map <Leader>eg :e! $HOME/.gitconfig<CR>
map <Leader>ec :e! $HOME/.vim/colors/monokai.vim<CR>
map <Leader>et :e! $HOME/.tmux.conf<CR>
map <Leader>ev :e! $MYVIMRC<CR>
map <Leader>ex :set ft=xxd<CR>:%!xxd<CR>
map <Leader>ez :e! $HOME/.zshrc<CR>

noremap <Leader>giw :Ggrep <C-R><C-W><CR>

" Ctrl-P Buffer
nnoremap <Leader>pp :CtrlP<CR>
nnoremap <Leader>pb :CtrlPBuffer<CR>
nnoremap <Leader>pm :CtrlPMRU<CR>

" Replace " with '
nnoremap <Leader>s' :perldo s/"(.*?)"/'\1'/g<CR>
nnoremap <Leader>s" :perldo s/'(.*?)'/"\1"/g<CR>
vnoremap <Leader>s' :perldo s/"(.*?)"/'\1'/g<CR>
vnoremap <Leader>s" :perldo s/'(.*?)'/"\1"/g<CR>

" Fast reload of common files
nnoremap <Leader>so :so %<CR>
nnoremap <Leader>sc :so $HOME/.vim/colors/monokai.vim<CR>
nnoremap <Leader>sv :so $MYVIMRC<CR>

" Splitting windows the right way
" Thanks to: http://goo.gl/R73uk

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

" Opening closing tabs
map <Leader>tc :tabclose<CR>
map <Leader>td ,bd,tc
map <Leader>tt :tabnew %<CR>
map <Leader>tn :tabnew<CR>

" Format to XML, JSON, ...
map <Leader>fj :r ! python -mjson.tool < % <CR>ggdd
map <Leader>fh :! tidy -qmi -utf8 % <CR>
map <Leader>fx :! tidy -qmi -xml -utf8 % <CR>

" Quick toggles
nmap <Leader>ti :set ignorecase!<CR>
nmap <Leader>tl :set list!<CR>
nmap <Leader>tw :set wrap!<CR>

nnoremap <Leader>y% :let @+ = expand("%:p")<CR>

" 2}}}
" Normal mode {{{2

" Search should olways be 'very magic'
" Fix ack.vim in order to work properly
" Right now if you run AclFromSearch with a 'very magic' pattern
" the \v is not removed so the grep command launched is looking
" for it with the rest of the pattern
" nnoremap / /\v
" nnoremap ? ?\v

" Easier navigation through code
" Deactivated it because it seems to conflit with <C-i> to jump forward
" nnoremap <Tab> %

" Make Y more consistent with C and D
nnoremap Y y$

" Quickly select pasted test remembering the selection type
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" Go to first character
nnoremap <Home> ^

" Normal wrapping navigation
nnoremap <Up> gk
nnoremap <Down> gj

" Window navigation
nnoremap <C-Right> <C-w><Right>
nnoremap <C-Left> <C-w><Left>
nnoremap <C-Up> <C-w><Up>
nnoremap <C-Down> <C-w><Down>

" Useful navigation
nnoremap <PageUp> <C-U>
nnoremap <PageDown> <C-D>
nnoremap <S-Down> 3<C-E>
nnoremap <S-Up> 3<C-Y>

" Quick highlight
nmap <S-kMultiply> <Leader>hcw

nnoremap <silent> <C-S> :w<CR>  " Saving file
nnoremap <silent> <C-c> :q!<CR> " Close buffer/window
nnoremap <C-k> :let @/ = ""<CR> " Cleanup search

nnoremap <silent> <F1> :Explore<CR>
nnoremap <C-F1> :tabe **/<cfile><CR>
nnoremap <silent> <F2> :BufExplorer<CR>
nnoremap <F3> :NERDTreeToggle %<CR>
nnoremap <F4> :QFix<CR>
nnoremap <C-F4> :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
nnoremap <F5> :cprevious<CR>
nnoremap <C-F5> :tabdo windo edit<CR>
nnoremap <F6> :cnext<CR>
nnoremap <F7> :make<Return>
nnoremap <S-F7> yy:<C-R>"<BS><CR>
nnoremap <F8> :TagbarToggle<CR>
nnoremap <F9> :cprevious<Return>
nnoremap <F10> :cnext<Return>

nnoremap <C-F11> :split<CR>
nnoremap <C-F12> :vsplit<CR>

" Alt-right/left to navigate forward/backward in the tags stack
nnoremap <S-Left> <C-T>
nnoremap <S-Right> <C-]>
nnoremap <S-F9> :tselect<CR>
nnoremap <S-F11> :tprevious<CR>
nnoremap <S-F12> :tnext<CR>

" Yank current file
nnoremap <silent> ycf :let @* = expand("%:p")<CR>:let @+ = expand("%:p")<CR>

" 2}}}
" Insert mode {{{2

inoremap <Home> <Esc>^i

" Easy navigation
inoremap <C-Left>  <Esc>bi
inoremap <C-Right>  <Esc>lwi
inoremap <C-Up>    <Up>
inoremap <C-Down>  <Down>

imap <S-Down> <Esc><S-Down>a
imap <S-Up> <Esc><S-Up>a

" Saving file
imap <silent> <C-S> <Esc><C-S>a

" Delete current line
inoremap <C-D> <Esc>dda

" Function keys
imap <F7> <Esc>:make<CR>a

" map control-backspace to delete the previous word
imap <C-BS> <C-W>
" map control-del to remove word after cursor
imap <C-Del> <Esc><Right>"_dei
" Insert unicode characters
imap <C-u> <C-v>u

" 2}}}
" Visual mode {{{2

" Easy search through complex visual selections.
" Using 'very nomagic' to handle special characters like [$.-*]
vnoremap * y /\V<C-R>"<CR>

" Easy wrapping around visual selected text
vnoremap sb "zdi<b><C-R>z</b><Esc>
vnoremap st "zdi<?= <C-R>z ?><Esc>
vnoremap s' "zdi'<C-R>z'<Esc>
vnoremap s" "zdi"<C-R>z"<Esc>

" Navigate through folded line
vnoremap <M-j> gj
vnoremap <M-k> gk
vnoremap <M-4> g$
vnoremap <M-6> g^
vnoremap <M-0> g^

" Tabs
vnoremap <Space> <Esc>:'<,'>:s/^/ /<Enter>:let @/=""<Enter>gv
vnoremap <Backspace> <Esc>:'<,'>:s/^ //<Enter>:let @/=""<Enter>gv
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" Substitutiion
vmap ! y<Esc>:%s/<C-R>"/

" 2}}}
" Command mode {{{2

" Delete word from cursor to beginning of word
cnoremap <C-Backspace> <C-W>

" Allow saving of files as sudo when I forgot to start vim using sudo.
cnoremap w!! w !sudo tee > /dev/null %

"2}}}

" 1}}}
" Auto commands {{{1

aug quickfix
    au!
    au FileType qf wincmd J                        " Place window at very bottom
    au FileType qf call AdjustWindowHeight(3, 20)  " Adjust size automatically
aug END

" This autocommand jumps to the last known position in a file
" just after opening it, if the '"' mark is set:
if has("autocmd")
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g'\"" | endif
endif

" Auto save when focus is lost
au FocusLost * execute ":silent! wa"

" Show cursor line in insert mode
au InsertEnter * set cursorline
au InsertLeave * set nocursorline

au WinEnter * set colorcolumn=80
au WinLeave * set colorcolumn=

" Trim whitespaces
autocmd BufWritePre * :call StripTrailingWhitespaces()

" Save clipboard when vim exits
"au VimLeave * call system("xsel -ib", getreg('+'))

" 1}}}
" Spell checking {{{1

" Use :mkspell! ~/.vim/spell/en.utf-8.add to regenerate spelling binary files

" Pressing ,ss will toggle and untoggle spell checking
map <Leader>ss :setlocal spell!<CR>

" Shortcuts using <Leader>
map <Leader>sn ]s
map <Leader>sp [s
map <Leader>sa zg
map <Leader>s? z=

" 1}}}
" Search {{{1

" Count occurrences of highlighted search
nnoremap <silent> sc     :%s///n<CR>

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

" 1}}}
" Programming {{{1

" C {{{2

aug filetype_c
    au!
    au BufNewFile,BufRead *.c,*.h set cc=80
aug END

" 2}}}
" Java {{{2

aug filetype_java
    au!
    au Filetype java set makeprg=ant-android
aug END

" 2}}}
" Python {{{2

let python_highlight_all = 1
aug filetype_python
    au!
    au FileType python syn keyword pythonDecorator True None False self
    au FileType python set omnifunc=pythoncomplete#Complete
    au FileType python inoremap <buffer> $r return
    au FileType python inoremap <buffer> $i import
    au FileType python inoremap <buffer> $p print
    au FileType python map <buffer> <Leader>1 /class
    au FileType python map <buffer> <Leader>2 /def
    au FileType python map <buffer> <Leader>C ?class
    au FileType python map <buffer> <Leader>D ?def
aug END

" 2}}}
" Javascript {{{2

aug filetype_javascript
    au!
    au FileType javascript set omnifunc=javascriptcomplete#CompleteJS
    au FileType javascript set shiftwidth=4 expandtab
aug END

" 2}}}
" HTML {{{2

" Disable underlines in <a> tags as well as bold, italic
" See: :help html
let html_no_rendering = 1
aug filetype_html
    au!
    au FileType html   set omnifunc=htmlcomplete#CompleteTags
    au FileType html   set sw=2 sts=2 et tw=0 isk+=-
    au FileType xhtml  set sw=2 sts=2 et tw=0 isk+=-
    au FileType tpl    set sw=2 sts=2 et tw=0 isk+=-
    au FileType smarty set sw=2 sts=2 et tw=0 isk+=-
aug END

" 2}}}
" CSS {{{2

aug filetype_css
    au!
    au FileType css,less set omnifunc=csscomplete#CompleteCSS
    au FileType css,less set sts=4 sw=4 et isk+=-
aug END

" 2}}}
" Vala {{{2

aug filetype_vala
    au!
    au BufNewFile,BufRead *.vala,*.vapi set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
    au BufNewFile,BufRead *.vala,*.vapi setf vala
aug END

" 2}}}
" Yaml {{{2

aug filetype_yaml
    au!
    au FileType yaml set sts=2 sw=2
aug END

" 2}}}
" ZSH {{{2

aug filetype_zsh
    au!
    au BufRead *.zsh-theme setf zsh
aug END

" 2}}}
" Intersec {{{2

aug intersec
    au!
    au BufNewFile,BufRead *.iop  setf d
    au BufNewFile,BufRead *.blk  setf c
    au BufNewFile,BufRead *.blkk setf cpp
aug END

" 2}}}

" 1}}}
" Plugins {{{1

" Ack {{{2

if has("unix")
    let g:ackhighlight = 1
    let g:ackprg = "ack-grep -H --nocolor --nogroup --column --sort-files"
endif

" 2}}}
" Buff Explorer {{{2

let g:bufExplorerDefaultHelp=0          " Do not show default help
let g:bufExplorerShowRelativePath=1     " Show relative path
let g:bufExplorerFindActive=0           " Do not go to active window
map <silent> <C-Tab> :BufExplorer<CR>
map <silent> <Leader>o :BufExplorer<CR>

" Taking care of small conflict between bufexplorer and surround
autocmd BufEnter \[BufExplorer\] unmap ds
autocmd BufLeave \[BufExplorer\] nmap ds <Plug>Dsurround

" 2}}}
" Fuzzy Finder {{{2

let g:fuf_coveragefile_exclude = '\v\~$|\.(o|obj|exe|&ll|bak|orig|swp)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])'
let g:fuf_keyNextPattern = '<C-d>'
nnoremap <silent> sj     :FufBuffer<CR>
nnoremap <silent> sk     :FufFileWithCurrentBufferDir<CR>
nnoremap <silent> sK     :FufFileWithFullCwd<CR>
nnoremap <silent> s<C-k> :FufFile<CR>
nnoremap <silent> ss     :FufCoverageFile!<CR>
nnoremap <silent> sS     :FufCoverageFile<CR>
nnoremap <silent> s*     :FufCoverageFile<CR>
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

" 2}}}
" CTRL-P {{{2

let g:ctrlp_cmd = 'CtrlPLastMode'
let g:ctrlp_by_filename = 1
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_show_hidden = 1
let g:ctrlp_max_files = 0
let g:ctrlp_match_window_bottom = 1
let g:ctrlp_regexp = 0
let g:ctrlp_use_caching = 1
let g:ctrlp_working_path_mode = ''
let g:ctrlp_switch_buffer = 'H' " Jump to opened window with <c-x>

let g:ctrlp_prompt_mappings = {
    \ 'PrtDeleteWord()':      ['<c-w>', '<c-bs>'],
    \ 'AcceptSelection("h")': ['<c-f11>', '<c-h>'],
    \ 'AcceptSelection("v")': ['<c-f12>', '<c-v>'],
    \ 'ToggleType(1)':        ['<c-b>', '<c-down>', '<c-pagedown>'],
    \ 'ToggleType(-1)':       ['<c-f>', '<c-up>', '<c-pageup>'],
    \ 'MarkToOpen()':         ['<c-x>', '<c-a>'],
    \ }

 " 2}}}
" LanguageTool {{{2

let g:languagetool_jar = '/usr/share/languagetool/languagetool-commandline.jar'

" 2}}}
" NERDTree {{{2

noremap <Leader>n :NERDTree<space><cr>
noremap <Leader>nb :NERDTreeFromBookmark<space>
noremap <Leader>nn :NERDTreeToggle<cr>
noremap <Leader>no :NERDTreeToggle<space>
noremap <Leader>nf :NERDTreeFind<cr>
noremap <Leader>nc :NERDTreeClose<cr>

let NERDTreeAutoDeleteBuffer=1 " always remove deleted buffer

" 2}}}
" UltiSnips {{{

let g:UltiSnipsSnippetsDir = '~/.vim/ultisnips'
let g:UltiSnipsSnippetDirectories = ['UltiSnips', 'ultisnips']
let g:UltiSnipsExpandTrigger = '<F1>'
let g:UltiSnipsListSnippets = '<F2>'
let g:UltiSnipsJumpForwardTrigger = '<F3>'
let g:UltiSnipsJumpBackwardTrigger = '<F4>'
let g:UltiSnipsEditSplit = 'vertical'

" }}}
" session {{{

let g:session_autosave = "no"

" }}}
" Syntastic {{{

let g:syntastic_mode_map = {
    \ 'mode': 'passive',
    \ 'active_filetypes': ['javascript'],
    \ 'passive_filetypes': [],
    \ }

" }}}
" Zencoding {{{2

let g:user_zen_settings = { 'indentation' : '  ' }

" 2}}}

" 1}}}
" License {{{1

"
" Copyright (c) 2013 Jeremy Attali
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

" 1}}}

" vim:set sts=4 sw=4 et:
