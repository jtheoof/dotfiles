"=============================================================================
"    Copyright: Copyright (C) 2003-2006 Peter Franz
"               Permission is hereby granted to use and distribute this code,
"               with or without modifications, provided that this copyright
"               notice is copied with it. Like anything else that's free,
"               hexman.vim is provided *as is* and comes with no
"               warranty of any kind, either expressed or implied. In no
"               event will the copyright holder be liable for any damamges
"               resulting from the use of this software.
" Name Of File: hexman.vim
"  Description: HexManger: Simpler Hex viewing and editing - Vim Plugin
"
"		Hexmanger provides keymapping to view quickly your file
"		in hexmode (convertion is done over the program xxd).
"		(more info - see Additional Features in HexManger).
"
"   Maintainer: Peter Franz (Peter.Franz.muc@freenet.de)
"          URL: http://www.vim.org/scripts/script.php?script_id=666
"  LastChange : 18Jan07
"      Version: 0.7.2
"        Usage: Normally, this file should reside in the plugins
"               directory and be automatically sourced. If not, you must
"               manually source this file using ':source hexman.vim'.
"
"               If you want to edit a file in hexmode, start vim 
"               with the -b option - like:
"                     vim -b <file>
"               and then switch to hexmode with <leader>hm
"               (see Available functions).
"               The program xxd is needed to convert the file in hex (and
"               back).
"		
"               Changes in the printable text part are now supported in
"		Replace mode (command "R" or Select Mode "gh" ) 
"		for most characters (as of version 0.5.0).
"               
"               Additional help:
"               :help *23.4* 
"               :help xxd                                                    
"
"      Vim Features:  As this plugin relies on the vim features:
"		autocmd, langmap and byte_offset, make sure Vim is built with
"		this features (info with :version cammand).
"	
"      Vim Version:   6.2 onward
"
"      History: 0.7.2 Patch from Ingo Karkat / 'xxd' did not
"      		      start when VIM is installed in a directory containing 
"      		      spaces (e.g. on an English Windows XP: 
"      		      "c:\Program Files\vim\vim70\xxd.exe").
"               0.7.1 Patch from Alejandro Cornejo / language independent
"      		      cursor offset calculation.
"               0.7.0 Support VIM7
"      		      In vim7.0c xxd was not found / changed match syntax.
"               0.6.0 Search Hex Char with \hf  
"                     With search history eg. /<Up> you can repeat the search.
"                     Possibility to switch off advanced ascii/hex editing
"		      (see Additional Features).
"		0.5.3 While Hex editing, move cursor to next hex block.
"		0.5.2 FIX: error message E197 on unix systems .
"		0.5.1 FIX: Editing in Hex part was not possible (as of 0.5.0).
"		0.5.0 Changing characters in ascii area shows the releated
"		      hex values. Note: not all ascii characters are supported!
"		      (see Known Problems).
"		0.4.1 FIX: use english Message.
"		0.4.0 Switch cursor between hex and ascii area.
"		      (see Additional Features).
"		0.3.0 After calling/leaving hexman the cursor is set to current
"  		      file position.
"		0.2.1 FIX: from Ingo karkat - conversion back fails 
"                     (xxd-path was not enclosed in double quotes).
"		0.2.0 Staying on a ascii character it marks the 
"		      related hex column.
"		0.1.1 FIX: hit enter message after moving cursor.
" 		0.1.0 Show own hexman menu entry with hexman commands 
"                     (gui version).
"		0.0.2 FIX: default moving to next hex character 
"		      with <TAB> and <S-TAB> don't work on (LINUX/UNIX)
"		      (see Additional Features).
"               0.0.1 Initial Release
"               Some Functions are derived from Robert Roberts
"               byteme.vim version 0.0.2
"               The original plugin can be found at:
"               http://www.vim.org/scripts/script.php?script_id=268
"               Thank you very much! 
"
"=============================================================================
"
"	Available functions:
"
"	<leader> hm	HexManager: Call/Leave Hexmode (using xxd)
"	<leader> hd  	HexDelete: delete hex character under cursor
"	<leader> hi  	HexInsert: Insert Ascii character before cursor
"	<leader> hg  	HexGoto: Goto hex offset. 
"	<leader> hn  	HexNext: Goto next hex offset. 
"	<leader> hp  	HexPrev: Goto previous hex offset. 
"	<leader> ht  	HexToggle: Switch cursor between hex and ascii area.
"	<leader> hs  	HexStatus: Show / Hide hexoffset infos in statusline
"			and related ascii colum.
"	<leader> hf  	HexFind: Find Hex Character
"
" 	If you want, you can change the mapping in your vimrc:
"	Example: call/leave with function key F6 the Hexmode:
"	map <F6>  <Plug>HexManager                                           
"
"	Additional Features in HexManger:
"	- Find Hex Character (see Available functions).
"       - Changes in the printable text part are now supported in
"	  Replace mode (command "R" or Select Mode "gh" ). 
"	  In hex part cursor moves automatically to next hex block.
" 	  If you don't like or have problems with it - please
"	  set in your vimrc: let hex_mapchars = 0 
"	  (see also Known Problems).
"	- show in statusline the current offset (hex and dec.)
"	- staying on a hex character it marks the related ascii column
"	- move to next/previous hex character with <TAB> and <S-TAB>
"         If you don't like this mapping - please set in your vimrc:
"	  let hex_movetab = 0
"	- Switch cursor between hex and ascii area 
"	  (as of version 0.4.0)
"	- staying on a hex character it marks the related ascii column
"	- staying on a ascii character it marks the related hex column
"	  (as of version 0.2.0)
"	- Goto hex offset	
"	- Delete hex character under cursor	
"	- Insert ascii character before cursor	                      
"	- Show own hexman menu entry with hexman commands (gui version).
"         If you don't like the menu - please set in your vimrc:
"	  let hex_menu = 0 (as of version 0.1.0)

