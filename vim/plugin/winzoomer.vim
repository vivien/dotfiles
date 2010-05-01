" File: winzoomer.vim
" Author: Michael Sanders
" Description: A simplified version of ZoomWin.vim.
" Usage: Press <c-w>o to "zoom" into a split window, and <c-w>o again to zoom
"        out of it.

if exists('s:did_winzoomer') || &cp || version < 700 || !has('mksession')
	finish
endif
let s:did_winzoomer = 1
nn <silent> <c-w>o :cal winzoomer#Zoom()<cr>

fun winzoomer#Zoom()
	let lz_save = &lz
	set lz
	if exists('s:sessionFile')
		sil exe 'so '.s:sessionFile
		cal delete(s:sessionFile)

		let &hid = s:hid_save
		unl s:sessionFile s:hid_save
	elseif winbufnr(2) != -1
		let s:hid_save = &hid
		set hid

		let s:sessionFile = tempname()
		exe 'mks '.fnameescape(s:sessionFile)
		only
	endif
	let &lz = lz_save
endf
