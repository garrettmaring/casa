if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'ps1') ==# -1
    call add(g:edge_loaded_file_types, 'ps1')
else
    finish
endif
" syn_begin: ps1 {{{
" vim-ps1: https://github.com/PProvost/vim-ps1{{{
highlight! link ps1FunctionInvocation Blue
highlight! link ps1FunctionDeclaration Blue
highlight! link ps1InterpolationDelimiter Yellow
highlight! link ps1BuiltIn RedItalic
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