"
"	If something is wrong (I think there is) or we can do 
"	something better - please let me know...
"
"=============================================================================
"	Known Problems:
"       - Changes in the printable text part are now supported in
"	  Replace mode (command "R" or Select Mode "gh" ) 
"	  for most characters.
"	  For this feature I'll try to map all ascii characters, echo the
"	  typed character and call a function wich show in the hexpart the
"	  related hex value. For this I have to leave the Replace mode.
"	  I don't know if it is possible to enter the Replace mode again -
"	  we need a function like startreplace - so I switch to Select mode. 
"         In this mode I'm not able to map some keys - like: + - ?
"	Appreciate any help!
"=============================================================================
"
" 	Define mapping:
"
if !hasmapto('<Plug>HexManager')
  map <unique> <Leader>hm <Plug>HexManager
endif
if !hasmapto('<Plug>HexDelete')
  map <unique> <Leader>hd <Plug>HexDelete
endif
if !hasmapto('<Plug>HexInsert')
  map <unique> <Leader>hi <Plug>HexInsert
endif
if !hasmapto('<Plug>HexGoto')
  map <unique> <Leader>hg <Plug>HexGoto
endif
if !hasmapto('<Plug>HexNext')
  map <unique> <Leader>hn <Plug>HexNext
endif
if !hasmapto('<Plug>HexPrev')
  map <unique> <Leader>hp <Plug>HexPrev
endif
if !hasmapto('<Plug>HexToggle')
  map <unique> <Leader>ht <Plug>HexToggle
endif
if !hasmapto('<Plug>HexStatus')
  map <unique> <Leader>hs <Plug>HexStatus
endif
if !hasmapto('<Plug>HexFind')
  map <unique> <Leader>hf <Plug>HexFind
endif

noremap <unique> <script> <Plug>HexManager <SID>Manager
noremap <unique> <script> <Plug>HexDelete  <SID>Delete
noremap <unique> <script> <Plug>HexInsert  <SID>Insert
noremap <unique> <script> <Plug>HexGoto    <SID>Goto
noremap <unique> <script> <Plug>HexNext    <SID>Next
noremap <unique> <script> <Plug>HexPrev    <SID>Prev
noremap <unique> <script> <Plug>HexToggle  <SID>Toggle
noremap <unique> <script> <Plug>HexStatus  <SID>Status
noremap <unique> <script> <Plug>HexFind    <SID>Find

noremap <SID>Manager   :call <SID>HEX_Manager()<CR>
noremap <SID>Delete    :call <SID>HEX_Delete()<CR>
noremap <SID>Insert    :call <SID>HEX_Insert()<CR>
noremap <SID>Goto      :call <SID>HEX_Goto()<CR>
noremap <SID>Next      :call <SID>HEX_NextPrev(+1)<CR>
noremap <SID>Prev      :call <SID>HEX_NextPrev(-1)<CR>
noremap <SID>Toggle    :call <SID>HEX_ToggleH2A()<CR>
noremap <SID>Status    :call <SID>HEX_Status()<CR>
noremap <SID>Find      :call <SID>HEX_Find()<CR>


