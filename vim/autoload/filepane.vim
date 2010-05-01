au WinLeave File\ List cal<SID>LeaveFilePane()
au WinEnter File\ List cal filepane#Activate()

fun filepane#Activate()
	" If filepane has already been opened, reactivate it.
	if exists('s:filepane_buf') && bufexists(s:filepane_buf)
		let filepane_win = bufwinnr(s:filepane_buf)
		if filepane_win == -1
			sil exe 'to vert sb '.s:filepane_buf
			exe 'vert res'.g:filepane_width
			call s:UpdateFilePane()
		elseif winbufnr(2) == -1
			q " If no other windows are open, quit bufpane automatically.
		else " If filepane is out of focus, bring it back into focus.
			exe filepane_win.'winc w'
			exe 'vert res'.g:filepane_width
		endif
	else " Otherwise, create the filepane.
		sil call s:CreateFilePane()
		call s:UpdateFilePane()
	endif

	let s:opt = {'is':&is, 'hls':&hls, 'cul':&cul} " Save current options.
	setl is nohls cul
endf

fun s:CreateFilePane()
	if isdirectory(bufname('%')) " Delete directory buffer created by Vim
		exe 'bw'.bufnr('%')
	endif
	to vnew
	let g:filepane_width = exists('g:filepane_width') ? g:filepane_width : 25
	let g:filepane_drawermode = !exists('g:filepane_drawermode') || g:filepane_drawermode

	exe 'vert res'.g:filepane_width

	let s:filepane_buf = bufnr('%')
	let s:expand_dirs = {}

	sil file File\ List
	setl bt=nofile bh=wipe noswf nobl nonu nowrap

	if g:filepane_drawermode
		setl bh=hide
	endif

	nn <silent> <buffer> x :cal<SID>CustomViewFile()<cr>
	nn <silent> <buffer> p :cal<SID>PreviousWindow()<cr>
	nn <silent> <buffer> R :cal<SID>RenameFile()<cr>
	nn <silent> <buffer> d :cal<SID>MakeDir()<cr>
	nn <silent> <buffer> D :cal<SID>DeleteSingleFile()<cr>
	vno <silent> <buffer> D :cal<SID>DeleteMultipleFiles()<cr>

	nn <silent> <buffer> . :cal<SID>GoToParentDir()<cr>
	nm <silent> <buffer> ~ :cd ~<bar>cal<SID>UpdateFilePane()<cr>
	nn <silent> <buffer> <cr> :cal<SID>SelectFile()<cr>
	nn <silent> <buffer> <space> :cal<SID>ChangeDir()<cr>
	nn <silent> <buffer> o :cal<SID>SelectFile(1)<cr>
	nn <silent> <buffer> O :cal<SID>SelectFile(2)<cr>
	nn <silent> <buffer> v :cal<SID>SelectFile(3)<cr>
	nn <silent> <buffer> > <c-w>>:let g:filepane_width+=1<cr>
	nn <silent> <buffer> < <c-w><:let g:filepane_width-=1<cr>
	nn <buffer> <c-l> :sil cal<SID>UpdateFilePane()<bar>echo "File list refreshed."<cr>
	nn <buffer> q <c-w>q
	nm <buffer> gL p
	nm <buffer> <2-leftmouse> <cr>
	nm <buffer> <3-leftmouse> <cr>
	nm <buffer> <4-leftmouse> <cr>
	nm <buffer> <right> <cr>
	nm <buffer> <left> .
	vm <buffer> d D
	vm <buffer> x D
	nm <buffer> dd D

	syn match filepaneDir '.*/$' display
	syn match filepaneExt '.*\.\zs.*$' display
	syn match filepaneTree '^\(| \)\+' display

	hi link filepaneDir Special
	hi link filepaneExt Type
	hi link filepaneTree String
endf

" Goes to previous window if it exists; otherwise, tries to go to 'last' window.
fun s:PreviousWindow()
	exe winnr('#') != bufwinnr(s:filepane_buf) ? 'winc p' : winnr('$').'winc w'
endf

fun s:LeaveFilePane()
	for option in keys(s:opt)
		exe 'let &'.option.'='.s:opt[option]
	endfor
	unl s:opt "s:expand_dirs
	if g:filepane_drawermode | q | endif
endf

fun s:UpdateFilePane()
	setl ma
	let orig_pos = line('.')
	sil 1,$ d_
	call setline(1, '..')

	" Move filepane's window to the left side & reset its width.
	winc H
	exe 'vert res'.g:filepane_width

	let current_dir = substitute(getcwd().'/', '//$', '/', '')

	let line = s:DisplayFiles(2, current_dir) - 2

	let current_dir = substitute(fnameescape(current_dir), '^'.$HOME, '~', '')
	exe 'setl stl=%<'.current_dir.'%=%l'
	echo '"'.current_dir.'" '.line.' item'.(line == 1 ? '' : 's')

	call cursor(orig_pos, 1)
	setl noma
endf

