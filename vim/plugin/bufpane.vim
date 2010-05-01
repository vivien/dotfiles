" File:          bufpane.vim
" Author:        Michael Sanders (msanders42 [at] gmail [dot] com)
" Version:       0.42
"
" Description:   Bufpane.vim is an unobstrusive, simple script that displays
"                buffers in a small sidepane left of the current window.
"                It is a cleaned up & very modified version of buflist.vim by
"                Fabien Bouleau.
" Usage:
"                Press gl to open bufferlist; for more help just press h
"                while in the sidepane.
"
"                bufpane.vim has only three preferences:
"                  - g:bufpane_drawermode causes the sidepane to be hidden
"                    when deactivated; default is 1
"                  - g:bufpane_hideunlisted causes unlisted buffers to be
"                    hidden; default is 0
"                  - g:bufpane_showhelp enables the help message (including
"                    the current sort & path settings) to be shown at the top
"                    of the sidepane; default is 1
" Last Modified: March 5, 2009

if exists('s:did_bufpane') || &cp || version < 700
	finish
endif
let s:did_bufpane = 1

nn <silent> gl :cal bufpane#Activate()<cr>
" vim:noet:sw=4:ts=4:ft=vim