"=============================================================================
" We first store the old value of 'cpoptions' in the s:save_cpo variable.  At
" the end of the plugin this value is restored.
let s:save_cpo = &cpo
set cpo&vim
" Not loading
if exists("loaded_hexman")
   finish
endif
let loaded_hexman = 1
"
"=============================================================================
" 30JUL03 FR Add menue
"=============================================================================
  if !exists("g:hex_menu")
    let g:hex_menu = 1	" Default
  endif
  if (g:hex_menu == 1 && has("gui_running"))
	an <silent> 9000.10 He&xman.&Convert\ to\ HEX\ (and\ back)<TAB><leader>hm
		\ :call <SID>HEX_Manager()<CR>
	an 9000.20 He&xman.-sep1-			<Nop>
	an <silent> 9000.30 He&xman.&Delete\ hex\ char\ under\ cursor<Tab><leader>hd
		\ :call <SID>HEX_Delete()<CR>
	an <silent> 9000.40 He&xman.&Insert\ ascii\ char\ before\ cursor<Tab><leader>hi
		\ :call <SID>HEX_Insert()<CR>
	an 9000.70 He&xman.-sep2-			<Nop>
	an <silent> 9000.80 He&xman.&Find\ /Hex\ char<Tab><leader>hf
		\ :call <SID>HEX_Find()<CR>
	an <silent> 9000.90 He&xman.&Goto\ /Hex\ offset<Tab><leader>hg
		\ :call <SID>HEX_Goto()<CR>
	an <silent> 9000.90 He&xman.&Show/Hide\ infos<Tab><leader>hs
		\ :call <SID>HEX_Status()<CR>
   endif
"
"=============================================================================
" Toggle between Hexmode and Normalmode
"=============================================================================
"
function s:HEX_Manager()
"
  if g:HEX_active == 1
    " 10OCT04 FR Unmapping
    :call s:HEX_UnMapChars()
    "
    let curcol  = col(".")
    if curcol > 50
	" cursor is in ascii part - we put it in hex part 
	call s:HEX_ToggleH2A()
    endif
    " get cursor position from hex, convert file to normal and put cursor 
    " get cursor position
    let offset = s:HEX_GetOffset()
    call s:HEX_ToOffset(offset)
    let offset = s:HEX_GetOffset()
    let gopos = offset + 1	" command go is the first character 1 (not 0)
    " convert file to normal mode
    :silent call s:HEX_XxdBack()
    " move cursor to file position
    exe gopos"go"
    " clear offset infos
    echo ""			
  else
    " Problem:
    " vim don't support the current cursor position via a function
    " only (known) posibility is to get it with g<c-g>
    " We put this string in a variable and pick the number after Byte
    " but this is language dependend - so we switch temporarily to "EN",
    " if langmap is supported - if not we try without.
    " here we go
    "
    " get current language
    " use of register h - hopefully not used
"    if has("langmap")
"    	redir @h
"    	:silent exe ":lan mes"
"    	:redir END
"    	let sLanS = @h
"    	let nC = strlen(sLanS) - 1			" get string length
"	" 05NOV03 search for quoted String (not only two characters)
"	" first search for quote - get pos
"	let nPosl = stridx(sLanS, "\"")
"	let nStart = nPosl + 1			" one character after quote
"	let nLen = nC - nPosl - 1		" Stringlen-Startpos-quote
"    	let sMes = strpart(sLanS, nStart, nLen)	" get lan mes
"    	" let sMes = strpart(sLanS, nC-2, 2)	" two char for mes
"    	" messages in english
"	if has("unix")
"    		:silent exe ":lan mes en_US.UTF-8"
"	else
"    		:silent exe ":lan mes en"
"	endif
"    endif
"    " use of register h - hopefully not used
"    redir @h
"    " put message in register H
"    :silent exe "normal g\<c-g>"
"    :redir END
"    if has("langmap")
"    	" back to original message language
"    	:silent exe ":lan mes " . sMes
"    endif
"    let sH = @h		" put string from register H in variable sH
"    let sPos = s:HEX_CutG(sH) - 1	" subtract one
"    Alejandro Cornejo: OK so I got an error about the lan mes thing, I think
"    its because although I'm at unix using VIM 7, if you use console vim it is
"    en_US, and if you use gvim it is en_US.UTF-8.
"
"    So anyway, here is a patch to fix this, I think this should be a
"    quicker/cleaner way of getting the line offset instead of capturing the
"    result of a g<c-g> command. Also it is language independent. Let me know if
"    it works for you too.
    let sPos = line2byte(line("."))+col(".")-2
    " convert over xxd
    :silent call s:HEX_XxdConv()
    " move to calculated position
    call s:HEX_ToOffset(sPos)
    " 10OCT04 FR Keymapping
    :silent call s:HEX_MapChars()
  endif
