if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'make') ==# -1
    call add(g:edge_loaded_file_types, 'make')
else
    finish
endif
" syn_begin: make {{{
highlight! link makeIdent Yellow
highlight! link makeSpecTarget RedItalic
highlight! link makeTarget Cyan
highlight! link makeCommands Purple
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
