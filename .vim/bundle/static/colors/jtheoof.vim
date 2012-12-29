" Vim color file
" Maintainer:  Jeremy Attali
" Last Change: 2012 Dec 25
" Version:     0.2.0
" Credits:     Damien Gombault <desintegr@gmail.com>
" Credits:     Ethan Schoonover <es@ethanschoonover.com>
" Info:        This colorscheme was greatly based on monokai.

" Colorscheme initialization {{{

hi clear
if exists("syntax_on")
  syntax reset
endif
let colors_name = "jtheoof"
set background=dark

" }}}
" GUI & CSApprox hexadecimal palettes"{{{
"
" Set both gui and terminal color values in separate conditional statements
" Due to possibility that CSApprox is running (though I suppose we could just
" leave the hex values out entirely in that case and include only cterm colors)
" We also check to see if user has set solarized (force use of the
" neutral gray monotone palette component)
if (has("gui_running"))
    let s:vmode       = "gui"
    let s:red         = "#E2302E"
    let s:green       = "#A6E22E"
    let s:blue        = "#3285D2"
    let s:cyan        = "#66D9EF"
    let s:magenta     = "#F92672"
    let s:yellow      = "#E6DB74"
    let s:orange      = "#FD971F"
    let s:purple      = "#AE81FF"
    let s:grey        = "#75715E"
    let s:white       = "#F8F8F2"
    let s:black       = "#3E3D32"
    let s:back        = "#272822"
    let s:front       = "#F8F8F2"
    "let s:search     = "#FFE792"
elseif &t_Co == 256
    let s:vmode       = "cterm"
    let s:red         = "197"
    let s:green       = "148"
    let s:blue        = ""
    let s:cyan        = "81"
    let s:magenta     = "197"
    let s:yellow      = "186"
    let s:orange      = "208"
    let s:purple      = "141"
    let s:grey        = "242"
    let s:white       = "231"
    let s:black       = "237"
    let s:back        = "235"
    let s:front       = "231"
    "let s:search     = "186"
else
    let s:vmode       = "cterm"
endif
"}}}
" Formatting options and null values for passthrough effect {{{

    let s:none            = "NONE"
    let s:t_none          = "NONE"
    let s:n               = "NONE"
    let s:c               = ",undercurl"
    let s:r               = ",reverse"
    let s:s               = ",standout"
    let s:ou              = ""
    let s:ob              = ""

" }}}
" Overrides dependent on user specified values and environment {{{

let s:b           = ",bold"
let s:bb          = ""
let s:u           = ",underline"
let s:i           = ",italic"

" }}}
" Highlighting primitives {{{

exe "let s:bg_none      = ' ".s:vmode."bg=".s:none      ."'"
exe "let s:bg_red       = ' ".s:vmode."bg=".s:red       ."'"
exe "let s:bg_green     = ' ".s:vmode."bg=".s:green     ."'"
exe "let s:bg_blue      = ' ".s:vmode."bg=".s:blue      ."'"
exe "let s:bg_cyan      = ' ".s:vmode."bg=".s:cyan      ."'"
exe "let s:bg_magenta   = ' ".s:vmode."bg=".s:magenta   ."'"
exe "let s:bg_yellow    = ' ".s:vmode."bg=".s:yellow    ."'"
exe "let s:bg_orange    = ' ".s:vmode."bg=".s:orange    ."'"
exe "let s:bg_purple    = ' ".s:vmode."bg=".s:purple    ."'"
exe "let s:bg_grey      = ' ".s:vmode."bg=".s:grey      ."'"
exe "let s:bg_white     = ' ".s:vmode."bg=".s:white     ."'"
exe "let s:bg_black     = ' ".s:vmode."bg=".s:black     ."'"
exe "let s:bg_back      = ' ".s:vmode."bg=".s:back      ."'"
exe "let s:bg_front     = ' ".s:vmode."bg=".s:front     ."'"

exe "let s:fg_none      = ' ".s:vmode."fg=".s:none      ."'"
exe "let s:fg_red       = ' ".s:vmode."fg=".s:red       ."'"
exe "let s:fg_green     = ' ".s:vmode."fg=".s:green     ."'"
exe "let s:fg_blue      = ' ".s:vmode."fg=".s:blue      ."'"
exe "let s:fg_cyan      = ' ".s:vmode."fg=".s:cyan      ."'"
exe "let s:fg_magenta   = ' ".s:vmode."fg=".s:magenta   ."'"
exe "let s:fg_yellow    = ' ".s:vmode."fg=".s:yellow    ."'"
exe "let s:fg_orange    = ' ".s:vmode."fg=".s:orange    ."'"
exe "let s:fg_purple    = ' ".s:vmode."fg=".s:purple    ."'"
exe "let s:fg_grey      = ' ".s:vmode."fg=".s:grey      ."'"
exe "let s:fg_white     = ' ".s:vmode."fg=".s:white     ."'"
exe "let s:fg_black     = ' ".s:vmode."fg=".s:black     ."'"
exe "let s:fg_back      = ' ".s:vmode."fg=".s:back      ."'"
exe "let s:fg_front     = ' ".s:vmode."fg=".s:front     ."'"

exe "let s:fmt_none     = ' ".s:vmode."=none".          " term=none".    "'"
exe "let s:fmt_bold     = ' ".s:vmode."=none".s:b.      " term=none".s:b."'"
exe "let s:fmt_bldi     = ' ".s:vmode."=none".s:b.      " term=none".s:b."'"
exe "let s:fmt_undr     = ' ".s:vmode."=none".s:u.      " term=none".s:u."'"
exe "let s:fmt_undb     = ' ".s:vmode."=none".s:u.s:b.  " term=none".s:u.s:b."'"
exe "let s:fmt_undi     = ' ".s:vmode."=none".s:u.      " term=none".s:u."'"
exe "let s:fmt_uopt     = ' ".s:vmode."=none".s:ou.     " term=none".s:ou."'"
exe "let s:fmt_curl     = ' ".s:vmode."=none".s:c.      " term=none".s:c."'"
exe "let s:fmt_ital     = ' ".s:vmode."=none".s:i.      " term=none".s:i."'"
exe "let s:fmt_stnd     = ' ".s:vmode."=none".s:s.      " term=none".s:s."'"
exe "let s:fmt_revr     = ' ".s:vmode."=none".s:r.      " term=none".s:r."'"
exe "let s:fmt_revb     = ' ".s:vmode."=none".s:r.s:b.  " term=none".s:r.s:b."'"
" revbb (reverse bold for bright colors) is only set to actual bold in low 
" color terminals (t_co=8, such as OS X Terminal.app) and should only be used 
" with colors 8-15.
exe "let s:fmt_revbb    = ' ".s:vmode."=none".s:r.s:bb.   " term=none".s:r.s:bb."'"
exe "let s:fmt_revbbu   = ' ".s:vmode."=none".s:r.s:bb.s:u." term=none".s:r.s:bb.s:u."'"

if has("gui_running")
    exe "let s:sp_none      = ' guisp=".s:none      ."'"
    exe "let s:sp_red       = ' guisp=".s:red       ."'"
    exe "let s:sp_green     = ' guisp=".s:green     ."'"
    exe "let s:sp_blue      = ' guisp=".s:blue      ."'"
    exe "let s:sp_cyan      = ' guisp=".s:cyan      ."'"
    exe "let s:sp_magenta   = ' guisp=".s:magenta   ."'"
    exe "let s:sp_yellow    = ' guisp=".s:yellow    ."'"
    exe "let s:sp_orange    = ' guisp=".s:orange    ."'"
    exe "let s:sp_purple    = ' guisp=".s:purple    ."'"
    exe "let s:sp_grey      = ' guisp=".s:grey      ."'"
    exe "let s:sp_white     = ' guisp=".s:white     ."'"
    exe "let s:sp_black     = ' guisp=".s:black     ."'"
    exe "let s:sp_back      = ' guisp=".s:back      ."'"
    exe "let s:sp_front     = ' guisp=".s:front     ."'"
else
    let s:sp_none      = ""
    let s:sp_red       = ""
    let s:sp_green     = ""
    let s:sp_blue      = ""
    let s:sp_cyan      = ""
    let s:sp_magenta   = ""
    let s:sp_yellow    = ""
    let s:sp_orange    = ""
    let s:sp_purple    = ""
    let s:sp_grey      = ""
    let s:sp_white     = ""
    let s:sp_black     = ""
    let s:sp_back      = ""
    let s:sp_front     = ""
endif

" }}}
" Basic colors {{{

exe "hi! Red"       .s:fmt_none    .s:fg_red        .s:bg_none
exe "hi! Green"     .s:fmt_none    .s:fg_green      .s:bg_none
exe "hi! Blue"      .s:fmt_none    .s:fg_blue       .s:bg_none
exe "hi! Cyan"      .s:fmt_none    .s:fg_cyan       .s:bg_none
exe "hi! Magenta"   .s:fmt_none    .s:fg_magenta    .s:bg_none
exe "hi! Yellow"    .s:fmt_none    .s:fg_yellow     .s:bg_none
exe "hi! Orange"    .s:fmt_none    .s:fg_orange     .s:bg_none
exe "hi! Purple"    .s:fmt_none    .s:fg_purple     .s:bg_none
exe "hi! Grey"      .s:fmt_none    .s:fg_grey       .s:bg_none
exe "hi! White"     .s:fmt_none    .s:fg_white      .s:bg_none
exe "hi! Black"     .s:fmt_none    .s:fg_black      .s:bg_none

" }}}
" Basic highlighting {{{

" Note that link syntax to avoid duplicate configuration doesn't work with the
" exe compiled formats.

exe "hi! Normal"         .s:fmt_none   .s:fg_front     .s:bg_back

exe "hi! Comment"        .s:fmt_none   .s:fg_grey      .s:bg_none
"       *Comment         any comment

exe "hi! Constant"       .s:fmt_none   .s:fg_purple    .s:bg_none
"       *Constant        any constant
"        String          a string constant: "this is a string"
"        Character       a character constant: 'c', '\n'
"        Number          a number constant: 234, 0xff
"        Boolean         a boolean constant: TRUE, false
"        Float           a floating point constant: 2.3e10
"
exe "hi! String"         .s:fmt_none   .s:fg_yellow    .s:bg_none
exe "hi! Character"      .s:fmt_none   .s:fg_yellow    .s:bg_none
"        String          a string constant: "this is a string"
"        Character       a character constant: 'c', '\n'

exe "hi! Identifier"     .s:fmt_none   .s:fg_green     .s:bg_none
"       *Identifier      any variable name
"        Function        function name (also: methods for classes)
"
exe "hi! Statement"      .s:fmt_none   .s:fg_magenta   .s:bg_none
"       *Statement       any statement
"        Conditional     if, then, else, endif, switch, etc.
"        Repeat          for, do, while, etc.
"        Label           case, default, etc.
"        Operator        "sizeof", "+", "*", etc.
"        Keyword         any other keyword
"        Exception       try, catch, throw

exe "hi! Operator"       .s:fmt_none   .s:fg_green     .s:bg_none
"        Operator        "sizeof", "+", "*", etc.

exe "hi! PreProc"        .s:fmt_none   .s:fg_orange    .s:bg_none
"       *PreProc         generic Preprocessor
"        Include         preprocessor #include
"        Define          preprocessor #define
"        Macro           same as Define
"        PreCondit       preprocessor #if, #else, #endif, etc.

exe "hi! Type"           .s:fmt_none   .s:fg_cyan      .s:bg_none
"       *Type            int, long, char, etc.
"        StorageClass    static, register, volatile, etc.
"        Structure       struct, union, enum, etc.
"        Typedef         A typedef

exe "hi! StorageClass"   .s:fmt_none   .s:fg_red       .s:bg_none
"        StorageClass    static, register, volatile, etc.

exe "hi! Special"        .s:fmt_none   .s:fg_white     .s:bg_none
"       *Special         any special symbol
"        SpecialChar     special character in a constant
"        Tag             you can use CTRL-] on this
"        Delimiter       character that needs attention like [(...
"        SpecialComment  special things inside a comment
"        Debug           debugging statements

exe "hi! Tag"            .s:fmt_none   .s:fg_green     .s:bg_none
"        Tag             you can use CTRL-] on this

exe "hi! Delimiter"      .s:fmt_none   .s:fg_magenta   .s:bg_none
"        Delimiter       character that needs attention like [(...

exe "hi! Underlined"     .s:fmt_undi   .s:fg_blue      .s:bg_none
"       *Underlined      text that stands out, HTML links

exe "hi! Ignore"         .s:fmt_none   .s:fg_none      .s:bg_none
"       *Ignore          left blank, hidden  |hl-Ignore|

exe "hi! Error"          .s:fmt_none   .s:fg_front     .s:bg_magenta
"       *Error           any erroneous construct

exe "hi! Todo"           .s:fmt_none   .s:fg_back      .s:bg_orange
"       *Todo            anything that needs extra attention; mostly the
"                        keywords TODO FIXME and XXX

" }}}
" Extended highlighting {{{

exe "hi Cursor"          .s:fmt_none   .s:fg_none      .s:bg_front
exe "hi CursorLine"      .s:fmt_none   .s:fg_front     .s:bg_black
exe "hi ColorColumn"     .s:fmt_none   .s:fg_black     .s:bg_none
exe "hi Directory"       .s:fmt_none   .s:fg_cyan      .s:bg_none
exe "hi DiffAdd"         .s:fmt_none   .s:fg_back      .s:bg_green 
exe "hi DiffChange"      .s:fmt_none   .s:fg_back      .s:bg_yellow
exe "hi DiffDelete"      .s:fmt_none   .s:fg_back      .s:bg_magenta
exe "hi DiffText"        .s:fmt_none   .s:fg_back      .s:bg_yellow
exe "hi ErrorMsg"        .s:fmt_none   .s:fg_magenta   .s:bg_none
exe "hi VertSplit"       .s:fmt_none   .s:fg_black     .s:bg_none
exe "hi Folded"          .s:fmt_none   .s:fg_grey      .s:bg_none
exe "hi FoldColumn"      .s:fmt_none   .s:fg_grey      .s:bg_black
exe "hi SignColum"       .s:fmt_none   .s:fg_grey      .s:bg_black
exe "hi IncSearch"       .s:fmt_none   .s:fg_back      .s:bg_orange
exe "hi LineNr"          .s:fmt_none   .s:fg_grey      .s:bg_black
exe "hi MatchParen"      .s:fmt_bold   .s:fg_front     .s:bg_back
exe "hi ModeMsg"         .s:fmt_bold   .s:fg_none      .s:bg_none
exe "hi MoreMsg"         .s:fmt_none   .s:fg_cyan      .s:bg_none
exe "hi NonText"         .s:fmt_none   .s:fg_black     .s:bg_none
exe "hi Pmenu"           .s:fmt_none   .s:fg_front     .s:bg_black
exe "hi PmenuSel"        .s:fmt_none   .s:fg_back      .s:bg_yellow
exe "hi PmenuSbar"       .s:fmt_none   .s:fg_none      .s:bg_back
exe "hi PmenuThumb"      .s:fmt_none   .s:fg_front     .s:bg_none
exe "hi Question"        .s:fmt_none   .s:fg_green     .s:bg_none
exe "hi Search"          .s:fmt_none   .s:fg_back      .s:bg_yellow
exe "hi SpecialKey"      .s:fmt_none   .s:fg_black     .s:bg_none
exe "hi SpellBad"        .s:fmt_curl   .s:fg_none      .s:bg_none   .s:sp_magenta
exe "hi SpellCap"        .s:fmt_curl   .s:fg_none      .s:bg_none   .s:sp_cyan
exe "hi SpellRare"       .s:fmt_curl   .s:fg_none      .s:bg_none   .s:sp_purple
exe "hi StatusLine"      .s:fmt_none   .s:fg_none      .s:bg_black
exe "hi StatusLineNC"    .s:fmt_none   .s:fg_grey      .s:bg_black
exe "hi TabLine"         .s:fmt_none   .s:fg_grey      .s:bg_black
exe "hi TabLineFill"     .s:fmt_none   .s:fg_none      .s:bg_black
exe "hi TabLineSel"      .s:fmt_none   .s:fg_none      .s:bg_black
exe "hi Title"           .s:fmt_none   .s:fg_magenta   .s:bg_none
exe "hi Visual"          .s:fmt_none   .s:fg_none      .s:bg_black
exe "hi WarningMsg"      .s:fmt_none   .s:fg_magenta   .s:bg_none

" }}}
" Plugin specific highlight groups {{{

exe "hi MyTagListFileName"      .s:fmt_none    .s:fg_orange     .s:bg_none

" }}}
" Language specific highlight groups {{{

hi! link cStatement              Green
hi! link cppStatement            Green
" CSS
hi! link cssBraces               White
hi! link cssFontProp             White
hi! link cssColorProp            White
hi! link cssTextProp             White
hi! link cssBoxProp              White
hi! link cssRenderProp           White
hi! link cssAuralProp            White
hi! link cssRenderProp           White
hi! link cssGeneratedContentProp White
hi! link cssPagingProp           White
hi! link cssTableProp            White
hi! link cssUIProp               White
hi! link cssFontDescriptorProp   White
" Java
hi! link javaStatement           Green
" Ruby
hi! link rubyClassVariable       White
hi! link rubyControl             Green
hi! link rubyGlobalVariable      White
hi! link rubyInstanceVariable    White
hi! link rubyDefine              Red
hi! link rubyRailsFilterMethod   Blue
hi! link rubyRailsRenderMethod   Blue
" HTML
hi! link htmlTag         Comment
hi! link htmlTagName     Conditional
hi! link htmlEndTag      Comment
hi! link htmlLink        Normal
hi! link htmlArg         Green
" CSS/SASS
hi! link cssTagName                  Yellow
hi! link sassVariable                Green
hi! link sassFunction                Red
hi! link sassMixing                  Red
hi! link sassMixin                   Red
hi! link sassExtend                  Red
hi! link sassFor                     Red
hi! link sassInterpolationDelimiter  Magenta
hi! link sassAmpersand               Character
hi! link sassId                      Identifier
hi! link sassClass                   Type
hi! link sassIdChar                  sassId
hi! link sassClassChar               sassClass

" }}}
" License {{{
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
"
" vim:foldmethod=marker:foldlevel=0
" }}}
