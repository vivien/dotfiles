let g:bufpane_showhelp = exists('g:bufpane_showhelp') && g:bufpane_showhelp
let g:bufpane_hideunlisted = exists('g:bufpane_hideunlisted') && g:bufpane_hideunlisted

if !exists('g:bufpane_drawermode') || g:bufpane_drawermode
	au WinLeave Buffer\ List cal<SID>LeaveBufPane()
endif
au WinEnter Buffer\ List cal bufpane#Activate()

fun bufpane#Activate()
	let s:opt = {} " Save current options.
	let s:opt['is'] = &is | let s:opt['hls'] = &hls
	set is nohls

	" If bufpane has already been opened, reactivate it.
	if exists('s:bufpaneBuffer') && bufexists(s:bufpaneBuffer)
		let bufpaneWin = bufwinnr(s:bufpaneBuffer)
		if bufpaneWin == -1
			sil exe 'to vert sb '.s:bufpaneBuffer
			exe 'vert res'.(s:helpPref ? '32' : '25')
		elseif winbufnr(2) == -1
			q " If no other windows are open, quit bufpane automatically.
		else " If bufpane is out of focus, bring it back into focus.
			exe bufpaneWin.'winc w'
		endif
		call s:UpdateBufPane(0)
	else " Otherwise, create the bufpane.
		sil call s:CreateBufPane()
		call s:UpdateBufPane(1)
	endif
endf

fun s:CreateBufPane()
	to vnew
	vert res 25

	let s:helpPref      = 0
	let s:pathPref      = 0
	let s:sortPref      = 0
	let s:bufpaneBuffer = bufnr('%')

	setl bt=nofile bh=wipe noswf nobl nonu nowrap
	if !exists('g:bufpane_drawermode') || g:bufpane_drawermode
		setl bh=hide
	endif
	sil file Buffer\ List

	nn <buffer> q <c-w>q
	nn <silent> <buffer> l :cal<SID>PreviousWindow()<cr>
	nm <buffer> gl l
	nn <silent> <buffer> h :cal<SID>TogglePref(0)<cr>
	nn <silent> <buffer> s :cal<SID>TogglePref(1)<cr>
	nn <silent> <buffer> p :cal<SID>TogglePref(2)<cr>
	nn <silent> <buffer> x :cal<SID>BufPaneDelete('bd')<cr>
	nn <silent> <buffer> X :cal<SID>BufPaneDelete('bd!')<cr>
	nn <silent> <buffer> w :cal<SID>BufPaneDelete('bw')<cr>
	nn <silent> <buffer> W :cal<SID>BufPaneDelete('bw!')<cr>
	nn <silent> <buffer> o :cal<SID>BufPaneSelect(1)<cr>
	nn <silent> <buffer> O :cal<SID>BufPaneSelect(2)<cr>
	nn <silent> <buffer> v :cal<SID>BufPaneSelect(3)<cr>
	nn <silent> <buffer> <cr> :cal<SID>BufPaneSelect()<cr>
	nm <buffer> <leftmouse> <leftmouse><cr>

	" Automatically opens buffer after performing search.
	cno <silent> <buffer> <cr> <c-\>e<SID>Return(1)<cr><cr>:cal<SID>Return(0)<cr>

	syn match bufpaneNum display '^\d\+:' contained
	syn match bufpaneString display '^\d\+:\zs[^\.]*' contained
	syn match bufpaneExt display '\(\.\| (\).*' contained
	syn match bufpaneEntry display '^\d\+:.*' contains=bufpaneNum,bufpaneString,bufpaneExt
	syn match bufpaneComment display '^\D.*$'

	hi link bufpaneComment Comment
	hi link bufpaneNum Constant
	hi link bufpaneExt Type
endf

fun s:Return(var)
	if a:var
		let s:command = getcmdtype()
		return getcmdline()
	elseif s:command =~ '/\|?'
		let @/ = '' " Clear the last search pattern
		call s:BufPaneSelect()
	endif
	unl s:command
endf

" Goes to previous window if it exists; otherwise,
" tries to go to 'last' window.
fun s:PreviousWindow()
	exe winnr('#') != bufwinnr(s:bufpaneBuffer) ? 'winc p' : winnr('$').'winc w'
endf

fun s:LeaveBufPane()
	if !exists('s:opt') | return | endif
	for option in keys(s:opt)
		exe 'let &'.option.'='.s:opt[option]
	endfor
	unl s:opt
	if !exists('g:bufpane_drawermode') || g:bufpane_drawermode
		q
	else
		unl s:bufpaneBuffer
	endif
endf

