if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'java') ==# -1
    call add(g:edge_loaded_file_types, 'java')
else
    finish
endif
" syn_begin: java {{{
" builtin: {{{
highlight! link javaClassDecl Purple
highlight! link javaMethodDecl Purple
highlight! link javaVarArg Fg
highlight! link javaAnnotation Yellow
highlight! link javaUserLabel Yellow
highlight! link javaTypedef CyanItalic
highlight! link javaParen Fg
highlight! link javaParen1 Fg
highlight! link javaParen2 Fg
highlight! link javaParen3 Fg
highlight! link javaParen4 Fg
highlight! link javaParen5 Fg
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