endfun
"
" ============================================================================
" Author      : Robert Roberts (res02ot0@gte.net) 
" Dervied from: byteme.vim (VIM plugin)
" Get actual cursor position,  get new hex offset from user and move cursor to 
" new hex position.
" ============================================================================
"
function s:HEX_Goto()
"
  " if not in hexmode echo errmsg and return
  if g:HEX_active == 0
    call s:HEX_ErrMsg()
    return
  endif
  " where is the cursor now - get offset
  let offset = s:HEX_GetOffset()
  "
  let hexoffset = s:HEX_Nr2Hex(offset)
  " Get the new hex offset (the goto) from the user.
  let hexgoto = toupper(input("Enter New Hex Offset (" . toupper(hexoffset) . "): "))
  " If nothing is entered stay (move) to current position
  if hexgoto == ""
    let hexgoto = hexoffset
  endif
  " Convert the hex string to an integer.
  let intgoto=s:HEX_Hex2Nr(hexgoto)

  call s:HEX_ToOffset(intgoto)
  " echo " hexfrom: [" . toupper(hexoffset) . "]" . " intfrom: [" . offset ."] hexto: [" . hexgoto ."] intto: [" . intgoto ."]"
  return ""
endfun 
"
" =============================================================================
" Converts Hex to Number
" =============================================================================
"
function s:HEX_Hex2Nr(hx)
"
" Author      : Robert Roberts (res02ot0@gte.net) 
" Dervied from: byteme.vim (VIM plugin)
" Author Note : This actually works!  I amaze myself.  ...but to explain it...
  " Grab the passed in hex string.
  let h = a:hx
  " Initialize the result to zero.
  let nr = 0
  " Initialize the outside loop counter.
  let loopcntr=0
  " Grab the length of the hex string.
  let cntr = strlen(h)
  " Start the outside loop.
  while cntr > 0
    " Initialize the power base variable.
    let pwrbase=1
    " Initialize the power counter. The -1 was added after I found the
    " results to always be one power too high.
    let pwrcntr=cntr-1
    " Create my own pow() functionality (e.g. 16^x).
    while pwrcntr > 0
      " This will do powers of 16 only.
      let pwrbase=pwrbase*16
      " Decrement the power counter. E.g. for a HEX string with a length of
      " 4, this will do a 1*16*16*16
      let pwrcntr=pwrcntr-1
    endwhile
    " Start grabbing the chars off the left and work right.
    let xchr = strpart(h,loopcntr,1)
    " Find the char in the haystack and return its position which will equal
    " its single char value.
    let ichr = stridx("0123456789ABCDEF",xchr)
    " Multiply that single char value against the powerbase and add it to the total.
    let nr = nr + (ichr*pwrbase)
    " Tweak the counters.
    let cntr=cntr-1
    let loopcntr=loopcntr+1
  endwhile
  " return the interger value.
  return nr
endfunc
"
" =================================================================================================
" Found this function in the standard VIM :help documentation using :h eval-examples
" The function returns the Hex string of a number.
" =================================================================================================
"
function s:HEX_Nr2Hex(nr)
"
  let n = a:nr
  let r = ""
  while n
    let r = '0123456789ABCDEF'[n % 16] . r
    let n = n / 16
  endwhile
  " For display asthetics only.  When sitting at the very first char in the file,
  " the camefrom hex will be "" which naturally displays as nothing.
  if r == ""
    let r = "00"
  endif
  return r