fun s:DisplayFiles(start_line, dir, ...)
	let dirnamelen = len(a:dir)
	let line = a:start_line
	let bars = repeat('| ', a:0 ? a:1 : 0)
	for file in split(globpath(a:dir, '*'), "\n")
		if isdirectory(file) | let file .= '/' | endif
		call setline(line, bars.strpart(file, dirnamelen))
		let line += 1
		if has_key(s:expand_dirs, file)
			let line = s:DisplayFiles(line, file, a:0 ? a:1 + 1 : 1)
		endif
	endfor
	return line
endf

fun s:ParentDirs(file)
	let orig_pos = line('.')
	let bars = matchstr(a:file, '^\(| \)*')
	let file = strpart(a:file, len(bars))
	while bars != ''
		let bars = bars[2:]
		call search('^'.bars.'[^|]', 'bW')
		let file = strpart(getline('.'), len(bars)).file
	endw
	call cursor(orig_pos, 1)
	return file
endf

fun s:SelectedFile()
	let current_dir = substitute(getcwd().'/', '//$', '/', '')
	let file = getline('.')
	if file =~ '^| '
		let file = s:ParentDirs(file)
	endif
	return current_dir.file
endf

fun s:SelectFile(...)
	let file = s:SelectedFile()
	if isdirectory(file)
		if file[-2:] == '..'
			cd ..
		elseif has_key(s:expand_dirs, file)
			call remove(s:expand_dirs, file)
		else
			let s:expand_dirs[file] = 1
		endif
		let file = substitute(file, '^'.$HOME, '~', '')
		if globpath(fnameescape(file), '*') == ''
			redraw
			echo 'Directory "'.file.'" is empty.'
		else
			let savedview = winsaveview()
			call s:UpdateFilePane()
			call winrestview(savedview)
		endif
	elseif filereadable(file)
		let different_file = bufname(winbufnr(winnr('#'))) != file
		if different_file
			let drawermode = g:filepane_drawermode
			let g:filepane_drawermode = 0
		endif
		winc p

		if a:0 && a:1 < 3
			let splitbelow = &sb
			exe 'let &sb ='.(a:1 == 1).' | sp | let &sb ='.splitbelow
		elseif a:0 && a:1 == 3
			vnew
		endif
		exe 'e'.fnameescape(file)
		if !different_file | return | endif
		winc p
		let g:filepane_drawermode = drawermode
	else
		echo 'Could not read file '.file
	endif
endf

fun s:GoToParentDir()
	let bars = matchstr(getline('.'), '^\(| \)*')
	if getline('.') == '..'
		call s:ChangeDir()
	elseif bars == ''
		call cursor(1, 1)
	else
		let orig_pos = line('.')
		call search('^'.bars[2:].'[^|]', 'bW')
	endif
endf

fun s:ChangeDir()
	exe 'cd'.fnameescape(s:SelectedFile())
	call s:UpdateFilePane()
endf

fun s:RenameFile()
	let file = s:SelectedFile()
	call rename(file, input('Rename "'.strpart(file, strridx(file, '/') + 1).
	                    \   '" to '))
	sil call s:UpdateFilePane()
endf

fun s:Delete(file)
	if isdirectory(a:file)
		let fname = fnameescape(a:file)
		if system('rmdir '.fname) == ''
			return 1
		endif
        if confirm('Directory "'.a:file.'" is not empty. Do you still want to delete it?',
		         \ "&Delete\n&Cancel", 2) != 1
			redraw
			return
		endif
		redraw
		return system('rm -r '.fname) == ''
	else
		return delete(a:file) == 0
	endif
endf

fun s:DeleteSingleFile()
	let file = s:SelectedFile()
	if confirm('Delete "'.file.'"?', "&Delete\n&Cancel", 2) != 1
		return -1
	endif
	redraw " Get rid of any previously echoed messages
	let name = isdirectory(file) ? 'Directory' : 'File'
	echo name.' "'.file.'" '.(s:Delete(file) ? 'was' : 'could not be').' deleted'
	sil call s:UpdateFilePane()
endf

fun s:DeleteMultipleFiles() range
	let filecount = (a:lastline - a:firstline) + 1
	if filecount == 1 | return s:DeleteSingleFile() | endif
	if confirm('Delete '.filecount.' files?', "&Delete\n&Cancel", 2) != 1
		return
	endif
	for file in getline(a:firstline, a:lastline)
		if !s:Delete(file)
			echo '"'.file.'" could not be deleted'
		endif
	endfor
	redraw
	echo filecount.' files were deleted'
	sil call s:UpdateFilePane()
endf

fun s:MakeDir()
	let dir = input('Create directory: ', '', 'file')
	if dir == '' | return | endif
	call mkdir(dir[:-1])
	sil call s:UpdateFilePane()
endf

fun s:CustomViewFile()
	if !exists('g:filepane_viewer')
		if !has('unix') | return | endif
		if executable('gnome-open')
			let g:filepane_viewer = 'gnome-open'
		elseif executable('kfmclient')
			let g:filepane_viewer = 'kfmclient'
		elseif executable('open')
			let g:filepane_viewer = 'open'
		else
			return
		endif
	endif
	let file = fnameescape(s:SelectedFile())
	sil exe '!'.g:filepane_viewer.' '.file
	redraw! " Skip enter prompt
endf
" vim:noet:sw=4:ts=4:ft=vim
