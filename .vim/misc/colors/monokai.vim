" vim:set sts=4 sw=4 et:

" Initalization {{{

hi clear
if exists("syntax_on")
    syntax reset
endif
let colors_name = "monokai"
set background=dark

" }}}
" Palette {{{
"
" Set both gui and terminal color values in separate conditional statements
" Due to possibility that CSApprox is running (though I suppose we could just
" leave the hex values out entirely in that case and include only cterm colors)
" We also check to see if user has set monokai (force use of the
" neutral gray monotone palette component)
if (has("gui_running"))
    let s:vmode       = "gui"
    let s:red         = "#F00F60"
    let s:green       = "#98DD31"
    let s:blue        = "#3285D2"
    let s:cyan        = "#5CD1E8"
    let s:magenta     = "#F00F60"
    let s:yellow      = "#DED368"
    let s:orange      = "#FD971F"
    let s:purple      = "#9B69FA"
    let s:grey        = "#75715E"
    let s:white       = "#F8F8F2"
    let s:black       = "#3E3D32"
    let s:back        = "#222222"
    let s:front       = "#F8F8F2"
elseif &t_Co == 256
    let s:vmode       = "cterm"
    let s:red         = "1"
    let s:green       = "2"
    let s:blue        = "4"
    let s:cyan        = "6"
    let s:magenta     = "5"
    let s:yellow      = "11"
    let s:orange      = "3"
    let s:purple      = "4"
    let s:grey        = "8"
    let s:white       = "15"
    let s:black       = "0"
    let s:back        = "NONE"
    let s:front       = "7"
else
    let s:vmode       = "cterm"
    let s:red         = "1"
    let s:green       = "2"
    let s:blue        = "4"
    let s:cyan        = "6"
    let s:magenta     = "5"
    let s:yellow      = "3"
    let s:orange      = "3"
    let s:purple      = "5"
    let s:grey        = "0"
    let s:white       = "7"
    let s:black       = "0"
    let s:back        = "NONE"
    let s:front       = "7"
endif
"}}}
" Formatting {{{

let s:none            = "NONE"
let s:t_none          = "NONE"
let s:n               = "NONE"
let s:c               = ",undercurl"
let s:r               = ",reverse"
let s:s               = ",standout"
let s:ou              = ""
let s:ob              = ""

if (&t_Co == 8 )
    let s:b           = ""
    let s:bb          = ",bold"
else
    let s:b           = ",bold"
    let s:bb          = ""
endif

let s:u           = ",underline"
let s:i           = ",italic"

" }}}
" Primitives {{{

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
" Colors {{{

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
" Basic {{{

" Note that link syntax to avoid duplicate configuration doesn't work with the
" exe compiled formats.

exe "hi! Normal"         .s:fmt_none   .s:fg_front     .s:bg_back

exe "hi! Comment"        .s:fmt_none   .s:fg_grey      .s:bg_none
"       *Comment         any comment

exe "hi! Constant"       .s:fmt_none   .s:fg_purple    .s:bg_none
"       *Constant        any constant
"        Number          a number constant: 234, 0xff
"        Boolean         a boolean constant: TRUE, false
"        Float           a floating point constant: 2.3e10
"
exe "hi! String"         .s:fmt_none   .s:fg_orange    .s:bg_none
exe "hi! Character"      .s:fmt_none   .s:fg_orange    .s:bg_none
"        String          a string constant: "this is a string"
"        Character       a character constant: 'c', '\n'

exe "hi! Identifier"     .s:fmt_none   .s:fg_green     .s:bg_none
"       *Identifier      any variable name

exe "hi! Function"       .s:fmt_none   .s:fg_green     .s:bg_none
"        Function        function name (also: methods for classes)

exe "hi! Statement"      .s:fmt_none   .s:fg_magenta   .s:bg_none
"       *Statement       any statement
"        Conditional     if, then, else, endif, switch, etc.
"        Repeat          for, do, while, etc.
"        Label           case, default, etc.
"        Operator        "sizeof", "+", "*", etc.
"        Keyword         any other keyword
"        Exception       try, catch, throw

