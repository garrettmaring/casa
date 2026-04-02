if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'vimwiki') ==# -1
    call add(g:edge_loaded_file_types, 'vimwiki')
else
    finish
endif
let s:configuration = edge#get_configuration()
let s:palette = edge#get_palette(s:configuration.style, s:configuration.dim_foreground, s:configuration.colors_override)
" syn_begin: vimwiki {{{
call edge#highlight('VimwikiHeader1', s:palette.purple, s:palette.none, 'bold')
call edge#highlight('VimwikiHeader2', s:palette.red, s:palette.none, 'bold')
call edge#highlight('VimwikiHeader3', s:palette.blue, s:palette.none, 'bold')
call edge#highlight('VimwikiHeader4', s:palette.yellow, s:palette.none, 'bold')
call edge#highlight('VimwikiHeader5', s:palette.green, s:palette.none, 'bold')
call edge#highlight('VimwikiHeader6', s:palette.cyan, s:palette.none, 'bold')
call edge#highlight('VimwikiLink', s:palette.blue, s:palette.none, 'underline')
call edge#highlight('VimwikiItalic', s:palette.none, s:palette.none, 'italic')
call edge#highlight('VimwikiBold', s:palette.none, s:palette.none, 'bold')
call edge#highlight('VimwikiUnderline', s:palette.none, s:palette.none, 'underline')
highlight! link VimwikiList Red
highlight! link VimwikiTag Purple
highlight! link VimwikiCode Green
highlight! link VimwikiHR Yellow
highlight! link VimwikiHeaderChar Grey
highlight! link VimwikiMarkers Grey
highlight! link VimwikiPre Green
highlight! link VimwikiPreDelim Green
highlight! link VimwikiNoExistsLink Red
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
