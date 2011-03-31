" C specific configuration.
"
" Matches the Kernel Coding style.
" Thanks to Bart:
" http://www.jukie.net/bart/blog/vim-and-linux-coding-style.

" Indentation
set noexpandtab                         " use tabs, not spaces
set tabstop=8                           " tabstops of 8
set shiftwidth=8                        " indents of 8
set textwidth=78                        " screen in 80 columns wide, wrap at 78
set softtabstop=8                       " Makes one backspace go back a full 8 spaces

syn keyword cType uint ubyte ulong uint64_t uint32_t uint16_t uint8_t boolean_t int64_t int32_t int16_t int8_t u_int64_t u_int32_t u_int16_t u_int8_t u8 wait_queue_head_t atomic_t
syn keyword cOperator likely unlikely

syn match ErrorMsg /^ \+/        " highlight any leading spaces
syn match ErrorMsg /\s\+$/       " highlight any trailing spaces
match ErrorMsg     /\%>80v.\+/   " highlight anything past 80 in red

set formatoptions=tcqlron
set cinoptions=:0,l1,t0,g0

"set foldmethod=syntax
