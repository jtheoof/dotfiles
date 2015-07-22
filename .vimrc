" vim:set sts=4 sw=4 et:

set nocompatible " be IMproved

" Vundle {{{1

filetype off " required for ftdetect to kick in
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" XXX required!
Bundle 'gmarik/vundle'

" Enhancements {{{

Bundle 'ervandew/supertab'
Bundle 'jlanzarotta/bufexplorer'
Bundle 'justinmk/vim-gtfo'
Bundle 'kien/ctrlp.vim'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-unimpaired'
Bundle 'tpope/vim-vinegar'
Bundle 'Z1MM32M4N/vim-superman'

" }}}
" Programming {{{

Bundle 'groenewege/vim-less'
Bundle 'mattn/emmet-vim'
Bundle 'pangloss/vim-javascript'
Bundle 'kchmck/vim-coffee-script'
Bundle 'scrooloose/syntastic'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-markdown'
Bundle 'SirVer/ultisnips'
Bundle 'editorconfig/editorconfig-vim'

if has("mac")
    Bundle 'rizzatti/dash.vim'
endif

" }}}
" Editor {{{

Bundle 'chrisbra/csv.vim'

" }}}
" Themes {{{

Bundle 'altercation/vim-colors-solarized'

" }}}
" Misc {{{

Bundle 'bling/vim-airline'
Bundle 'mkitt/tabline.vim'
Bundle 'nacitar/terminalkeys.vim'

" }}}

" Bypass Vundle for custom plugins.
" See: https://github.com/gmarik/vundle/issues/67

set rtp+=~/.vim/misc

"1}}}
" Init {{{1

filetype plugin indent on    " put filetype plugin back on after pathogen
syntax on                    " enable syntax
runtime macros/matchit.vim   " smarter use of '%'

" FIX: PluginUpdate => git pull: git-sh-setup: No such file or directory in MacVim (OK in non-GUI version of Vim)
" SEE: https://github.com/gmarik/Vundle.vim/issues/510#issuecomment-66959233
if has("gui_macvim")
    set shell=/bin/bash\ -l
endif

" 1}}}
" Options {{{1

" Theme
set background=light
colorscheme monokai

" Text editing
set encoding=utf8                       " utf-8 encoding
set formatoptions=tqrn1j                " see help
set number                              " show line numbers
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
set showcmd          " show commands as they are type
set showmode         " show current mode
set splitbelow       " split at the bottom
set splitright       " vsplit on right
set noruler          " do not show ruler

" History of: file marks, command lines, input line, searches.
" Also disable highlights on start and save buffers.
" history and viminfo are two separate settings.
" Putting the same value only makes it more consistent.
set history=5000
set viminfo='5000,:5000,@5000,/5000,h

"set whichwrap=<,>,h,l,[,]         " move freely between lines (wrap)
set wildchar=<Tab> wildmenu wildmode=full
set wildcharm=<C-Z>
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

" Set unnamedplus clipboard if present, default to unnamed
if has('unnamedplus')
    set clipboard=unnamedplus
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

" Session
set sessionoptions-=options

" Tags
set tags=./tags;/

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
nnoremap <silent> <Leader><Leader> :exe ":silent normal wa"<CR>

" Use <Leader>W to “strip all trailing whitespace in the current file”
nnoremap <Leader>W :%s/\s\+$//<CR>:let @/=''<CR>

" Fast editing of common files
map <Leader>ec :e! $HOME/.vim/misc/colors/monokai.vim<CR>
map <Leader>eg :e! $HOME/.gitconfig<CR>
map <Leader>et :e! $HOME/.tmux.conf<CR>
map <Leader>ev :e! $MYVIMRC<CR>
map <Leader>ex :set ft=xxd<CR>:%!xxd<CR>
map <Leader>ez :e! $HOME/.zshrc<CR>

noremap <Leader>giw :Ggrep <C-R><C-W><CR>

" Man helper
nnoremap <Leader>M "myiw:SuperMan <C-r>m<CR>

" Ctrl-P Buffer
nnoremap <Leader>pp :CtrlP<CR>
nnoremap <Leader>pb :CtrlPBuffer<CR>
nnoremap <Leader>pm :CtrlPMRU<CR>
nnoremap <Leader>pt :CtrlPTag<CR>

" Replace " with '
nnoremap <Leader>s' :perldo s/"(.*?)"/'\1'/g<CR>
nnoremap <Leader>s" :perldo s/'(.*?)'/"\1"/g<CR>
vnoremap <Leader>s' :perldo s/"(.*?)"/'\1'/g<CR>
vnoremap <Leader>s" :perldo s/'(.*?)'/"\1"/g<CR>

" Fast reload of common files
nnoremap <Leader>so :so %<CR>
nnoremap <Leader>sc :so $HOME/.vim/misc/colors/monokai.vim<CR>
nnoremap <Leader>sv :so $MYVIMRC<CR>

" Use :mkspell! ~/.vim/spell/en.utf-8.add to regenerate spelling binary files

