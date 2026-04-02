if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'go') ==# -1
    call add(g:edge_loaded_file_types, 'go')
else
    finish
endif
" syn_begin: go {{{
" builtin: https://github.com/google/vim-ft-go{{{
highlight! link goDirective Purple
highlight! link goConstants YellowItalic
highlight! link goDeclType Purple
" }}}
" polyglot: {{{
highlight! link goPackage Purple
highlight! link goImport Purple
highlight! link goBuiltins Blue
highlight! link goPpurpleefinedIdentifiers CyanItalic
highlight! link goPredefinedIdentifiers Yellow
highlight! link goVar Purple
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
