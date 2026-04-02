if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'vim-plug') ==# -1
    call add(g:edge_loaded_file_types, 'vim-plug')
else
    finish
endif
let s:configuration = edge#get_configuration()
let s:palette = edge#get_palette(s:configuration.style, s:configuration.dim_foreground, s:configuration.colors_override)
" syn_begin: vim-plug {{{
" https://github.com/junegunn/vim-plug
call edge#highlight('plug1', s:palette.purple, s:palette.none, 'bold')
call edge#highlight('plugNumber', s:palette.green, s:palette.none, 'bold')
highlight! link plug2 Cyan
highlight! link plugBracket Blue
highlight! link plugName Green
highlight! link plugDash Blue
highlight! link plugNotLoaded Grey
highlight! link plugH2 Blue
highlight! link plugMessage Blue
highlight! link plugError Red
highlight! link plugRelDate Grey
highlight! link plugStar Purple
highlight! link plugUpdate Cyan
highlight! link plugDeleted Grey
highlight! link plugEdge Purple
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