endfunc
"
"=============================================================================
let g:HEX_active=0	" initialize - set hex mode off
"=============================================================================
" Found the xxd functions in menu.vim
" Use a function to do the conversion, so that it also works 
" with 'insertmode' set.
"=============================================================================
"
function s:HEX_XxdConv()
"
  " get cursor position
  " let g:cc = line2byte(line("."))
  " let g:cc = g:cc - 1	" hex view starts with zero
  " let offset = s:HEX_Nr2Hex(g:cc)	" convert decimal to hex
  " get position works not correct this way
  "
  "
  let mod = &mod
  if has("vms")
    %!mc vim:xxd
  else
    call s:HEX_XxdFind()
    exe '%!"' . g:xxdprogram . '"' 
  endif
  if getline(1) =~ "^0000000:"		" only if it worked
    set ft=xxd
  else
    return				" can't start xxd
  endif
  "
  " Nice mapping for TAB/Shift-TAB
  " Move from hex to hex field - with TAB / Shift-TAB
  " map <silent> <TAB> :call <SID>HEX_NextPrev(+1)<CR>
  " map <silent> <S-TAB> :call <SID>HEX_NextPrev(-1)<CR>
  " Map key variable to invoke the command
  " 14Jun03 If hex_movetab is not defines - default = 1
  if !exists("g:hex_movetab")
    let g:hex_movetab = 1	" Default
  endif
  if g:hex_movetab == 1
    let s:hex_tab = mapcheck("<TAB>")	" save mapping for TAB
    let s:hex_stab = mapcheck("<S-TAB>")	" save mapping for Shift-TAB
    
    " let g:hex_stab = 0
    map <silent> <TAB> :silent call <SID>HEX_NextPrev(+1)<CR>
    map <silent> <S-TAB> :silent call <SID>HEX_NextPrev(-1)<CR>
    nmap <silent> t :silent call <SID>HEX_ToggleH2A()<CR>
    map <silent> ? :call <SID>HEX_Help()<CR>
  endif
  "
  " Show additional info in statusline (overwrite)
  " Maybe there is a better way to set this with rulerformat but
  " I don't know how I can do this... 
  let &mod = mod
  " :highlight AsciiPos guibg=Yellow cterm=reverse term=reverse
  " :au! Cursorhold * exe 'silent! match AsciiPos /\%' . s:HEX_ShowOffsets() . 'v'
  " :set ut=100 
  "
  " remember we are in hex mode
  let g:HEX_active=1
  " put cursor to related position
  " call s:HEX_ToOffset(offset)
  call s:HEX_Status()
  "
endfun
"
" ==============================================================================
" The function HexOff passes the file over xxd to view it in normal mode
" ==============================================================================
"
function s:HEX_XxdBack()
"
  let mod = &mod
  if has("vms")
    %!mc vim:xxd -r
  else
    call s:HEX_XxdFind()
    " exe "%!" . g:xxdprogram . " -r"
    " 07Aug03 Fix
    exe '%!"' . g:xxdprogram . '" -r'
  endif
  set ft=
  doautocmd filetypedetect BufReadPost
  let &mod = mod
  let g:HEX_active=0			" no hex mode
  if g:hex_movetab == 1
    " restore mapping
    exe "map <silent> <TAB> " . s:hex_tab
    exe "map <silent> <S-TAB> " . s:hex_stab
    exe "unmap <silent> t"
    exe "unmap <silent> ?"
  endif
  " switch off Ascii pos highlighting
  :au! Cursorhold
  :match none
  " switch back
  if g:hex_showstatus == 1
	let g:hex_showstatus = 2	" if we call hexman again
  endif
endfun
"
" ==============================================================================
" Find the convert utility xxd
" ==============================================================================
"
function s:HEX_XxdFind()
"
  if !exists("g:xxdprogram")
    " On the PC xxd may not be in the path but in the install directory
"    if (has("win32") || has("dos32")) && !executable("xxd")
"      let g:xxdprogram = $VIMRUNTIME . (&shellslash ? '/' : '\') . "xxd.exe"
"    else
"      let g:xxdprogram = "xxd"
"    endif
"    in vim 7.0c xxd is not found anymore - use code from _vimrc (diff)
"
   let g:xxdprogram = "xxd"
   if (has("win32") || has("dos32")) 
     if $VIMRUNTIME =~ ' '
       if &sh =~ '\<cmd'
"	 18Jan07 fix from Ingo karkat
"
         let cmd = '"' . $VIMRUNTIME . '\xxd"'
         let eq = '"'
       else
         let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\xxd"'
       endif
     else
       let cmd = $VIMRUNTIME . '\xxd'
     endif
     let g:xxdprogram = cmd
   endif
  endif
