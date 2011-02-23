" Ruby specific configuration.

" Uses 2 spaces for indentation.
setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=2

" Customizes the statusline
set statusline=%<%f\ %h%m%r%y
\%{exists('g:loaded_rvm')?rvm#statusline_ft_ruby():''}
\%{exists('g:loaded_fugitive')?fugitive#statusline():''}
\%=%-14.(%l,%c%V%)\ %P
