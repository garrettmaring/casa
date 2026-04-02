if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'erlang') ==# -1
    call add(g:edge_loaded_file_types, 'erlang')
else
    finish
endif
" syn_begin: erlang {{{
" builtin: https://github.com/vim-erlang/vim-erlang-runtime{{{
highlight! link erlangAtom Fg
highlight! link erlangVariable Fg
highlight! link erlangLocalFuncRef Blue
highlight! link erlangLocalFuncCall Blue
highlight! link erlangGlobalFuncRef Blue
highlight! link erlangGlobalFuncCall Blue
highlight! link erlangAttribute RedItalic
highlight! link erlangPipe Purple
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
