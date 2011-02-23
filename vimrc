" Author: v0n aka Vivien Didelot
" inspired from:
"   Michael Sanders
"   Mathieu Schroeter
"   Bart Trojanowski

" Global settings
"""""""""""""""""
syntax on
filetype plugin indent on      " add smart indentation and comment for many languages
set smarttab                   " make <tab> and <backspace> smarter
set backspace=eol,start,indent " allow backspacing over indent, eol, & start
set number
set hlsearch
set incsearch
set history=100            " Only store past 100 commands
set undolevels=150         " Only undo up to 150 times
set titlestring=%f title   " Display filename in terminal window
set mouse=nvch             " Enable mouse support, unless in insert mode
set enc=utf-8              " Enable unicode support
set wmh=0                  " Sets the minimum window height to 0

" Theme
"""""""
set background=dark
colorscheme wuye

" Cursor
""""""""
"set cursorline
"set cursorcolumn
" last position jump. note that your ~/.viminfo should be owned by you.
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Remap
"""""""
noremap j gj
noremap k gk
" switch easily between splits
map <C-h> <C-w>h<C-w>=
map <C-l> <C-w>l<C-w>=
map <C-j> <C-w>j<C-w>=
map <C-k> <C-w>k<C-w>=
" disable Ctrl+Space bad things
imap <Nul> <Space>
map <Nul> <Nop>
vmap <Nul> <Nop>
cmap <Nul> <Nop>
nmap <Nul> <Nop>
" add copy/paste from clipboard (need xclip package)
vmap <C-c> y: call system("xclip -i -selection clipboard", getreg("\""))<CR>
nmap <C-v> :call setreg("\"",system("xclip -o -selection clipboard"))<CR>p
imap <C-v> <Esc><C-v>a
" map double-click to enter in insert mode
nmap <2-LeftMouse> a
" toggle button for NERDTree
map <F2> <Esc>:NERDTreeToggle<CR>
" map F5 to remove trailing spaces
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
" forces (re)indentation of a block of code
nmap <C-i> vip=

" Indentation (I use 4 spaces indentation by default).
"""""""""""""
set expandtab         " Insert spaces instead of tab
set tabstop=4         " Number of spaces for a tab
set shiftwidth=4      " Tab size
set softtabstop=4     " Makes one backspace go back a full 4 spaces
                      " Use :retab to match the current tab settings

" Advanced options
""""""""""""""""""
" Customize statusline with RVM and fugitive (thanks to telemachus)
set ls=2
set statusline=%<%f\ %h%m%r%y
            \%{exists('g:loaded_fugitive')?fugitive#statusline():''}
            \%=%-14.(%l,%c%V%)\ %P

"set shm=atI                " Disable intro screen
set lazyredraw             " Don't redraw screen during macros
set ttyfast                " Improves redrawing for newer computers
"set ruf=%l:%c ruler        " Display current column/line in bottom right
set showcmd                " Show incomplete command at bottom right
set splitbelow             " Open new split windows below current
set wrap linebreak         " Automatically break lines
"set pastetoggle=<f2>       " Use <f2> to paste in text from other apps
set wildmode=full wildmenu " Enable command-line tab completion
set completeopt=menu       " Don't show extra info on completions
set wildignore+=*.o,*.obj,*.pyc,*.DS_Store,*.db " Hide irrelevent matches
set ignorecase smartcase   " Only be case sensitive when search has uppercase
"set nofoldenable           " Disable folding
"ru macros/matchit.vim      " Enable extended % matching

