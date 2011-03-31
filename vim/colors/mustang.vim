" This scheme was created by CSApproxSnapshot
" on mar, 22 mar 2011

hi clear
if exists("syntax_on")
    syntax reset
endif

if v:version < 700
    let g:colors_name = expand("<sfile>:t:r")
    command! -nargs=+ CSAHi exe "hi" substitute(substitute(<q-args>, "undercurl", "underline", "g"), "guisp\\S\\+", "", "g")
else
    let g:colors_name = expand("<sfile>:t:r")
    command! -nargs=+ CSAHi exe "hi" <q-args>
endif

if 0
elseif has("gui_running") || (&t_Co == 256 && (&term ==# "xterm" || &term =~# "^screen") && exists("g:CSApprox_konsole") && g:CSApprox_konsole) || &term =~? "^konsole"
    CSAHi Normal term=NONE cterm=NONE ctermbg=234 ctermfg=254 gui=NONE guibg=#202020 guifg=#e2e2e5
    CSAHi cNumbersCom term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cParen term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cBracket term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cNumbers term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi Underlined term=underline cterm=underline ctermbg=bg ctermfg=147 gui=underline guibg=bg guifg=#80a0ff
    CSAHi Ignore term=NONE cterm=NONE ctermbg=bg ctermfg=234 gui=NONE guibg=bg guifg=#202020
    CSAHi Error term=reverse cterm=NONE ctermbg=196 ctermfg=231 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi Todo term=NONE cterm=NONE ctermbg=228 ctermfg=16 gui=italic guibg=#e6ea50 guifg=#000000
    CSAHi String term=NONE cterm=NONE ctermbg=bg ctermfg=149 gui=italic guibg=bg guifg=#b1d631
    CSAHi Number term=NONE cterm=NONE ctermbg=bg ctermfg=214 gui=NONE guibg=bg guifg=#ff9800
    CSAHi Boolean term=NONE cterm=NONE ctermbg=bg ctermfg=149 gui=NONE guibg=bg guifg=#b1d631
    CSAHi Function term=NONE cterm=bold ctermbg=bg ctermfg=231 gui=bold guibg=bg guifg=#ffffff
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=59 ctermfg=244 gui=NONE guibg=#343434 guifg=#808080
    CSAHi NonText term=bold cterm=NONE ctermbg=236 ctermfg=244 gui=NONE guibg=#303030 guifg=#808080
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=#00ffff
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=196 ctermfg=231 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=254 ctermfg=234 gui=reverse guibg=bg guifg=fg
    CSAHi Search term=reverse cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=72 gui=bold guibg=bg guifg=#2e8b57
    CSAHi ModeMsg term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi LineNr term=underline cterm=NONE ctermbg=16 ctermfg=244 gui=NONE guibg=#000000 guifg=#808080
    CSAHi mailEmail term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailSignature term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cBlock term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailQuoted2 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailQuoted3 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailQuoted4 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailQuoted5 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailQuoted6 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=238 ctermfg=231 gui=NONE guibg=#444444 guifg=#ffffff
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=149 ctermfg=16 gui=NONE guibg=#b1d631 guifg=#000000
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=250 ctermfg=fg gui=NONE guibg=#bebebe guifg=fg
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=254 ctermfg=234 gui=reverse guibg=bg guifg=fg
    CSAHi TabLine term=underline cterm=underline ctermbg=248 ctermfg=fg gui=underline guibg=#a9a9a9 guifg=fg
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=254 ctermfg=234 gui=reverse guibg=bg guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=236 ctermfg=fg gui=NONE guibg=#2d2d2d guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=236 ctermfg=fg gui=NONE guibg=#2d2d2d guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=241 ctermfg=fg gui=NONE guibg=#626262 guifg=fg
    CSAHi CursorIM term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailQuoted1 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi Keyword term=NONE cterm=NONE ctermbg=bg ctermfg=214 gui=NONE guibg=bg guifg=#ff9800
    CSAHi TypoMsg term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi Question term=NONE cterm=bold ctermbg=bg ctermfg=46 gui=bold guibg=bg guifg=#00ff00
    CSAHi StatusLine term=reverse,bold cterm=NONE ctermbg=238 ctermfg=252 gui=italic guibg=#444444 guifg=#d3d3d5
    CSAHi StatusLineNC term=reverse cterm=NONE ctermbg=238 ctermfg=246 gui=NONE guibg=#444444 guifg=#939395
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=238 ctermfg=238 gui=NONE guibg=#444444 guifg=#444444
    CSAHi Title term=bold cterm=bold ctermbg=bg ctermfg=231 gui=bold guibg=bg guifg=#f6f3e8
    CSAHi Visual term=reverse cterm=NONE ctermbg=59 ctermfg=230 gui=NONE guibg=#3c414c guifg=#faf4c6
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=bg ctermfg=196 gui=NONE guibg=bg guifg=#ff0000
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi Folded term=NONE cterm=NONE ctermbg=59 ctermfg=145 gui=NONE guibg=#384048 guifg=#a0a8b0
    CSAHi cUserCont term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cBitField term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cCppParen term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi lCursor term=NONE cterm=NONE ctermbg=254 ctermfg=234 gui=NONE guibg=#e2e2e5 guifg=#202020
    CSAHi MatchParen term=reverse cterm=bold ctermbg=236 ctermfg=194 gui=bold guibg=#2f2f2f guifg=#d0ffc0
    CSAHi Comment term=bold cterm=NONE ctermbg=bg ctermfg=244 gui=italic guibg=bg guifg=#808080
    CSAHi Constant term=underline cterm=NONE ctermbg=bg ctermfg=214 gui=NONE guibg=bg guifg=#ff9800
    CSAHi Special term=bold cterm=NONE ctermbg=bg ctermfg=214 gui=NONE guibg=bg guifg=#ff9800
    CSAHi Identifier term=underline cterm=NONE ctermbg=bg ctermfg=149 gui=NONE guibg=bg guifg=#b1d631
    CSAHi Statement term=bold cterm=NONE ctermbg=bg ctermfg=109 gui=NONE guibg=bg guifg=#7e8aa2
    CSAHi PreProc term=underline cterm=NONE ctermbg=bg ctermfg=230 gui=NONE guibg=bg guifg=#faf4c6
    CSAHi Type term=underline cterm=NONE ctermbg=bg ctermfg=109 gui=NONE guibg=bg guifg=#7e8aa2
    CSAHi cCppBracket term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cMulti term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi pythonOperator term=NONE cterm=NONE ctermbg=bg ctermfg=109 gui=NONE guibg=bg guifg=#7e8aa2
    CSAHi mailHeaderKey term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailSubject term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailHeader term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=250 ctermfg=51 gui=NONE guibg=#bebebe guifg=#00ffff
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=19 ctermfg=fg gui=NONE guibg=#00008b guifg=fg
    CSAHi DiffChange term=bold cterm=NONE ctermbg=127 ctermfg=fg gui=NONE guibg=#8b008b guifg=fg
    CSAHi DiffDelete term=bold cterm=bold ctermbg=37 ctermfg=21 gui=bold guibg=#008b8b guifg=#0000ff
    CSAHi DiffText term=reverse cterm=bold ctermbg=196 ctermfg=fg gui=bold guibg=#ff0000 guifg=fg
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=51 gui=NONE guibg=#bebebe guifg=#00ffff
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=196 gui=undercurl guibg=bg guifg=fg guisp=#ff0000
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=21 gui=undercurl guibg=bg guifg=fg guisp=#0000ff
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=201 gui=undercurl guibg=bg guifg=fg guisp=#ff00ff
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=51 gui=undercurl guibg=bg guifg=fg guisp=#00ffff
elseif has("gui_running") || (&t_Co == 256 && (&term ==# "xterm" || &term =~# "^screen") && exists("g:CSApprox_eterm") && g:CSApprox_eterm) || &term =~? "^eterm"
    CSAHi Normal term=NONE cterm=NONE ctermbg=234 ctermfg=254 gui=NONE guibg=#202020 guifg=#e2e2e5
    CSAHi cNumbersCom term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cParen term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cBracket term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cNumbers term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi Underlined term=underline cterm=underline ctermbg=bg ctermfg=153 gui=underline guibg=bg guifg=#80a0ff
    CSAHi Ignore term=NONE cterm=NONE ctermbg=bg ctermfg=234 gui=NONE guibg=bg guifg=#202020
    CSAHi Error term=reverse cterm=NONE ctermbg=196 ctermfg=255 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi Todo term=NONE cterm=NONE ctermbg=228 ctermfg=16 gui=italic guibg=#e6ea50 guifg=#000000
    CSAHi String term=NONE cterm=NONE ctermbg=bg ctermfg=191 gui=italic guibg=bg guifg=#b1d631
    CSAHi Number term=NONE cterm=NONE ctermbg=bg ctermfg=220 gui=NONE guibg=bg guifg=#ff9800
    CSAHi Boolean term=NONE cterm=NONE ctermbg=bg ctermfg=191 gui=NONE guibg=bg guifg=#b1d631
    CSAHi Function term=NONE cterm=bold ctermbg=bg ctermfg=255 gui=bold guibg=bg guifg=#ffffff
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=236 ctermfg=244 gui=NONE guibg=#343434 guifg=#808080
    CSAHi NonText term=bold cterm=NONE ctermbg=236 ctermfg=244 gui=NONE guibg=#303030 guifg=#808080
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=#00ffff
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=196 ctermfg=255 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=254 ctermfg=234 gui=reverse guibg=bg guifg=fg
    CSAHi Search term=reverse cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=72 gui=bold guibg=bg guifg=#2e8b57
    CSAHi ModeMsg term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi LineNr term=underline cterm=NONE ctermbg=16 ctermfg=244 gui=NONE guibg=#000000 guifg=#808080
    CSAHi mailEmail term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailSignature term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cBlock term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailQuoted2 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailQuoted3 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailQuoted4 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailQuoted5 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailQuoted6 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=238 ctermfg=255 gui=NONE guibg=#444444 guifg=#ffffff
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=191 ctermfg=16 gui=NONE guibg=#b1d631 guifg=#000000
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=250 ctermfg=fg gui=NONE guibg=#bebebe guifg=fg
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=254 ctermfg=234 gui=reverse guibg=bg guifg=fg
    CSAHi TabLine term=underline cterm=underline ctermbg=248 ctermfg=fg gui=underline guibg=#a9a9a9 guifg=fg
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=254 ctermfg=234 gui=reverse guibg=bg guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=59 ctermfg=fg gui=NONE guibg=#2d2d2d guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=59 ctermfg=fg gui=NONE guibg=#2d2d2d guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=241 ctermfg=fg gui=NONE guibg=#626262 guifg=fg
    CSAHi CursorIM term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailQuoted1 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi Keyword term=NONE cterm=NONE ctermbg=bg ctermfg=220 gui=NONE guibg=bg guifg=#ff9800
    CSAHi TypoMsg term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi Question term=NONE cterm=bold ctermbg=bg ctermfg=46 gui=bold guibg=bg guifg=#00ff00
    CSAHi StatusLine term=reverse,bold cterm=NONE ctermbg=238 ctermfg=231 gui=italic guibg=#444444 guifg=#d3d3d5
    CSAHi StatusLineNC term=reverse cterm=NONE ctermbg=238 ctermfg=246 gui=NONE guibg=#444444 guifg=#939395
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=238 ctermfg=238 gui=NONE guibg=#444444 guifg=#444444
    CSAHi Title term=bold cterm=bold ctermbg=bg ctermfg=231 gui=bold guibg=bg guifg=#f6f3e8
    CSAHi Visual term=reverse cterm=NONE ctermbg=66 ctermfg=231 gui=NONE guibg=#3c414c guifg=#faf4c6
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=bg ctermfg=196 gui=NONE guibg=bg guifg=#ff0000
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi Folded term=NONE cterm=NONE ctermbg=66 ctermfg=188 gui=NONE guibg=#384048 guifg=#a0a8b0
    CSAHi cUserCont term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cBitField term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cCppParen term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi lCursor term=NONE cterm=NONE ctermbg=254 ctermfg=234 gui=NONE guibg=#e2e2e5 guifg=#202020
    CSAHi MatchParen term=reverse cterm=bold ctermbg=236 ctermfg=231 gui=bold guibg=#2f2f2f guifg=#d0ffc0
    CSAHi Comment term=bold cterm=NONE ctermbg=bg ctermfg=244 gui=italic guibg=bg guifg=#808080
    CSAHi Constant term=underline cterm=NONE ctermbg=bg ctermfg=220 gui=NONE guibg=bg guifg=#ff9800
    CSAHi Special term=bold cterm=NONE ctermbg=bg ctermfg=220 gui=NONE guibg=bg guifg=#ff9800
    CSAHi Identifier term=underline cterm=NONE ctermbg=bg ctermfg=191 gui=NONE guibg=bg guifg=#b1d631
    CSAHi Statement term=bold cterm=NONE ctermbg=bg ctermfg=146 gui=NONE guibg=bg guifg=#7e8aa2
    CSAHi PreProc term=underline cterm=NONE ctermbg=bg ctermfg=231 gui=NONE guibg=bg guifg=#faf4c6
    CSAHi Type term=underline cterm=NONE ctermbg=bg ctermfg=146 gui=NONE guibg=bg guifg=#7e8aa2
    CSAHi cCppBracket term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cMulti term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi pythonOperator term=NONE cterm=NONE ctermbg=bg ctermfg=146 gui=NONE guibg=bg guifg=#7e8aa2
    CSAHi mailHeaderKey term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailSubject term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailHeader term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=250 ctermfg=51 gui=NONE guibg=#bebebe guifg=#00ffff
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=19 ctermfg=fg gui=NONE guibg=#00008b guifg=fg
    CSAHi DiffChange term=bold cterm=NONE ctermbg=127 ctermfg=fg gui=NONE guibg=#8b008b guifg=fg
    CSAHi DiffDelete term=bold cterm=bold ctermbg=37 ctermfg=21 gui=bold guibg=#008b8b guifg=#0000ff
    CSAHi DiffText term=reverse cterm=bold ctermbg=196 ctermfg=fg gui=bold guibg=#ff0000 guifg=fg
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=51 gui=NONE guibg=#bebebe guifg=#00ffff
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=196 gui=undercurl guibg=bg guifg=fg guisp=#ff0000
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=21 gui=undercurl guibg=bg guifg=fg guisp=#0000ff
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=201 gui=undercurl guibg=bg guifg=fg guisp=#ff00ff
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=51 gui=undercurl guibg=bg guifg=fg guisp=#00ffff
elseif has("gui_running") || &t_Co == 256
    CSAHi Normal term=NONE cterm=NONE ctermbg=234 ctermfg=254 gui=NONE guibg=#202020 guifg=#e2e2e5
    CSAHi cNumbersCom term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cParen term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cBracket term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cNumbers term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi Underlined term=underline cterm=underline ctermbg=bg ctermfg=111 gui=underline guibg=bg guifg=#80a0ff
    CSAHi Ignore term=NONE cterm=NONE ctermbg=bg ctermfg=234 gui=NONE guibg=bg guifg=#202020
    CSAHi Error term=reverse cterm=NONE ctermbg=196 ctermfg=231 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi Todo term=NONE cterm=NONE ctermbg=185 ctermfg=16 gui=italic guibg=#e6ea50 guifg=#000000
    CSAHi String term=NONE cterm=NONE ctermbg=bg ctermfg=149 gui=italic guibg=bg guifg=#b1d631
    CSAHi Number term=NONE cterm=NONE ctermbg=bg ctermfg=208 gui=NONE guibg=bg guifg=#ff9800
    CSAHi Boolean term=NONE cterm=NONE ctermbg=bg ctermfg=149 gui=NONE guibg=bg guifg=#b1d631
    CSAHi Function term=NONE cterm=bold ctermbg=bg ctermfg=231 gui=bold guibg=bg guifg=#ffffff
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=236 ctermfg=244 gui=NONE guibg=#343434 guifg=#808080
    CSAHi NonText term=bold cterm=NONE ctermbg=236 ctermfg=244 gui=NONE guibg=#303030 guifg=#808080
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=51 gui=NONE guibg=bg guifg=#00ffff
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=196 ctermfg=231 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=254 ctermfg=234 gui=reverse guibg=bg guifg=fg
    CSAHi Search term=reverse cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=29 gui=bold guibg=bg guifg=#2e8b57
    CSAHi ModeMsg term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi LineNr term=underline cterm=NONE ctermbg=16 ctermfg=244 gui=NONE guibg=#000000 guifg=#808080
    CSAHi mailEmail term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailSignature term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cBlock term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailQuoted2 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailQuoted3 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailQuoted4 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailQuoted5 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailQuoted6 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=238 ctermfg=231 gui=NONE guibg=#444444 guifg=#ffffff
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=149 ctermfg=16 gui=NONE guibg=#b1d631 guifg=#000000
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=250 ctermfg=fg gui=NONE guibg=#bebebe guifg=fg
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=254 ctermfg=234 gui=reverse guibg=bg guifg=fg
    CSAHi TabLine term=underline cterm=underline ctermbg=248 ctermfg=fg gui=underline guibg=#a9a9a9 guifg=fg
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=254 ctermfg=234 gui=reverse guibg=bg guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=236 ctermfg=fg gui=NONE guibg=#2d2d2d guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=236 ctermfg=fg gui=NONE guibg=#2d2d2d guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=241 ctermfg=fg gui=NONE guibg=#626262 guifg=fg
    CSAHi CursorIM term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailQuoted1 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi Keyword term=NONE cterm=NONE ctermbg=bg ctermfg=208 gui=NONE guibg=bg guifg=#ff9800
    CSAHi TypoMsg term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi Question term=NONE cterm=bold ctermbg=bg ctermfg=46 gui=bold guibg=bg guifg=#00ff00
    CSAHi StatusLine term=reverse,bold cterm=NONE ctermbg=238 ctermfg=188 gui=italic guibg=#444444 guifg=#d3d3d5
    CSAHi StatusLineNC term=reverse cterm=NONE ctermbg=238 ctermfg=246 gui=NONE guibg=#444444 guifg=#939395
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=238 ctermfg=238 gui=NONE guibg=#444444 guifg=#444444
    CSAHi Title term=bold cterm=bold ctermbg=bg ctermfg=230 gui=bold guibg=bg guifg=#f6f3e8
    CSAHi Visual term=reverse cterm=NONE ctermbg=59 ctermfg=230 gui=NONE guibg=#3c414c guifg=#faf4c6
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=bg ctermfg=196 gui=NONE guibg=bg guifg=#ff0000
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=226 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi Folded term=NONE cterm=NONE ctermbg=59 ctermfg=145 gui=NONE guibg=#384048 guifg=#a0a8b0
    CSAHi cUserCont term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cBitField term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cCppParen term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi lCursor term=NONE cterm=NONE ctermbg=254 ctermfg=234 gui=NONE guibg=#e2e2e5 guifg=#202020
    CSAHi MatchParen term=reverse cterm=bold ctermbg=236 ctermfg=193 gui=bold guibg=#2f2f2f guifg=#d0ffc0
    CSAHi Comment term=bold cterm=NONE ctermbg=bg ctermfg=244 gui=italic guibg=bg guifg=#808080
    CSAHi Constant term=underline cterm=NONE ctermbg=bg ctermfg=208 gui=NONE guibg=bg guifg=#ff9800
    CSAHi Special term=bold cterm=NONE ctermbg=bg ctermfg=208 gui=NONE guibg=bg guifg=#ff9800
    CSAHi Identifier term=underline cterm=NONE ctermbg=bg ctermfg=149 gui=NONE guibg=bg guifg=#b1d631
    CSAHi Statement term=bold cterm=NONE ctermbg=bg ctermfg=103 gui=NONE guibg=bg guifg=#7e8aa2
    CSAHi PreProc term=underline cterm=NONE ctermbg=bg ctermfg=230 gui=NONE guibg=bg guifg=#faf4c6
    CSAHi Type term=underline cterm=NONE ctermbg=bg ctermfg=103 gui=NONE guibg=bg guifg=#7e8aa2
    CSAHi cCppBracket term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cMulti term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi pythonOperator term=NONE cterm=NONE ctermbg=bg ctermfg=103 gui=NONE guibg=bg guifg=#7e8aa2
    CSAHi mailHeaderKey term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailSubject term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailHeader term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=250 ctermfg=51 gui=NONE guibg=#bebebe guifg=#00ffff
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=18 ctermfg=fg gui=NONE guibg=#00008b guifg=fg
    CSAHi DiffChange term=bold cterm=NONE ctermbg=90 ctermfg=fg gui=NONE guibg=#8b008b guifg=fg
    CSAHi DiffDelete term=bold cterm=bold ctermbg=30 ctermfg=21 gui=bold guibg=#008b8b guifg=#0000ff
    CSAHi DiffText term=reverse cterm=bold ctermbg=196 ctermfg=fg gui=bold guibg=#ff0000 guifg=fg
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=250 ctermfg=51 gui=NONE guibg=#bebebe guifg=#00ffff
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=196 gui=undercurl guibg=bg guifg=fg guisp=#ff0000
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=21 gui=undercurl guibg=bg guifg=fg guisp=#0000ff
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=201 gui=undercurl guibg=bg guifg=fg guisp=#ff00ff
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=51 gui=undercurl guibg=bg guifg=fg guisp=#00ffff
elseif has("gui_running") || &t_Co == 88
    CSAHi Normal term=NONE cterm=NONE ctermbg=80 ctermfg=87 gui=NONE guibg=#202020 guifg=#e2e2e5
    CSAHi cNumbersCom term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cParen term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cBracket term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cNumbers term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi Underlined term=underline cterm=underline ctermbg=bg ctermfg=39 gui=underline guibg=bg guifg=#80a0ff
    CSAHi Ignore term=NONE cterm=NONE ctermbg=bg ctermfg=80 gui=NONE guibg=bg guifg=#202020
    CSAHi Error term=reverse cterm=NONE ctermbg=64 ctermfg=79 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi Todo term=NONE cterm=NONE ctermbg=61 ctermfg=16 gui=italic guibg=#e6ea50 guifg=#000000
    CSAHi String term=NONE cterm=NONE ctermbg=bg ctermfg=56 gui=italic guibg=bg guifg=#b1d631
    CSAHi Number term=NONE cterm=NONE ctermbg=bg ctermfg=68 gui=NONE guibg=bg guifg=#ff9800
    CSAHi Boolean term=NONE cterm=NONE ctermbg=bg ctermfg=56 gui=NONE guibg=bg guifg=#b1d631
    CSAHi Function term=NONE cterm=bold ctermbg=bg ctermfg=79 gui=bold guibg=bg guifg=#ffffff
    CSAHi SpecialKey term=bold cterm=NONE ctermbg=80 ctermfg=83 gui=NONE guibg=#343434 guifg=#808080
    CSAHi NonText term=bold cterm=NONE ctermbg=80 ctermfg=83 gui=NONE guibg=#303030 guifg=#808080
    CSAHi Directory term=bold cterm=NONE ctermbg=bg ctermfg=31 gui=NONE guibg=bg guifg=#00ffff
    CSAHi ErrorMsg term=NONE cterm=NONE ctermbg=64 ctermfg=79 gui=NONE guibg=#ff0000 guifg=#ffffff
    CSAHi IncSearch term=reverse cterm=NONE ctermbg=87 ctermfg=80 gui=reverse guibg=bg guifg=fg
    CSAHi Search term=reverse cterm=NONE ctermbg=76 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi MoreMsg term=bold cterm=bold ctermbg=bg ctermfg=21 gui=bold guibg=bg guifg=#2e8b57
    CSAHi ModeMsg term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi LineNr term=underline cterm=NONE ctermbg=16 ctermfg=83 gui=NONE guibg=#000000 guifg=#808080
    CSAHi mailEmail term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailSignature term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cBlock term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailQuoted2 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailQuoted3 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailQuoted4 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailQuoted5 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailQuoted6 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi Pmenu term=NONE cterm=NONE ctermbg=80 ctermfg=79 gui=NONE guibg=#444444 guifg=#ffffff
    CSAHi PmenuSel term=NONE cterm=NONE ctermbg=56 ctermfg=16 gui=NONE guibg=#b1d631 guifg=#000000
    CSAHi PmenuSbar term=NONE cterm=NONE ctermbg=85 ctermfg=fg gui=NONE guibg=#bebebe guifg=fg
    CSAHi PmenuThumb term=NONE cterm=NONE ctermbg=87 ctermfg=80 gui=reverse guibg=bg guifg=fg
    CSAHi TabLine term=underline cterm=underline ctermbg=84 ctermfg=fg gui=underline guibg=#a9a9a9 guifg=fg
    CSAHi TabLineSel term=bold cterm=bold ctermbg=bg ctermfg=fg gui=bold guibg=bg guifg=fg
    CSAHi TabLineFill term=reverse cterm=NONE ctermbg=87 ctermfg=80 gui=reverse guibg=bg guifg=fg
    CSAHi CursorColumn term=reverse cterm=NONE ctermbg=80 ctermfg=fg gui=NONE guibg=#2d2d2d guifg=fg
    CSAHi CursorLine term=underline cterm=NONE ctermbg=80 ctermfg=fg gui=NONE guibg=#2d2d2d guifg=fg
    CSAHi Cursor term=NONE cterm=NONE ctermbg=81 ctermfg=fg gui=NONE guibg=#626262 guifg=fg
    CSAHi CursorIM term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailQuoted1 term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi Keyword term=NONE cterm=NONE ctermbg=bg ctermfg=68 gui=NONE guibg=bg guifg=#ff9800
    CSAHi TypoMsg term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi Question term=NONE cterm=bold ctermbg=bg ctermfg=28 gui=bold guibg=bg guifg=#00ff00
    CSAHi StatusLine term=reverse,bold cterm=NONE ctermbg=80 ctermfg=86 gui=italic guibg=#444444 guifg=#d3d3d5
    CSAHi StatusLineNC term=reverse cterm=NONE ctermbg=80 ctermfg=83 gui=NONE guibg=#444444 guifg=#939395
    CSAHi VertSplit term=reverse cterm=NONE ctermbg=80 ctermfg=80 gui=NONE guibg=#444444 guifg=#444444
    CSAHi Title term=bold cterm=bold ctermbg=bg ctermfg=79 gui=bold guibg=bg guifg=#f6f3e8
    CSAHi Visual term=reverse cterm=NONE ctermbg=17 ctermfg=78 gui=NONE guibg=#3c414c guifg=#faf4c6
    CSAHi VisualNOS term=bold,underline cterm=bold,underline ctermbg=bg ctermfg=fg gui=bold,underline guibg=bg guifg=fg
    CSAHi WarningMsg term=NONE cterm=NONE ctermbg=bg ctermfg=64 gui=NONE guibg=bg guifg=#ff0000
    CSAHi WildMenu term=NONE cterm=NONE ctermbg=76 ctermfg=16 gui=NONE guibg=#ffff00 guifg=#000000
    CSAHi Folded term=NONE cterm=NONE ctermbg=17 ctermfg=38 gui=NONE guibg=#384048 guifg=#a0a8b0
    CSAHi cUserCont term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cBitField term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cCppParen term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi lCursor term=NONE cterm=NONE ctermbg=87 ctermfg=80 gui=NONE guibg=#e2e2e5 guifg=#202020
    CSAHi MatchParen term=reverse cterm=bold ctermbg=80 ctermfg=62 gui=bold guibg=#2f2f2f guifg=#d0ffc0
    CSAHi Comment term=bold cterm=NONE ctermbg=bg ctermfg=83 gui=italic guibg=bg guifg=#808080
    CSAHi Constant term=underline cterm=NONE ctermbg=bg ctermfg=68 gui=NONE guibg=bg guifg=#ff9800
    CSAHi Special term=bold cterm=NONE ctermbg=bg ctermfg=68 gui=NONE guibg=bg guifg=#ff9800
    CSAHi Identifier term=underline cterm=NONE ctermbg=bg ctermfg=56 gui=NONE guibg=bg guifg=#b1d631
    CSAHi Statement term=bold cterm=NONE ctermbg=bg ctermfg=37 gui=NONE guibg=bg guifg=#7e8aa2
    CSAHi PreProc term=underline cterm=NONE ctermbg=bg ctermfg=78 gui=NONE guibg=bg guifg=#faf4c6
    CSAHi Type term=underline cterm=NONE ctermbg=bg ctermfg=37 gui=NONE guibg=bg guifg=#7e8aa2
    CSAHi cCppBracket term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi cMulti term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi pythonOperator term=NONE cterm=NONE ctermbg=bg ctermfg=37 gui=NONE guibg=bg guifg=#7e8aa2
    CSAHi mailHeaderKey term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailSubject term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi mailHeader term=NONE cterm=NONE ctermbg=bg ctermfg=fg gui=NONE guibg=bg guifg=fg
    CSAHi FoldColumn term=NONE cterm=NONE ctermbg=85 ctermfg=31 gui=NONE guibg=#bebebe guifg=#00ffff
    CSAHi DiffAdd term=bold cterm=NONE ctermbg=17 ctermfg=fg gui=NONE guibg=#00008b guifg=fg
    CSAHi DiffChange term=bold cterm=NONE ctermbg=33 ctermfg=fg gui=NONE guibg=#8b008b guifg=fg
    CSAHi DiffDelete term=bold cterm=bold ctermbg=21 ctermfg=19 gui=bold guibg=#008b8b guifg=#0000ff
    CSAHi DiffText term=reverse cterm=bold ctermbg=64 ctermfg=fg gui=bold guibg=#ff0000 guifg=fg
    CSAHi SignColumn term=NONE cterm=NONE ctermbg=85 ctermfg=31 gui=NONE guibg=#bebebe guifg=#00ffff
    CSAHi SpellBad term=reverse cterm=undercurl ctermbg=bg ctermfg=64 gui=undercurl guibg=bg guifg=fg guisp=#ff0000
    CSAHi SpellCap term=reverse cterm=undercurl ctermbg=bg ctermfg=19 gui=undercurl guibg=bg guifg=fg guisp=#0000ff
    CSAHi SpellRare term=reverse cterm=undercurl ctermbg=bg ctermfg=67 gui=undercurl guibg=bg guifg=fg guisp=#ff00ff
    CSAHi SpellLocal term=underline cterm=undercurl ctermbg=bg ctermfg=31 gui=undercurl guibg=bg guifg=fg guisp=#00ffff
endif

if 1
    delcommand CSAHi
endif
