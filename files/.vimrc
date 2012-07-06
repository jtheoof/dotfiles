" Name:     Jeremy Attali's .vimrc
" Author:   Jeremy Attali
" URL:
" License:  MIT license (see end of this file)
" Created:  In Paris
" Modified: 2011 Apr 14
" Comment:  Big thanks to amix.dk: http://amix.dk/vim/vimrc.html

" Pathogen {{{1
"------------------------------------------------------------------------------
" Pathogen must be the first plugin to load before anything else
runtime bundle/vim-pathogen/autoload/pathogen.vim
" Bundle: tpope/vim-pathogen
call pathogen#infect()
call pathogen#helptags()     " don't call it everytime cause it's slow?
"------------------------------------------------------------------------------
"1}}}

runtime macros/matchit.vim   " smarter use of '%'

filetype plugin indent on    " put filetype plugin back on after pathogen
set nocompatible             " use vim defaults, we don't care about vi anymore
syntax on                    " enable syntax

" Bundles {{{1
"------------------------------------------------------------------------------
" See: https://github.com/bronson/vim-update-bundles

" Ignore those
" Static: static

" Programming
" Bundle: vim-scripts/jQuery
" Bundle: vim-scripts/TagHighlight
" Bundle: othree/html5.vim
" Bundle: mattn/zencoding-vim
" Bundle: cakebaker/scss-syntax.vim

" Text
" Bundle: mileszs/ack.vim
" Bundle: tpope/vim-markdown
" Bundle: ervandew/supertab
" Bundle: vim-scripts/FuzzyFinder
" Bundle: vim-scripts/L9
" Bundle: vim-scripts/hexman.vim

" VCS
" Bundle: tpope/vim-git
" Bundle: tpope/vim-fugitive

" IDE
" Bundle: bcaccinolo/bclose
" Bundle: vim-scripts/bufexplorer.zip
" Bundle: scrooloose/nerdtree

" Color
" Bundle: altercation/vim-colors-solarized
" Bundle: noahfrederick/Hemisu
" Bundle: vim-scripts/Color-Sampler-Pack
"------------------------------------------------------------------------------
"1}}}

" Main options {{{1
"------------------------------------------------------------------------------
"set autochdir                      " Automatically follow current directory
set autoread                       " automatically reload file changes
set autowrite                      " automatically save before :next or :make        
set backspace=indent,eol,start     " more powerful backspacing
set nobackup                       " do not keep a backup file
set cursorline                     " Highlight current line
set diffopt+=vertical              " make vertical default split
set esckeys                        " allow usage of cur keys within insert mode
set encoding=utf8                  " utf-8 encoding
set gdefault                       " default global in regex
set foldlevel=0                    " fold to level 0 when opening file
set foldmethod=marker              " basic marker as default folding method
set history=1000                   " history back trace
set laststatus=2                   " allways show status line
set lazyredraw                     " don't redraw while executing macros
set ruler                          " show the cursor position all the time
set number                         " show line numbers
set modeline                       " last lines in document sets vim mode
set modelines=5                    " number lines checked for modelines
set nostartofline                  " don't jump to first character when paging
set shortmess=atI                  " Abbreviate messages
set showcmd                        " display incomplete commands
set showmode                       " Show current mode
set scrolloff=3                    " Make cursor offset
set splitbelow                     " split at the bottom
set splitright                     " vsplit on right
if exists("+spelllang")
  set spelllang=en_us              " english is good enough
  set spellfile=~/.vim/spell/en.utf-8.add
endif
set title                          " show title in console title bar
set ttyfast                        " smoother changes
"set viminfo='10,\"100             " 10 marks, 100 lines
set viminfo='10,\"100,:20,%        " 10 marks, 100 lines, 20 command lines
"set whichwrap=<,>,h,l,[,]         " move freely between lines (wrap)
set wildmenu
set wildchar=<Tab> wildmenu wildmode=full
set wildcharm=<C-Z>
set wildmode=longest,full

" Turn backup off, since most stuff is in SVN, git anyway...
set nobackup
set nowb
set noswapfile

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

" Persistent undo
if exists("+undofile")
  set undofile
  set undolevels=1000 "maximum number of changes that can be undone
  set undoreload=10000 "maximum number lines to save for undo on a buffer reload
  if has("win32")
    set undodir=~/vimfiles/undodir
  else
    set undodir=~/.vim/undodir
  endif
endif

" X Clipboard
if has("unix")
  set clipboard=unnamedplus
else
  set clipboard=unnamed
endif


" Word wrapping
set wrap
set linebreak
set textwidth=79
"set colorcolumn=80
set formatoptions=qrn1
command! -nargs=* Wrap set wrap linebreak nolist

" Search
set ignorecase   " ignore case when searching
set smartcase    " ignore case only if all chars are lower
set incsearch    " do incremental searching
set hlsearch     " highlight searches

