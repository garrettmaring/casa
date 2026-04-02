if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'startify') ==# -1
    call add(g:edge_loaded_file_types, 'startify')
else
    finish
endif
" syn_begin: startify/quickmenu {{{
" https://github.com/mhinz/vim-startify
" https://github.com/skywind3000/quickmenu.vim
highlight! link StartifyBracket Grey
highlight! link StartifyFile Fg
highlight! link StartifyNumber Red
highlight! link StartifyPath Green
highlight! link StartifySlash Green
highlight! link StartifySection Blue
highlight! link StartifyHeader Purple
highlight! link StartifySpecial Grey
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
