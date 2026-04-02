if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'swift') ==# -1
    call add(g:edge_loaded_file_types, 'swift')
else
    finish
endif
" syn_begin: swift {{{
" swift.vim: https://github.com/keith/swift.vim{{{
highlight! link swiftInterpolatedWrapper Yellow
highlight! link swiftInterpolatedString Yellow
highlight! link swiftProperty Fg
highlight! link swiftTypeDeclaration Purple
highlight! link swiftClosureArgument CyanItalic
highlight! link swiftStructure Purple
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