endfun
"
" ==============================================================================
" Funtion to delete current hex character
" ==============================================================================
"
function s:HEX_Delete()
"
  if g:HEX_active == 0
    call s:HEX_ErrMsg()
  else
    " Start procedure...
    " Get Offset Set and s:HEX_GetOffset again to make shure we are on the first 
    " (left) hex character
    let offset = s:HEX_GetOffset()
    call s:HEX_ToOffset(offset)
    let offset = s:HEX_GetOffset()
    let gopos = offset + 1	" command go is the first character 1 (not 0)
    " the character we have to delete must be printable 
    " (e.g. with <LF> it is not the case- we set it to 'a'
    " 
    :norm! ra
    " go to normal Mode
    :silent call s:HEX_XxdBack()
    " goto file position
    exe gopos"go"
    " delete character
    :norm! x
    " go to xxd mode
    :silent call s:HEX_XxdConv()
    " cursor back where it belong
    call s:HEX_ToOffset(offset)
  endif
endfun
"
" ==============================================================================
" Funtion to Insert a character before cursor
" ==============================================================================
"
function s:HEX_Insert()
"
  if g:HEX_active == 0
    call s:HEX_ErrMsg()
    return
  endif
  
  " Get the new hex offset (the goto) from the user.
  let insval = input("Enter New Ascii Character: ")
  " If nothing is entered do nothing
  if insval == ""
     return
  endif
  " Start procedure...
  " Get Offset Set and s:HEX_GetOffset again to make shure we are on the first 
  " (left) hex character
  let offset = s:HEX_GetOffset()
  call s:HEX_ToOffset(offset)
  let offset = s:HEX_GetOffset()
  let gopos = offset + 1	" command go is the first character 1 (not 0)
  " go to normal Mode
  call s:HEX_XxdBack()
  " goto file position
  exe gopos"go"
  " insert character
  exe ":norm! i" . insval
  " go to xxd mode
  :silent call s:HEX_XxdConv()
  " cursor back where it belong
  call s:HEX_ToOffset(offset)
endfun
"
" ==============================================================================
" Move to Offset position in Hex View
" ==============================================================================
"
function s:HEX_ToOffset(goto)
"
  " declare funtion local
  let intgoto = a:goto
  " Calculate the line number of the new offset.
  let newline = intgoto / 16 + 1
  " Calculate the column number within that new line. I could do it in one line,
  " but this is less obfuscated.
  let newcol = intgoto % 16
  let newcol = newcol * 5 / 2
  let newcol = newcol + 10
  " Go to that new line.
  exec ":" . newline
  " Go to that new column.
  exec "norm " . newcol . "|"
  return ""
endfun
"
" ==============================================================================
" Get Offset offen Current Position in Hex Mode
" ==============================================================================
"
function s:HEX_GetOffset()
"
" Get the current line number but -1 to use base 0 to make the *16 work right.
  let curline = line(".") - 1
  " Get the current column number.
  let curcol  = col(".")
  " If the curcol is greater than 48...
  if curcol > 47
      " Make it 47.  We don't care about the text to the right of the hex.
      let curcol = 47
  endif
  " Subtract 10 from the curcol.  We don't care about the line numbers on the left.
  let curcol = curcol - 11
  " Adjust for when the cursor was sitting off in the line numbers.
  if curcol < 0
    let curcol = 0
  endif
  " Initiaze this.  It will be set to 1 later on if we are sitting on the second byte of a word.
  let midwrd = 0
  " If column is greater than 0, we are sitting the actual hex code area (like we want).
  if curcol > 0
    " This colmod and midwrd stuff is just for calculating the camefrom hex when we
    " are mid hexword.
    let colmod = curcol % 5
    " If colmod is not 0, we are midword.
    if colmod > 0
      " Will add 1 to get midword hex char.
      let midwrd = 1
    endif
    " Divide the column by 5 and then multiply by two and it will give you the
    " proper integer column number for the first byte in each 2 byte group.
    let curcol = curcol * 2 / 5
  endif
  " There are 16 bytes in each line plus the current column calculation.
  let offset = (curline * 16) + curcol
  " Add the midword adjustment for being in the middle of a hexword if needed.
  let offset = offset + midwrd
  "if offset < 0
  "  let offset = 0
  "endif
  " Convert the integer offset to Hex.
  return offset
endfun
" 
" =======================================================================================
" Std. message if a fuction is called if we are not in hexmode 
" =======================================================================================
" 
function s:HEX_ErrMsg()
    " one day there comes a better error message ;-)
    echo "Sorry - not in Hexmode!!!"
endfun
"
" =======================================================================================
" Move to Next/Previous Hex field
" =======================================================================================
"
function s:HEX_NextPrev(n)
"
  let goto = a:n
  " Add/Subtract from current offset
  :silent let offset = s:HEX_GetOffset() + goto
  " Move cursor to new offset
  :silent call s:HEX_ToOffset(offset)
