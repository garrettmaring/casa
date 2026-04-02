if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'help') ==# -1
    call add(g:edge_loaded_file_types, 'help')
else
    finish
endif
let s:configuration = edge#get_configuration()
let s:palette = edge#get_palette(s:configuration.style, s:configuration.dim_foreground, s:configuration.colors_override)
" syn_begin: help {{{
call edge#highlight('helpNote', s:palette.yellow, s:palette.none, 'bold')
call edge#highlight('helpHeadline', s:palette.purple, s:palette.none, 'bold')
call edge#highlight('helpHeader', s:palette.blue, s:palette.none, 'bold')
call edge#highlight('helpURL', s:palette.blue, s:palette.none, 'underline')
call edge#highlight('helpHyperTextEntry', s:palette.red, s:palette.none, 'bold')
highlight! link helpHyperTextJump Red
highlight! link helpCommand Cyan
highlight! link helpExample Green
highlight! link helpSpecial Yellow
highlight! link helpSectionDelim Grey
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
