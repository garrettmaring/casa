if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'toml') ==# -1
    call add(g:edge_loaded_file_types, 'toml')
else
    finish
endif
let s:configuration = edge#get_configuration()
let s:palette = edge#get_palette(s:configuration.style, s:configuration.dim_foreground, s:configuration.colors_override)
" syn_begin: toml {{{
call edge#highlight('tomlTable', s:palette.purple, s:palette.none, 'bold')
highlight! link tomlKey Red
highlight! link tomlBoolean Yellow
highlight! link tomlString Green
highlight! link tomlTableArray tomlTable
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
