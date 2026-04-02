if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'xml') ==# -1
    call add(g:edge_loaded_file_types, 'xml')
else
    finish
endif
" syn_begin: xml {{{
" builtin: https://github.com/chrisbra/vim-xml-ftplugin{{{
highlight! link xmlTag Purple
highlight! link xmlEndTag Purple
highlight! link xmlTagName PurpleItalic
highlight! link xmlEqual Blue
highlight! link xmlAttrib Red
highlight! link xmlEntity Purple
highlight! link xmlEntityPunct Purple
highlight! link xmlDocTypeDecl Grey
highlight! link xmlDocTypeKeyword PurpleItalic
highlight! link xmlCdataStart Grey
highlight! link xmlCdataCdata Yellow
highlight! link xmlString Green
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