" Pressing ,ss will toggle and untoggle spell checking
map <Leader>ss :setlocal spell!<CR>

" Opening closing tabs
map <Leader>tc :tabclose<CR>
map <Leader>td ,bd,tc
map <Leader>tt :tabnew %<CR>
map <Leader>tn :tabnew<CR>

" Quick toggles
nmap <Leader>ti :set ignorecase!<CR>
nmap <Leader>tl :set list!<CR>
nmap <Leader>tw :set wrap!<CR>

" 2}}}
" Normal mode {{{2

" Remap to : allowing to get rid of Shift
nnoremap ; :

" Quickly select pasted test remembering the selection type
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" Go to first character
nnoremap <Home> ^

" Normal wrapping navigation
nnoremap <Up> gk
nnoremap <Down> gj

" Moving over folds
nnoremap z<Up> zk
nnoremap z<Down> zj

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

nnoremap <silent> <C-S> :w<CR>
nnoremap <silent> <C-c> :q!<CR>
nnoremap <C-k> :let @/ = ""<CR>

nnoremap <silent> <F2> :BufExplorer<CR>
nnoremap <F4> :QFix<CR>
nnoremap <F7> :make<Return>

nnoremap <C-F11> :split<CR>
nnoremap <C-F12> :vsplit<CR>

" Make Y more consistent with C and D
nnoremap Y y$
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
inoremap <silent> <C-S> <Esc>:w<CR>i

" Delete current line
inoremap <C-D> <Esc>dda

" Function keys
imap <F7> <Esc>:make<CR>a

" map control-backspace to delete the previous word
imap <C-BS> <C-W>
" map control-del to remove word after cursor
imap <C-Del> <C-O>"_de
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
" cnoremap w!! w !sudo tee > /dev/null %

"2}}}

" 1}}}
" Auto commands {{{1

aug quickfix
    au!
    au FileType qf wincmd J                        " Place window at very bottom
    au FileType qf call AdjustWindowHeight(3, 20)  " Adjust size automatically
aug END

aug misc
    au!
    au BufNewFile,BufRead *.adoc setf asciidoc
    au BufNewFile,BufRead *.h    setf c
    au BufNewFile,BufRead *.blk  setf c
    au BufNewFile,BufRead *.blkk setf cpp
    au BufNewFile,BufRead *.iop  setf d
    au BufRead *.zsh-theme setf zsh
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

" Trim whitespaces
autocmd BufWritePre * :call StripTrailingWhitespaces()

" Save clipboard when vim exits
"au VimLeave * call system("xsel -ib", getreg('+'))

" 1}}}
" Plugins {{{1

" Ack {{{2

if has("unix")
    let g:ackhighlight = 1
    let g:ackprg = "ag --vimgrep"
endif

" 2}}}
" Buff Explorer {{{2

let g:bufExplorerDefaultHelp=0      " do not show default help
let g:bufExplorerShowRelativePath=1 " show relative path
let g:bufExplorerFindActive=0       " do not go to active window
noremap <silent> <Leader>bh :BufExplorerHorizontalSplit<CR>
noremap <silent> <C-Tab> :BufExplorer<CR>

" Taking care of small conflict between bufexplorer and surround.
augroup bufexplorer
    autocmd!
    autocmd BufEnter \[BufExplorer\] unmap ds
    autocmd BufLeave \[BufExplorer\] nmap ds <Plug>Dsurround
augroup END

" 2}}}
" CTRL-P {{{2

let g:ctrlp_by_filename = 1
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_cmd = 'CtrlPLastMode'
let g:ctrlp_match_window_bottom = 1
let g:ctrlp_max_files = 0
let g:ctrlp_regexp = 0
let g:ctrlp_show_hidden = 1
let g:ctrlp_switch_buffer = 'H' " Jump to opened window with <c-x>
let g:ctrlp_use_caching = 1
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -co --exclude-standard', 'find %s -type f']
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = {
    \ 'dir': '\v(node_modules|js-build|bower_components)'
    \ }
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
" netrw {{{2

let g:netrw_sort_options="i"
let g:netrw_liststyle=1

" 2}}}
" UltiSnips {{{

let g:UltiSnipsSnippetDirectories = ['ultisnips']
let g:UltiSnipsExpandTrigger = '<F1>'
let g:UltiSnipsListSnippets = '<C-F1>'
let g:UltiSnipsEditSplit = 'vertical'

" }}}
" Session {{{

let g:session_autosave = "no"

" }}}
" Syntastic {{{

let g:syntastic_mode_map = {
    \ 'mode': 'passive',
    \ 'active_filetypes': ['javascript'],
    \ 'passive_filetypes': [],
    \ }

let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_javascript_checkers = ['jshint', 'jscs']

" }}}
" Zencoding {{{2

let g:user_zen_settings = { 'indentation' : '  ' }

" 2}}}

" 1}}}
" Finish {{{

let vimrc_work = expand("$HOME/.vimrc_work")
if filereadable(vimrc_work)
    source $HOME/.vimrc_work
endif

" }}}