fun s:UpdateBufPane(updateHelp)
	setl ma
	let line = 1
	let w = 25
	let cursorLine = line('.')

	if !s:helpPref && g:bufpane_showhelp
		let line = 5
		if a:updateHelp && getline(1)[2] != 'P'
			if line('$') >= 15 | sil 5,15d | endif
			call setline(1, 'Press h to toggle help')
		endif
	elseif s:helpPref
		let w = 32
		let line = 16
		if a:updateHelp && (getline(1)[2] == 'P' || !g:bufpane_showhelp)
			" Show help in lines 1 - 12.
			call setline(1, ['h : toggle this help', 'q : close buffer list',
						\ 'l : return to last window', 'x : delete buffer',
						\ 'X : force delete buffer', 'w : wipeout buffer',
						\ 'W : force wipeout buffer', 'o : edit below last window',
						\ 'O : edit above last window', 'v : edit in vsplit window',
						\ 's : toggle sorting', 'p : toggle path display'])
		endif
	endif
	if a:updateHelp && (g:bufpane_showhelp || s:helpPref)
		let path = s:pathPref == 1 ? 'displayed before' :
				\ (s:pathPref == 2 ? 'displayed after' : 'hidden')
		let sort = s:sortPref == 1 ? 'name' :
				\ (s:sortPref == 2 ? 'extension' : 'number')
		call setline(line - 3, ['Sorted by '.sort, 'Paths '.path, ''])
		unl path sort
	endif

	" Move bufpane's window to the left side & reset its width.
	winc H | exe 'vert res'.w

	let firstBufferLine = line

	for i in range(1, bufnr('$'))
		if bufexists(i) && i != s:bufpaneBuffer && (!g:bufpane_hideunlisted
													\ || buflisted(i))
			let bname = i.':	'
			if bufname(i) == ''
				let bname .= '[No Name]'
			else
				if !s:pathPref
					let bname .= expand('#'.i.':t')
				elseif s:pathPref == 1
					let bname .= expand('#'.i.':p')
				else
					let bname .= expand('#'.i.':t').' - '.expand('#'.i.':p:h')
				endif
			endif
			if !buflisted(i) | let bname .= ' (u)' | endif

			call setline(line, bname)
			let line += 1
		endif
	endfor

	" If buffers have been deleted, remove the lines.
	if line('$') >= line | sil exe line.',$ d_' | endif

	if s:sortPref == 1
		if a:updateHelp | ec 'Sorting by name.' | endif
		sil exe firstBufferLine.',$sort /\d\+/'
	elseif s:sortPref == 2
		if a:updateHelp | ec 'Sorting by extension.' | endif
		sil exe firstBufferLine.',$sort /.*\./'
	endif

	call cursor(cursorLine, 1)
	setl noma
endf

fun s:TogglePref(toggle)
	if !a:toggle " Toggle help
		let s:helpPref = 1 - s:helpPref
	elseif a:toggle == 1 " Toggle sort
		let s:sortPref = (s:sortPref + 1) % 3
		if !s:sortPref | ec 'Sorting by number.' | endif
	else " Toggle path
		let s:pathPref = (s:pathPref + 1) % 3
	endif
	call s:UpdateBufPane(1)
endf

fun s:BufPaneSelectedNum()
	retu str2nr(matchstr(getline('.'), '^\d\+'))
endf

fun s:BufPaneSelect(...)
	let num = s:BufPaneSelectedNum()

	if !bufexists(num)
		call s:UpdateBufPane(0)
	elseif !num
		call search('^\d') " Move cursor to first number if in a comment.
	else
		if bufwinnr(num) != -1 " If buffer is currently open, switch to it.
			exe bufwinnr(num).'winc w' | return
		endif

		winc p
		if a:0 && a:1 < 3 " Split window appropriately if asked.
			let splitbelow = &sb
			exe 'let &sb = '.(a:1 == 1).' | sp | let &sb ='.splitbelow
		elseif a:0 && a:1 == 3 | vnew | endif
		exe 'b'.num | setl bl
	endif
endf

fun s:BufPaneDelete(command)
	let num = s:BufPaneSelectedNum()
	if !num
		echoh ErrorMsg | ec 'Not a valid buffer.' | echoh None
		return
	endif
	let winNum = bufwinnr(num)
	let found  = 1
	let bufmod = a:command[-1] != '!' && getbufvar(num, '&mod')

	" If buffer is currently active, switch to another one first
	" to avoid an error message.
	if winNum != -1
		let found = 0
		for i in range(1, bufnr('$'))
			if buflisted(i) && i != s:bufpaneBuffer && i != num
				if !bufmod && winbufnr(3) == -1
					exe winNum.'winc w'
					" If buffer is last window, switch contents of window
					" to another buffer before deleting it.
					sil exe 'buf'.i
					if bufwinnr(s:bufpaneBuffer) != -1
						exe bufwinnr(s:bufpaneBuffer).'winc w'
					else
						sil exe 'to vert sb '.s:bufpaneBuffer
						exe 'vert res'.(s:helpPref ? '32' : '25')
					endif
				endif
				let found = 1
				break
			endif
		endfor
	endif

	if !found
		echoh ErrorMsg | ec "Can't delete last buffer!" | echoh None
	elseif a:command[:1] == 'bd' && !buflisted(num)
		echoh ErrorMsg | ec 'Buffer already unlisted.' | echoh None
	elseif bufmod && a:command !~ '!$'
		let com = a:command == 'bd' ? ['X', 'delete'] : ['W', 'wipe']
		echoh ErrorMsg
		ec 'Buffer '.num.' was modified. Press '.com[0].' to force '.com[1].' it.'
		echoh None
	else
		let lnum = line('.')
		if bufexists(num) | exe a:command.' '.num | endif
		call s:UpdateBufPane(0)
		if lnum > line('$') | let lnum = line('$') | endif
		call cursor(lnum, 1)
	endif
endf
" vim:noet:sw=4:ts=4:ft=vim
