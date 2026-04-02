if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'scala') ==# -1
    call add(g:edge_loaded_file_types, 'scala')
else
    finish
endif
" syn_begin: scala {{{
" builtin: https://github.com/derekwyatt/vim-scala{{{
highlight! link scalaNameDefinition Fg
highlight! link scalaInterpolationBoundary Yellow
highlight! link scalaInterpolation Yellow
highlight! link scalaTypeOperator Purple
highlight! link scalaOperator Purple
highlight! link scalaKeywordModifier Purple
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
