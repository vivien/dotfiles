" File: commenter.vim
" Author: Michael Sanders (msanders42 [at] gmail [dot] com)
" Description: A simple commenting plugin for some popular filetypes

if exists('s:did_commenter') || &cp || version < 700
	finish
endif
let s:did_commenter = 1

au FileType * call s:GetCommentType()
au BufEnter * if !exists('b:lineComment') && !exists('b:startComment') | call s:GetCommentType() | endif

nn <silent> gc :<c-u>call <SID>Comment(0)<cr>
nn <silent> gC :call <SID>Uncomment(0)<cr>
vno <silent> gc :<c-u>call <SID>Comment(1)<cr>
vno <silent> gC :call <SID>Uncomment(1)<cr>

" Default to ANSI-style (/* */) comments for C filetyps.
let g:ansiComment = !exists('g:ansiComment') || g:ansiComment

" For some reason this has to be a function; &ft in a plugin is apparently
" normally empty, unless the plugin is sourced.
fun s:GetCommentType()
	let ft = stridx(&ft, '.') == -1 ? &ft : matchstr(&ft, '.\{-}\ze\.')
	if ft == ''
		let b:lineComment = '#' " Default to # style comment
	elseif ft =~ '^\(c\|objc\|cpp\|cs\|css\|dict\|javascript\|dylan\|php\|java\|io\)$'
		let b:startComment = '/*'
		let b:endComment = '*/'
		if ft != 'dict' && (!g:ansiComment || ft != 'c')
			let b:lineComment = '//'
		endif
	elseif ft =~ '^\(html\|xhtml\|xml\|dtd\)$'
		let b:startComment = '<!--'
		let b:endComment = '-->'
	elseif ft == 'vim'
		let b:lineComment = '"'
	elseif ft =~ '^\(applescript\|haskell\|lua\|ada\)$'
		let b:lineComment = '--'
		if ft == 'applescript'
			let b:startComment = '(*'
			let b:endComment = '*)'
		elseif ft == 'haskell'
			let b:startComment = '{-'
			let b:endComment = '-}'
		elseif ft == 'lua'
			let b:startComment = '--[['
			let b:endComment = '--]]'
		endif
	elseif ft =~ '^\(lisp\|scheme\)$'
		let b:lineComment = ';'
	elseif ft =~ '^\(tex\|plaintex\|erlang\)$'
		let b:lineComment = '%'
	elseif ft == 'pascal'
		let b:startComment = '{*'
		let b:endComment = '*}'
		let b:lineComment = '//'
	else
		let b:lineComment = '#'
	endif
endf

fun s:Comment(vmode)
	let col = col('.')+1
	let blank = !v:count && !a:vmode && getline('.') =~ '^\s*$'
	if !exists('b:startComment') || (!a:vmode && exists('b:lineComment') && !v:count)
		let col += len(b:lineComment)
		let i = 1
		wh i <= v:count1
			sil! exe 'norm! '.(a:vmode ? "`<\<c-v>`>" : '')."I".b:lineComment." \<esc>j"
			let i += 1
		endw
		norm! ']
	else
		let col += len(b:startComment)
		if a:vmode
			let s = '`<' | let e = '`>'
		else
			let s = '' | let e = v:count < 2 ? '' : (v:count-1).'j'
		endif
		exe 'norm! '.s.'I'.b:startComment.' '
		exe 'norm! '.e.'A '.b:endComment
		let end = 1
	endif
	if blank
		star!
		if !exists('end') | return | endif
	endif
	call cursor(0, col)
	sil! call repeat#set((a:vmode ? '1v' : '').'gc')
endf

fun s:Uncomment(vmode) range
	let line = getline(a:firstline)
	" Uncomment from the beginning of selection if in visual mode; otherwise,
	" uncomment from the start of the line.
	let s = a:vmode ? '\%'.col("'<").'c' : '^'

	if exists('b:lineComment') && match(line, s.'\s*'.b:lineComment) != -1
		let start = escape(b:lineComment, '/')
	elseif exists('b:startComment') &&
				\ match(line, s.'\s*'.escape(b:startComment, '*')) != -1
		let start = escape(b:startComment, '/*')
		let end = escape(b:endComment, '/*')
	else | return | endif

	if !exists('end')
		call setline(a:firstline, substitute(line, s.'\s*\zs'.start.' \=', '', ''))
		if a:lastline > a:firstline
			sil! exe (a:firstline+1).','.a:lastline.'s/^\s*\zs'.start.' \=//g'
		endif
	else
		call setline(a:firstline, substitute(line, s.'\s*\zs'.start.' \=', '', ''))
		" let e = a:vmode ? '\%'.col("'>").'c' : '$'
		call setline(a:lastline, substitute(getline(a:lastline), ' \='.end.'$', '', ''))
	endif
	sil! call repeat#set((a:vmode ? '1v' : '').'gC')
endf
