if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'gitcommit') ==# -1
    call add(g:edge_loaded_file_types, 'gitcommit')
else
    finish
endif
" syn_begin: gitcommit {{{
" builtin {{{
highlight! link gitcommitSummary Purple
highlight! link gitcommitUntracked Grey
highlight! link gitcommitDiscarded Grey
highlight! link gitcommitSelected Grey
highlight! link gitcommitUnmerged Grey
highlight! link gitcommitOnBranch Grey
highlight! link gitcommitArrow Grey
highlight! link gitcommitFile Blue
" }}}
" nvim-treesitter/nvim-treesitter {{{
if has('nvim-0.8')
  highlight! link @text.gitcommit TSNone
endif
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
