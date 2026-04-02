if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'haskell') ==# -1
    call add(g:edge_loaded_file_types, 'haskell')
else
    finish
endif
" syn_begin: haskell {{{
" haskell-vim: https://github.com/neovimhaskell/haskell-vim{{{
highlight! link haskellBrackets Fg
highlight! link haskellIdentifier Yellow
highlight! link haskellDecl Purple
highlight! link haskellType RedItalic
highlight! link haskellDeclKeyword Purple
highlight! link haskellWhere Purple
highlight! link haskellDeriving Purple
highlight! link haskellForeignKeywords Purple
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
