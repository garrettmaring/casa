if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'cs') ==# -1
    call add(g:edge_loaded_file_types, 'cs')
else
    finish
endif
" syn_begin: cs {{{
" builtin: https://github.com/nickspoons/vim-cs{{{
highlight! link csUnspecifiedStatement Purple
highlight! link csStorage Purple
highlight! link csClass Purple
highlight! link csNewType RedItalic
highlight! link csContextualStatement Purple
highlight! link csInterpolationDelimiter Yellow
highlight! link csInterpolation Yellow
highlight! link csEndColon Fg
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