exe "hi! Operator"       .s:fmt_none   .s:fg_orange    .s:bg_none
"        Operator        "sizeof", "+", "*", etc.

exe "hi! PreProc"        .s:fmt_none   .s:fg_orange    .s:bg_none
"       *PreProc         generic Preprocessor
"        PreCondit       preprocessor #if, #else, #endif, etc.

exe "hi! Macro"          .s:fmt_none   .s:fg_purple    .s:bg_none
"        Macro           same as Define

exe "hi! Include"        .s:fmt_none   .s:fg_magenta   .s:bg_none
"        Include         preprocessor #include
exe "hi! Define"         .s:fmt_none   .s:fg_magenta   .s:bg_none
"        Define          preprocessor #define

exe "hi! Type"           .s:fmt_none   .s:fg_cyan      .s:bg_none
"       *Type            int, long, char, etc.
"        Structure       struct, union, enum, etc.
"        Typedef         A typedef

exe "hi! StorageClass"   .s:fmt_none   .s:fg_magenta   .s:bg_none
"        StorageClass    static, register, volatile, etc.

exe "hi! Special"        .s:fmt_none   .s:fg_yellow    .s:bg_none
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

exe "hi! Todo"           .s:fmt_none   .s:fg_white     .s:bg_orange
"       *Todo            anything that needs extra attention; mostly the
"                        keywords TODO FIXME and XXX

" }}}
" Advanced {{{

exe "hi! ColorColumn"        .s:fmt_none  .s:fg_none    .s:bg_black
exe "hi! Cursor"             .s:fmt_none  .s:fg_black   .s:bg_front
exe "hi! CursorLine"         .s:fmt_none  .s:fg_front   .s:bg_black
exe "hi! CursorLineNr"       .s:fmt_none  .s:fg_white   .s:bg_black
exe "hi! DiffAdd"            .s:fmt_none  .s:fg_black   .s:bg_green
exe "hi! DiffAdded"          .s:fmt_none  .s:fg_green   .s:bg_none
exe "hi! DiffChange"         .s:fmt_none  .s:fg_black   .s:bg_orange
exe "hi! DiffDelete"         .s:fmt_none  .s:fg_black   .s:bg_magenta
exe "hi! DiffRemoved"        .s:fmt_none  .s:fg_red     .s:bg_none
exe "hi! DiffText"           .s:fmt_none  .s:fg_black   .s:bg_orange
exe "hi! Directory"          .s:fmt_none  .s:fg_cyan    .s:bg_none
exe "hi! ErrorMsg"           .s:fmt_none  .s:fg_magenta .s:bg_none
exe "hi! FoldColumn"         .s:fmt_none  .s:fg_grey    .s:bg_black
exe "hi! Folded"             .s:fmt_none  .s:fg_grey    .s:bg_none
exe "hi! helpHyperTextJump"  .s:fmt_undr  .s:fg_orange  .s:bg_none
exe "hi! helpHyperTextEntry" .s:fmt_none  .s:fg_orange  .s:bg_none
exe "hi! IncSearch"          .s:fmt_none  .s:fg_black   .s:bg_orange
exe "hi! LineNr"             .s:fmt_none  .s:fg_grey    .s:bg_none
exe "hi! MatchParen"         .s:fmt_bold  .s:fg_front   .s:bg_black
exe "hi! ModeMsg"            .s:fmt_bold  .s:fg_none    .s:bg_none
exe "hi! MoreMsg"            .s:fmt_none  .s:fg_cyan    .s:bg_none
exe "hi! NonText"            .s:fmt_none  .s:fg_black   .s:bg_none
exe "hi! Pmenu"              .s:fmt_none  .s:fg_front   .s:bg_black
exe "hi! PmenuSbar"          .s:fmt_none  .s:fg_none    .s:bg_back
exe "hi! PmenuSel"           .s:fmt_none  .s:fg_black   .s:bg_yellow
exe "hi! PmenuThumb"         .s:fmt_none  .s:fg_front   .s:bg_none
exe "hi! Question"           .s:fmt_none  .s:fg_magenta .s:bg_none
exe "hi! Search"             .s:fmt_none  .s:fg_black   .s:bg_yellow
exe "hi! SignColumn"         .s:fmt_none  .s:fg_white   .s:bg_none
exe "hi! SpecialKey"         .s:fmt_none  .s:fg_black   .s:bg_none
exe "hi! SpellBad"           .s:fmt_curl  .s:fg_none    .s:bg_none    .s:sp_magenta
exe "hi! SpellCap"           .s:fmt_curl  .s:fg_none    .s:bg_none    .s:sp_cyan
exe "hi! SpellRare"          .s:fmt_curl  .s:fg_none    .s:bg_none    .s:sp_purple
exe "hi! StatusLine"         .s:fmt_none  .s:fg_white   .s:bg_black
exe "hi! StatusLineNC"       .s:fmt_none  .s:fg_grey    .s:bg_black
exe "hi! TabLine"            .s:fmt_none  .s:fg_grey    .s:bg_black
exe "hi! TabLineFill"        .s:fmt_none  .s:fg_none    .s:bg_black
exe "hi! TabLineSel"         .s:fmt_none  .s:fg_none    .s:bg_grey
exe "hi! Title"              .s:fmt_none  .s:fg_magenta .s:bg_none
exe "hi! VertSplit"          .s:fmt_none  .s:fg_black   .s:bg_none
exe "hi! Visual"             .s:fmt_none  .s:fg_none    .s:bg_black
exe "hi! WarningMsg"         .s:fmt_none  .s:fg_magenta .s:bg_none

