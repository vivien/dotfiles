" Author: Moritz Heckscher
" Copyright: Copyright (c) 2005 Moritz Heckscher
" Description: Automatic conversion of plist files (can be binary but have xml syntax)
" Source: http://www.macosxhints.com/article.php?story=20050803111126899

if exists('s:did_plist') || &cp | fini | en
let s:did_plist = 1

" NOTE: When a file changes externally and you answer no to vim's question if
" you want to write anyway, the autocommands are still executed,
" which could have some unwanted side effects.
fun! s:BinPlistReadPost()
	if getline("'[") =~ "^bplist"
		'[,']!plutil -convert xml1 /dev/stdin -o /dev/stdout
		let b:saveAsBinPlist = 1
	en
	set nobin
	filetype detect
endf
fun! s:BinPlistWritePre()
	if exists('b:saveAsBinPlist')
		set bin
		sil '[,']!plutil -convert binary1 /dev/stdin -o /dev/stdout
		if v:shell_error | u | set nobin | en
	en
endf
fun! s:BinPlistWritePost()
	if exists('b:saveAsBinPlist') && !v:shell_error
		u | set nobin
	en
endf

au BufReadPost *.plist cal s:BinPlistReadPost()
au FileReadPost *.plist cal s:BinPlistReadPost() | unl b:saveAsBinPlist
au BufWritePre,FileWritePre *.plist cal s:BinPlistWritePre()
au BufWritePost,FileWritePost *.plist cal s:BinPlistWritePost()
