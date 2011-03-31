set cursorline

" Map Ctrl-Space + <shortcut> to update
" the current commit line with the corresponding command
nmap <C-@>p mc0cwpick<Esc>`c
nmap <C-@>r mc0cwreword<Esc>`c
nmap <C-@>e mc0cwedit<Esc>`c
nmap <C-@>s mc0cwsquash<Esc>`c
nmap <C-@>f mc0cwfixup<Esc>`c
