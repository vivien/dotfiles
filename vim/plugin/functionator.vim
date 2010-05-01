" File: functionator.vim
" Author: Michael Sanders (msanders42 [at] gmail [dot] com)
" Description: Shows the name of the function the cursor is currently in when
"              gn is pressed, and goes to the [count] line of that function when
"              [count]gn is used.
"              Currently supports: C, Obj-C, JavaScript, Python, and Vim script.

if exists('s:did_functionator') || &cp || version < 700
	finish
endif
let s:did_functionator = 1
nn <silent> gn :<c-u>call functionator#GetName()<cr>
