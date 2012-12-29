" Vim color file
" Maintainer:  Jeremy Attali
" Last Change: 2012 Dec 25
" Version:     0.2.0
" Credits:     Damien Gombault <desintegr@gmail.com>

set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "monokai"

hi Normal       guifg=#F8F8F2 guibg=#272822 ctermfg=231 ctermbg=235


" Main highlight groups
hi Cursor       guibg=fg ctermfg=235 ctermbg=231 cterm=none
"hi CursorIM
hi CursorLine   guibg=#3E3D32 gui=none ctermfg=none ctermbg=237 cterm=none
hi ColorColumn  guibg=#3E3D32 gui=none ctermfg=none ctermbg=237 cterm=none
hi Directory    guifg=#66D9EF gui=none ctermfg=141 ctermbg=none cterm=none
hi DiffAdd      guifg=bg guibg=#A6E22E ctermfg=231 ctermbg=64 cterm=bold
hi DiffChange   guifg=bg guibg=#E6DB74 ctermfg=231 ctermbg=23 cterm=none
hi DiffDelete   guifg=bg guibg=#F92672 ctermfg=88 ctermbg=none cterm=none
hi DiffText     guifg=bg guibg=#E6DB74 ctermfg=231 ctermbg=24 cterm=bold
hi ErrorMsg     guifg=#F92672 guibg=bg gui=none ctermfg=231 ctermbg=197 cterm=none
hi VertSplit    guifg=#3B3A32 guibg=bg gui=none ctermfg=241 ctermbg=241 cterm=none
hi Folded       guifg=#75715E guibg=bg gui=none ctermfg=242 ctermbg=235 cterm=none
hi FoldColumn   guifg=#75715E guibg=#3E3D32 gui=none ctermfg=231 ctermbg=241 cterm=none
hi SignColum    guifg=#75715E guibg=#3E3D32 gui=none ctermfg=231 ctermbg=241 cterm=none
hi IncSearch    guifg=bg guibg=#FD971F gui=none ctermfg=bg ctermbg=208 cterm=none
hi LineNr       guifg=#75715E guibg=#3E3D32 gui=none ctermfg=102 ctermbg=237 cterm=none
hi MatchParen   guifg=fg guibg=bg gui=bold ctermfg=fg ctermbg=none cterm=bold
hi ModeMsg      gui=none cterm=none
hi MoreMsg      guifg=#66D9EF gui=none ctermfg=81 cterm=none
hi NonText      guifg=#3B3A32 gui=none ctermfg=241 cterm=none
hi Pmenu        guifg=fg guibg=#3E3D32 ctermfg=fg ctermbg=241
hi PmenuSel     guifg=bg guibg=#E6DB74 ctermfg=bg ctermbg=186
hi PmenuSbar    guibg=bg ctermbg=bg
hi PmenuThumb   guifg=fg ctermfg=fg
hi Question     guifg=#A6E22E gui=none ctermfg=148
hi Search       guifg=bg guibg=#FFE792 gui=none ctermfg=bg ctermbg=186 cterm=none
hi SpecialKey   guifg=#3B3A32 gui=none ctermfg=241 cterm=none
hi SpellBad     guisp=#F92672
hi SpellCap     guisp=#65D9EF
"hi SpellLocal
hi SpellRare    guisp=#AE81FF
hi StatusLine   guifg=fg guibg=#3E3D32 gui=none ctermfg=231 ctermbg=241 cterm=bold
hi StatusLineNC guifg=#75715E guibg=#3E3D32 gui=none ctermfg=231 ctermbg=241 cterm=none
hi TabLine      guifg=#75715E guibg=#3E3D32 gui=none ctermfg=8 ctermbg=9 cterm=none
hi TabLineFill  guifg=fg guibg=#3E3D32 gui=none ctermfg=fg ctermbg=9 cterm=none
hi TabLineSel   guifg=fg guibg=#3E3D32 gui=none ctermfg=fg ctermbg=9 cterm=none
hi Title        guifg=#F92672 gui=none ctermfg=197 cterm=none
hi Visual       guibg=#383830 gui=none ctermbg=237 cterm=none
"hi VisualNOS
hi WarningMsg   guifg=#F92672 gui=none ctermfg=1 cterm=none
"hi WildMenu

