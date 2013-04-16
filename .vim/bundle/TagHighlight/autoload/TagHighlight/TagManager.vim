" Tag Highlighter:
"   Author:  A. S. Budden <abudden _at_ gmail _dot_ com>
" Copyright: Copyright (C) 2009-2012 A. S. Budden
"            Permission is hereby granted to use and distribute this code,
"            with or without modifications, provided that this copyright
"            notice is copied with it. Like anything else that's free,
"            the TagHighlight plugin is provided *as is* and comes with no
"            warranty of any kind, either expressed or implied. By using
"            this plugin, you agree that in no event will the copyright
"            holder be liable for any damages resulting from the use
"            of this software.

" ---------------------------------------------------------------------
try
	if &cp || v:version < 700 || (exists('g:loaded_TagHLTagManager') && (g:plugin_development_mode != 1))
		throw "Already loaded"
	endif
catch
	finish
endtry
let g:loaded_TagHLTagManager = 1

function! TagHighlight#TagManager#InitialiseBufferTags()
	if ! has_key(g:TagHighlightPrivate, 'OriginalTagsSetting')
		let g:TagHighlightPrivate['OriginalTagsSetting'] = &g:tags
	endif
	if ! exists('b:TagHighlightPrivate')
		let b:TagHighlightPrivate = {}
	endif
	if ! has_key(b:TagHighlightPrivate, 'OriginalTagsSetting')
		let b:TagHighlightPrivate['OriginalTagsSetting'] = &tags
	endif
endfunction

function! TagHighlight#TagManager#ConfigureTags()
	if TagHighlight#Option#GetOption('DisableTagManager') == 1
		return
	endif
	let tagfilename = TagHighlight#Option#GetOption('TagFileName')
	let tagfiles = []
	for library in b:TagHighlightLoadedLibraries
		let types_folder = fnamemodify(library['Path'], ':h')
		let tag_file_path = types_folder . '/' . tagfilename
		if filereadable(tag_file_path)
			let tagfiles += [tag_file_path]
		endif
	endfor

	let newtagsoption = b:TagHighlightPrivate['OriginalTagsSetting']
	for tagfile in tagfiles
		let newtagsoption .= ',' . escape(tagfile, ' ')
	endfor
	let &l:tags = newtagsoption
endfunction
