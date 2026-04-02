if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'octo') ==# -1
    call add(g:edge_loaded_file_types, 'octo')
else
    finish
endif
let s:configuration = edge#get_configuration()
let s:palette = edge#get_palette(s:configuration.style, s:configuration.dim_foreground, s:configuration.colors_override)
" syn_begin: octo {{{
" https://github.com/pwntester/octo.nvim
call edge#highlight('OctoViewer', s:palette.bg0, s:palette.blue)
call edge#highlight('OctoGreenFloat', s:palette.green, s:palette.bg2)
call edge#highlight('OctoRedFloat', s:palette.red, s:palette.bg2)
call edge#highlight('OctoPurpleFloat', s:palette.purple, s:palette.bg2)
call edge#highlight('OctoYellowFloat', s:palette.yellow, s:palette.bg2)
call edge#highlight('OctoBlueFloat', s:palette.blue, s:palette.bg2)
call edge#highlight('OctoGreyFloat', s:palette.grey, s:palette.bg2)
call edge#highlight('OctoBubbleGreen', s:palette.bg0, s:palette.green)
call edge#highlight('OctoBubbleRed', s:palette.bg0, s:palette.red)
call edge#highlight('OctoBubblePurple', s:palette.bg0, s:palette.purple)
call edge#highlight('OctoBubbleYellow', s:palette.bg0, s:palette.yellow)
call edge#highlight('OctoBubbleBlue', s:palette.bg0, s:palette.blue)
call edge#highlight('OctoBubbleGrey', s:palette.bg0, s:palette.grey)
highlight! link OctoGreen Green
highlight! link OctoRed Red
highlight! link OctoPurple Purple
highlight! link OctoYellow Yellow
highlight! link OctoBlue Blue
highlight! link OctoGrey Grey
highlight! link OctoBubbleDelimiterGreen Green
highlight! link OctoBubbleDelimiterRed Red
highlight! link OctoBubbleDelimiterPurple Purple
highlight! link OctoBubbleDelimiterYellow Yellow
highlight! link OctoBubbleDelimiterBlue Blue
highlight! link OctoBubbleDelimiterGrey Grey
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