" Indentation
"set smarttab
set expandtab
set copyindent
set preserveindent
set softtabstop=0
set shiftwidth=4
set tabstop=4

" OmniCompletion
set omnifunc=syntaxcomplete#Complete


" Don't flash errors and disable sound
set novisualbell
set noerrorbells
"set noerrorbells visualbell t_vb=

" Set default tags file and some extra
set tags=./tags;/

" List invisible chars
set listchars=tab:▸\ ,eol:¬
" set list 							" use <Leader>l switch list usage

let mapleader=","
"------------------------------------------------------------------------------
"1}}}

" Functions {{{1
"------------------------------------------------------------------------------

"------------------------------------------------------------------------------
"1}}}

" GUI {{{1
"------------------------------------------------------------------------------
"colorscheme mustang
"colorscheme hemisu
colorscheme solarized
"colorscheme zenburn
set background=dark
if has("gui_running")
  if has("gui_gtk2")
    "set guifont=Ubuntu\ Mono\ 10
    set guifont=Ubuntu\ Mono\ 12
    "set guifont=Monaco\ 8
      "set guifont=Consolas\ 10
  elseif has("gui_win32")
      set guifont=Consolas:h10
  endif

  "set guioptions-=m               " remove menu bar
  "set guioptions-=T               " remove toolbar
  "set guioptions-=r               " remove right-hand scroll bar
  set guioptions=                  " turns off every option
else
  set t_Co=256
endif
" }}}

" Mappings {{{1
"------------------------------------------------------------------------------

" Leader {{{2
" With a map leader it's possible to do extra key combinations
" like <Leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Use Ack shortcut
nnoremap <Leader>aa :Ack ''<Left>
" Find current word
nnoremap <Leader>acw :exec("Ack '\\b".expand("<cword>")."\\b'")<CR>

" change to directory containing current file
nmap <Leader>cd :cd %:p:h<CR>

" Fast saving
nmap <Leader>w :w!<CR>

" Use <Leader>W to “strip all trailing whitespace in the current file”
nnoremap <Leader>W :%s/\s\+$//<CR>:let @/=''<CR>

" Mapping to NERDTree
nmap <silent> <Leader>p :NERDTreeToggle<CR>

" Highlight current work
nnoremap <Leader>hcw :call HighlightWord()<CR>

" Load current file
nmap <Leader>so :so %<CR>

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

" Format to XML, JSON, ...
map <Leader>fx :! tidy -qmi -xml -utf8 % <CR>
map <Leader>fj :r ! python -mjson.tool < % <CR>ggdd

" Shortcut to rapidly toggle `set list`
nmap <Leader>l :set list!<CR>
"2}}}

" Normal mode {{{2
" Easier navigation through code
" Deactivated it because it seems to conflit with <C-i> to jump forward
" nnoremap <Tab> %
" Go to first character
nnoremap <Home> ^

" Window navigation
nnoremap <C-Right> <C-w><Right>
nnoremap <C-Left> <C-w><Left>
nnoremap <C-Up> <C-w><Up>
nnoremap <C-Down> <C-w><Down>

" Useful navigation
nnoremap <PageUp> <C-U>
nnoremap <PageDown> <C-D>
nnoremap <S-Down> 5<C-E>
nnoremap <S-Up> 5<C-Y>

" Saving file
nnoremap <silent> <C-S> :w<CR>

" Cleanup search
nnoremap <C-K> :let @/ = ""<CR>

nnoremap <silent> <F1> :Explore<CR>
nnoremap <C-F1> :tabe **/<cfile><CR>
nnoremap <F2> :BufExplorer<CR>
nnoremap <F3> :NERDTreeToggle<CR>
nnoremap <F4> :QFix<CR>
nnoremap <C-F4> :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
nnoremap <F7> :make<Return>
nnoremap <F9> :cprevious<Return>
nnoremap <F10> :cnext<Return>
nnoremap <F11> :split %<CR>
nnoremap <F12> :vsplit %<CR>

" Navigate through folded line
nnoremap <M-j> gj
nnoremap <M-k> gk
nnoremap <M-4> g$
nnoremap <M-6> g^
nnoremap <M-0> g^

" Navigate through tags
nnoremap <M-b> :tselect<CR>
nnoremap <M-n> :tnext<CR>
nnoremap <M-m> :tprevious<CR>
nnoremap <M-Home> :tselect<CR>
nnoremap <M-PageDown> :tnext<CR>
nnoremap <M-PageUp> :tprevious<CR>

" Alt-right/left to navigate forward/backward in the tags stack
nnoremap <M-Left> <C-T>
nnoremap <M-Right> <C-]>
" Alt-up/down to navigate through history
nnoremap <M-Up> <C-o>
nnoremap <M-Down> <C-i>

" Map Ctrl-Space to cscope find current word
nnoremap <C-@><C-@> :cs find s <C-R>=expand("<cword>")<CR><CR>
"2}}}