"
endfun
" =======================================================================================
" Toggle Hex <-> Ascii area
" =======================================================================================
"
function s:HEX_ToggleH2A()
"
  " Get colpos from other area
  :silent let newcol = s:HEX_ShowOffsets()
  let newcol = newcol
  " Move cursor to newcol
  " cursor to col 0
  :silent exe "normal 0"
  " move cursor to colpos
  exec "norm " . newcol . "|"
"
endfun

" =======================================================================================
" Find Byte-Pos from String (get via g<c-g> )
" =======================================================================================
"
function s:HEX_CutG(s)
"
  let sG = a:s
  let nC = strlen(sG)			" get string length
  let nP = match(sG, "Byte", 0)		" position of byte
  let sP = strpart(sG, nP+5)		" get string part like: 1333 of 5000
  
  let nP = match(sP, " ", 0)		" Blank after 1333
  let sB = strpart(sP, 0, nP)		" Get string till blank
  return(sB)
"
endfun

" =======================================================================================
function s:HEX_ShowOffsets()
" =======================================================================================
" Calculate from hex offset the corresponding ascii offset and shows the result
"
  " Get the current column number.
  let curcol  = col(".")
  "
  if curcol > 50
	" cursor is in ascii part
	let newcol = 7
	let colpos = 51
	let coladd = 3
  	while colpos <= curcol
      		let colpos = colpos + 1
      		let newcol = newcol + coladd
      		if coladd > 2
			let coladd = 2
      		else
			let coladd = 3
      		endif
  	endwhile
  else
	" cursor is in  hex part
  	" init newcol first ascii position is 51
  	" calculate related ascii position (right part from xxd)
   	let newcol = 51
  	" first hex part valid till position 12
  	let colpos = 12
  	" Add 3 than 2 than 3 than 2 and so on
  	let coladd = 3
  	while colpos <= curcol
      		let colpos = colpos + coladd
      		let newcol = newcol + 1
      		if coladd > 2
			let coladd = 2
      		else
			let coladd = 3
      		endif
  	endwhile
  endif
  " Show offsets
  let s:offset = s:HEX_GetOffset()         	" Next/Prev Hex Position
  let s:hexoff = s:HEX_Nr2Hex(s:offset)	 	" Calculate Number To Hex
  " calculate and show offsets and optional help
  " set help off for default

  " call s:HEX_Help(hexoff, offset)
  echo "Offset Hex:[" . s:hexoff ."] Dec:[" . s:offset ."]  Press ? for help"
  return newcol
"
endfun
"
" =======================================================================================
" Show / Stop Overwriting Statusline with Offset-Info
" =======================================================================================
function s:HEX_Status()
  " leave if not in hexmode
  if g:HEX_active == 0
    call s:HEX_ErrMsg()
    return
  endif
  "
  if !exists("g:hex_showstatus")
    let g:hex_showstatus = 2	" init - no hex statusinfo -> switch it on
  endif
  "  if status 0 never show status - (set in vimrc)
  if g:hex_showstatus == 0
	return
  endif
  "
  if g:hex_showstatus == 1
    " switch off
    :au! Cursorhold
    :match none
    let g:hex_showstatus = 2
  else
    " switch on 
    :highlight AsciiPos guibg=Yellow cterm=reverse term=reverse
    let s:sff = s:HEX_ShowOffsets()
    let s:fff = s:sff + 1

    " 29Mrz06 FR vim 7.0c don't accept /\%<colpos>v
    :au! Cursorhold * exe 'match AsciiPos /\%<' . (s:HEX_ShowOffsets() + 1) . 'v.\%>' . s:HEX_ShowOffsets() . 'v/'
    :set ut=100 
    let g:hex_showstatus = 1
  endif
