if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'matlab') ==# -1
    call add(g:edge_loaded_file_types, 'matlab')
else
    finish
endif
" syn_begin: matlab {{{
" builtin: {{{
highlight! link matlabSemicolon Fg
highlight! link matlabFunction PurpleItalic
highlight! link matlabImplicit Blue
highlight! link matlabDelimiter Fg
highlight! link matlabOperator Blue
highlight! link matlabArithmeticOperator Purple
highlight! link matlabArithmeticOperator Purple
highlight! link matlabRelationalOperator Purple
highlight! link matlabRelationalOperator Purple
highlight! link matlabLogicalOperator Purple
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
