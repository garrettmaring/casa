if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'php') ==# -1
    call add(g:edge_loaded_file_types, 'php')
else
    finish
endif
" syn_begin: php {{{
" builtin: https://jasonwoof.com/gitweb/?p=vim-syntax.git;a=blob;f=php.vim;hb=HEAD{{{
highlight! link phpVarSelector Fg
highlight! link phpIdentifier Fg
highlight! link phpDefine Blue
highlight! link phpStructure Purple
highlight! link phpSpecialFunction Blue
highlight! link phpInterpSimpleCurly Yellow
highlight! link phpComparison Purple
highlight! link phpMethodsVar Fg
highlight! link phpInterpVarname Fg
highlight! link phpMemberSelector Purple
highlight! link phpLabel Purple
" }}}
" php.vim: https://github.com/StanAngeloff/php.vim{{{
highlight! link phpParent Fg
highlight! link phpNowDoc Green
highlight! link phpFunction Blue
highlight! link phpMethod Blue
highlight! link phpClass RedItalic
highlight! link phpSuperglobals RedItalic
highlight! link phpNullValue YellowItalic
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
