if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'lisp') ==# -1
    call add(g:edge_loaded_file_types, 'lisp')
else
    finish
endif
" syn_begin: lisp {{{
" builtin: http://www.drchip.org/astronaut/vim/index.html#SYNTAX_LISP{{{
highlight! link lispAtomMark Yellow
highlight! link lispKey Cyan
highlight! link lispFunc Blue
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
