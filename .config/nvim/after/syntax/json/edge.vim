if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'json') ==# -1
    call add(g:edge_loaded_file_types, 'json')
else
    finish
endif
" syn_begin: json {{{
highlight! link jsonKeyword Purple
highlight! link jsonString Green
highlight! link jsonBoolean Red
highlight! link jsonNoise Grey
highlight! link jsonQuote Grey
highlight! link jsonBraces Fg
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