" Insert mode {{{2
inoremap <Home> <Esc>^i

" Easy navigation
imap <C-Right>  <Esc><C-Right>a
imap <C-Left>  <Esc><C-Left>a
imap <C-Up> <Esc><C-Up>a
imap <C-Down>  <Esc><C-Down>a
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
imap <C-Del> <Esc><Right>dwi
" Insert unicode characters
imap <C-u> <C-v>u
"2}}}

" Visual mode {{{2

" Navigate through folded line
vnoremap <M-j> gj
vnoremap <M-k> gk
vnoremap <M-4> g$
vnoremap <M-6> g^
vnoremap <M-0> g^

" Tabs
vmap <Tab> >gv
vmap <BS> <gv

" Folding
vmap <Space> zf

" Substitutiion
vmap ! y<Esc>:%s/<C-R>"/

vmap r "_dP
"2}}}

"------------------------------------------------------------------------------
"1}}}

" Auto commands {{{1
"------------------------------------------------------------------------------

" Automatically fitting a quickfix window height
au FileType qf call AdjustWindowHeight(3, 20)
function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

" This autocommand jumps to the last known position in a file
" just after opening it, if the '"' mark is set:
"autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Auto save when focus is lost
autocmd FocusLost * execute ":silent! wa"

" Auto change directory on Buffer Entering
" autocmd BufEnter * execute ":silent! lcd %:p:h"

"------------------------------------------------------------------------------
"1}}}

" Spell checking {{{1
"------------------------------------------------------------------------------

" Use :mkspell! ~/.vim/spell/en.utf-8.add to regenerate spelling binary files

" Pressing ,ss will toggle and untoggle spell checking
map <Leader>ss :setlocal spell!<CR>

" Shortcuts using <Leader>
map <Leader>sn ]s
map <Leader>sp [s
map <Leader>sa zg
map <Leader>s? z=
"------------------------------------------------------------------------------
"1}}}

" Search {{{1
"------------------------------------------------------------------------------

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

"------------------------------------------------------------------------------
"1}}}

" Programming {{{1
"------------------------------------------------------------------------------

" Java {{{2
augroup filetype_java
    autocmd!
    autocmd Filetype java set makeprg=ant-android
augroup END
"2}}}

" Python {{{2
let python_highlight_all = 1
augroup filetype_python
    autocmd!
    autocmd FileType python syn keyword pythonDecorator True None False self
    autocmd FileType python set omnifunc=pythoncomplete#Complete
    autocmd FileType python inoremap <buffer> $r return
    autocmd FileType python inoremap <buffer> $i import
    autocmd FileType python inoremap <buffer> $p print
    autocmd FileType python map <buffer> <Leader>1 /class
    autocmd FileType python map <buffer> <Leader>2 /def
    autocmd FileType python map <buffer> <Leader>C ?class
    autocmd FileType python map <buffer> <Leader>D ?def
augroup END
"2}}}

" Javascript {{{2
augroup filetype_javascript
    autocmd!
    autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType javascript set shiftwidth=4 tabstop=4 expandtab textwidth=0
    autocmd BufRead,BufNewFile *.js set filetype=javascript syntax=javascript.jquery
augroup END
"2}}}

" HTML {{{2
" Disable underlines in <a> tags as well as bold, italic
" See: :help html
let html_no_rendering = 1
augroup filetype_html
    autocmd!
    autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
    autocmd FileType html set shiftwidth=2 tabstop=2 expandtab textwidth=0
    autocmd FileType xhtml set shiftwidth=2 tabstop=2 expandtab textwidth=0
    autocmd FileType tpl set shiftwidth=2 tabstop=2 expandtab textwidth=0
    autocmd FileType smarty set shiftwidth=2 tabstop=2 expandtab textwidth=0
augroup END
"2}}}

" CSS {{{2
augroup filetype_css
    autocmd!
    autocmd FileType css set omnifunc=csscomplete#CompleteCSS
augroup END
"2}}}

"------------------------------------------------------------------------------
"1}}}

" Plugins {{{1
"------------------------------------------------------------------------------

" Ack {{{2
if has("unix")
  let g:ackprg="ack-grep -H --nocolor --nogroup --column --sort-files"
endif
"2}}}

" Buff Explorer {{{2
let g:bufExplorerDefaultHelp=0 		 " Do not show default help
let g:bufExplorerShowRelativePath=1  " Show relative path
let g:bufExplorerFindActive=0 		 " Do not go to active window
map <silent> <C-Tab> :BufExplorer<CR>
map <silent> <Leader>o :BufExplorer<CR>
"2}}}

" Zencoding {{{2
let g:user_zen_settings = {
\  'indentation' : '  '
\}
"2}}}

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
"2}}}

"------------------------------------------------------------------------------
"1}}}

" License {{{1
"------------------------------------------------------------------------------
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
"------------------------------------------------------------------------------
"1}}}