" }}}
" Language {{{

hi! link cStatement              Green
hi! link cppStatement            Green
" CSS
hi! link cssAttributeSelector    Green
hi! link cssAuralProp            Cyan
hi! link cssBoxProp              Cyan
hi! link cssBraces               White
hi! link cssClassName            Cyan
hi! link cssColorProp            Cyan
hi! link cssDefinition           Cyan
hi! link cssFontDescriptorProp   Cyan
hi! link cssFontProp             Cyan
hi! link cssGeneratedContentProp Cyan
hi! link cssImportant            Magenta
hi! link cssListProp             Cyan
hi! link cssMediaBlock           Green
hi! link cssPagingProp           Cyan
hi! link cssPseudoClass          Green
hi! link cssRenderProp           Cyan
hi! link cssMarginProp           Cyan
hi! link cssTableProp            Cyan
hi! link cssTagName              Magenta
hi! link cssTextProp             Cyan
hi! link cssUIProp               Cyan
hi! link cssPositioningProp      Cyan
hi! link cssPaddingProp          Cyan
hi! link cssDimensionProp        Cyan
hi! link cssBackgroundProp       Cyan
hi! link cssFlexibleBoxProp      Cyan
hi! link cssBorderProp           Cyan
hi! link cssBorderOutlineProp    Cyan
" Git
hi! link gitrebaseFixup          Grey
" Java
hi! link javaStatement           Green
" Javascript
hi! link jsDocParam              Cyan
hi! link jsDocTags               Magenta
hi! link jsEnvComment            Comment
hi! link jsFuncArgs              Orange
hi! link jsFunction              Green
hi! link jsFuncCall              Cyan
hi! link jsFunctionKey           Green
hi! link jsStorageClass          Magenta
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
" SASS
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
" Less
hi! link lessVariable                Green
hi! link lessFunction                Red
hi! link lessClassName               Type

" }}}
" Plugin {{{

" Netrw
hi! link netrwExe                    Red

" BufExplorer
hi! link bufExplorerMapping          Identifier
hi! link bufExplorerTitle            Macro

" Syntastic
exe "hi! SyntasticErrorSign"       .s:fmt_none    .s:fg_magenta    .s:bg_none
exe "hi! SyntasticWarningSign"     .s:fmt_none    .s:fg_orange     .s:bg_none

exe "hi! MyTagListFileName"        .s:fmt_none    .s:fg_orange     .s:bg_none
exe "hi! fugitiveBlameAnnotation"  .s:fmt_none    .s:fg_magenta    .s:bg_none

" }}}