endfun
"
" =======================================================================================
" Map for (most) characters 
" =======================================================================================
function s:HEX_MapChars()
  " Map it only if wanted
  if !exists("g:hex_mapchars")
    let g:hex_mapchars = 1	" Default
  endif
  if g:hex_mapchars == 0
	return
  endif
  " characters I can't  get in a loop
  execute "inoremap <Space> <Space><ESC>:call <SID>HEX_Char()<CR>"
  execute "inoremap <Bar> <Bar><ESC>:call <SID>HEX_Char()<CR>"
  execute "inoremap \/ \/<ESC>:call <SID>HEX_Char()<CR>"
  execute "inoremap \" \"<ESC>:call <SID>HEX_Char()<CR>"
  execute "inoremap \! \!<ESC>:call <SID>HEX_Char()<CR>"
  execute "inoremap \§ \§<ESC>:call <SID>HEX_Char()<CR>"
  execute "inoremap \~ \~<ESC>:call <SID>HEX_Char()<CR>"
  
  "
  " loop from 0 till z
  let letter = "0"
  while letter <= "z"
    execute "inoremap" letter letter . "<ESC>:call <SID>HEX_Char()<CR>"
    let letter = nr2char(char2nr(letter) + 1)
  endwhile
  "
  " loop from # till .
  let letter = "#"
  while letter <= "."
    execute "inoremap" letter letter . "<ESC>:call <SID>HEX_Char()<CR>"
    let letter = nr2char(char2nr(letter) + 1)
  endwhile
endfun
"
" =======================================================================================
" UnMap characters
" =======================================================================================
function s:HEX_UnMapChars()
  "
  if g:hex_mapchars == 0
	return
  endif
  " unmap from 0 to z
  let letter = char2nr("0")
  while letter <= char2nr("z")
    execute "iunmap" nr2char(letter)
    let letter = letter + 1
  endwhile
"
  " unmap from # to .
  let letter = char2nr("#")
  while letter <= char2nr(".")
    execute "iunmap" nr2char(letter)
    let letter = letter + 1
  endwhile
  "
  execute "iunmap <Space>"
  execute "iunmap <Bar>"
  execute "iunmap \/"
  execute "iunmap \""
  execute "iunmap \!"
  execute "iunmap \§"
  execute "iunmap \~"
endfun
" 
" =======================================================================================
" Show Character
" =======================================================================================
function s:HEX_Char()
  " Get the current column number.
  let curcol  = col(".")
  "
  if curcol > 50
     " cursor is in ascii part
     " get character
     let char = getline(".")[col(".")-1]
     let hex = s:HEX_Nr2Hex(char2nr(char))
     call s:HEX_ToggleH2A()	" Move cursor to other area
     " delete two characters (hex)
     exe ":norm! 2x"
     " switch to insert mode and put new hex value
     exe ":norm! i" . hex
     " move one forward
     call s:HEX_NextPrev(1)
     " Move cursor to other area
     call s:HEX_ToggleH2A()
  else
     " Move cursor one right
     exe ":norm! l"
     let curcol  = col(".")
     " easier editing - move to next hex block 
     " if cursor is on position 49 put it to new line
     if curcol == 49
        call s:HEX_NextPrev(1)
     endif
     " if we are on a space (between hex blocks) move to nex hex block
     let si = 14
     while si < 45
     	if curcol == si
        	exe ":norm! l"
     	endif
	let si = si + 5
     endwhile
  endif
  " Move cursor one right
  " exe ":norm! <Right>"
  " refresh status line
  exe 'silent! match AsciiPos /\%' . s:HEX_ShowOffsets() . 'v'
  " start select mode (hope it's the same like replace)
  exe ":norm! gh"
  " echo "hexchar ist:" . hex 
endfun
" 
" 
" =======================================================================================
" Find HEX Character
" =======================================================================================
function s:HEX_Find()
  let hf = tolower(input("Enter Hex Charcter e.g. 0d:"))
  execute "normal! /" . hf .  "\\%>9c\\%<49c\<cr>"
endfun
" 
" =======================================================================================
" Show Hexoffset and Help Menue (if required)
" =======================================================================================
function s:HEX_Help()
" 
  echo "	Plugin: hexman.vim 	Version: 0.7.2"
  echo ""
  echo "	Available functions:"
  echo ""
  echo "	<leader>hm		Hex(manager) toggle on / off"
  echo "	<leader>hd  		Delete hex character under cursor"
  echo "	<leader>hi  		Insert ascii character before cursor"
  echo "	<leader>hg  		Goto hex offset. "
  echo "	<leader>hf  		Find Hex Character."
  echo "	<leader>hn  		Goto next hex offset. "
  echo "	<leader>hp  		Goto previous hex offset. "
  echo "	<leader>ht  		Switch cursor between hex and ascii area "
  echo "	<leader>hs  	        Show / Hide hexoffset infos in statusline"
  if !exists("g:mapleader")
	echo "	<leader> = '\\'"
  else
	echo "	<leader> = " . g:mapleader
  endif
endfun
"=============================================================================
" restore cpoptions
let &cpo = s:save_cpo
"=============================================================================
" End off hexman.vim
"=============================================================================