"hi Menu
"hi ScrollBar
"hi Tooltip

" Plugin specific highlight groups
hi MyTagListFileName guifg=#FD971F guibg=bg gui=none ctermfg=11 ctermbg=bg cterm=none

" Color groups
hi Blue    guifg=#66D9EF gui=none ctermfg=81  ctermbg=none cterm=none
hi Green   guifg=#A6E22E gui=none ctermfg=148 ctermbg=none cterm=none
hi Grey    guifg=#75715E gui=none ctermfg=242 ctermbg=none cterm=none
hi Orange  guifg=#FD971F gui=none ctermfg=208 ctermbg=none cterm=none
hi Purple  guifg=#AE81FF gui=none ctermfg=141 ctermbg=none cterm=none
hi Red     guifg=#F92672 gui=none ctermfg=197 ctermbg=none cterm=none
hi White   guifg=#F8F8F2 gui=none ctermfg=231 ctermbg=none cterm=none
hi Yellow  guifg=#E6DB74 gui=none ctermfg=186 ctermbg=none cterm=none

hi BlueU   guifg=#66D9EF gui=underline ctermfg=6 cterm=underline

hi RedR    guifg=fg guibg=#F92672 gui=none ctermfg=fg ctermbg=192 cterm=none
hi YellowR guifg=bg guibg=#FD971F gui=none ctermfg=fg ctermbg=208 cterm=none


" Syntax highlight groups
hi! link Character    Yellow
hi! link Comment      Grey
hi! link Constant     Purple
hi! link Float        Purple
hi! link String       Yellow
hi! link Number       Purple
hi! link Boolean      Purple
hi! link Identifier   Green
hi! link Function     Green
"
hi! link Statement    Red
"hi Conditional ctermfg=197 ctermbg=none cterm=none
"hi Repeat
"hi Label
hi! link Operator     Green
"hi Keyword
"hi Exception
"
hi! link PreProc      Orange
"hi Include
"hi Define ctermfg=197 ctermbg=none cterm=none
"hi Macro
"hi PreCondit
"
hi! link Type         Blue
hi! link StorageClass Red
"hi Structure
"hi Typedef
"
hi! link Special      White
"hi SpecialChar
hi! link Tag          Green
hi! link Delimiter    Red
"hi SpecialComment
"hi Debug
"
hi! link Underlined   BlueU
"hi Ignore
hi! link Error        RedR
hi! link Todo         YellowR

" Language specific highlight groups
" C
hi link cStatement              Green
" C++
hi link cppStatement            Green
" CSS
hi link cssBraces               White
hi link cssFontProp             White
hi link cssColorProp            White
hi link cssTextProp             White
hi link cssBoxProp              White
hi link cssRenderProp           White
hi link cssAuralProp            White
hi link cssRenderProp           White
hi link cssGeneratedContentProp White
hi link cssPagingProp           White
hi link cssTableProp            White
hi link cssUIProp               White
hi link cssFontDescriptorProp   White
" Java
hi link javaStatement           Green
" Ruby
hi link rubyClassVariable       White
hi link rubyControl             Green
hi link rubyGlobalVariable      White
hi link rubyInstanceVariable    White
hi link rubyDefine              Red
hi link rubyRailsFilterMethod   Blue
hi link rubyRailsRenderMethod   Blue
" HTML
hi link htmlTag         Comment
hi link htmlTagName     Conditional
hi link htmlEndTag      Comment
hi link htmlLink        Normal
hi link htmlArg         Green
" CSS/SASS
hi link cssTagName                  Yellow
hi link sassVariable                Green
hi link sassFunction                Red
hi link sassMixing                  Red
hi link sassMixin                   Red
hi link sassExtend                  Red
hi link sassFor                     Red
hi link sassInterpolationDelimiter  Magenta
hi link sassAmpersand               Character
hi link sassId                      Identifier
hi link sassClass                   Type
hi link sassIdChar                  sassId
hi link sassClassChar               sassClass
