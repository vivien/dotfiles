" Author: v0n aka Vivien Didelot
" inspired from:
"   Michael Sanders
"   Mathieu Schroeter

" Global settings
syntax on
set number
set hlsearch
set incsearch
set history=100            " Only store past 100 commands
set undolevels=150         " Only undo up to 150 times
set titlestring=%f title   " Display filename in terminal window
set mouse=a                " Enable mouse support, unless in insert mode
set enc=utf-8              " Enable unicode support
set wmh=0                  " Sets the minimum window height to 0

" Theme
set background=dark
color slate " Michael Sanders' color scheme, adopted from TextMate

" Cursor
set cursorline
set cursorcolumn
"TODO don't blink
au BufReadPost * exe "normal! g`\""

" Remap
noremap j gj
noremap k gk
" remap tag command
noremap T 
" map F5 to remove trailing spaces
"nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
" switch easily between splits
map <C-H> <C-W>h<C-W>=
map <C-L> <C-W>l<C-W>=
map <C-J> <C-W>j<C-W>=
map <C-K> <C-W>k<C-W>=

" Indentation, Tabs and Spaces. I use 4 spaces indentation
filetype on
set expandtab                              " Insert spaces instead of tab
set tabstop=4                              " Number of spaces for a tab
set shiftwidth=4                           " Tab size
set softtabstop=4                          " Makes one backspace go back a full 4 spaces
autocmd FileType make setlocal noexpandtab " Turn off expandtab for makefiles
                                           " use Ctrl-V<Tab> for a real tab)
                                           " Use :retab to match the current tab settings
" Highlight unwanted Tabs and Spaces
highlight Tab ctermbg=darkgray guibg=darkgray
highlight Space ctermbg=darkblue guibg=darkblue
au BufWinEnter * let w:m2=matchadd('Tab', '\t', -1)
au BufWinEnter * let w:m3=matchadd('Space', '\s\+$\| \+\ze\t', -1)
set list listchars=tab:»·,trail:·

" Show when a line exceeds 80 chars
"au BufWinEnter * let w:m1=matchadd('ErrorMsg', '\%>80v.\+', -1) " highlight lines longer than 80 chars

" Special highlighting for Doxygen
let g:load_doxygen_syntax=1

" Advanced options
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
ru macros/matchit.vim      " Enable extended % matching

