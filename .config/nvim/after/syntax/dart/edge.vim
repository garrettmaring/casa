if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'dart') ==# -1
    call add(g:edge_loaded_file_types, 'dart')
else
    finish
endif
" syn_begin: dart {{{
" dart-lang: https://github.com/dart-lang/dart-vim-plugin{{{
highlight! link dartCoreClasses RedItalic
highlight! link dartTypeName RedItalic
highlight! link dartInterpolation Yellow
highlight! link dartTypeDef Purple
highlight! link dartClassDecl Purple
highlight! link dartLibrary Purple
highlight! link dartMetadata CyanItalic
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
