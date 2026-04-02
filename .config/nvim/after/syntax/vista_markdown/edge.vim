if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'vista_markdown') ==# -1
    call add(g:edge_loaded_file_types, 'vista_markdown')
else
    finish
endif
" syn_begin: vista/vista_kind/vista_markdown {{{
" https://github.com/liuchengxu/vista.vim
highlight! link VistaBracket Grey
highlight! link VistaChildrenNr Yellow
highlight! link VistaScope Red
highlight! link VistaTag Green
highlight! link VistaPrefix Grey
highlight! link VistaColon Green
highlight! link VistaIcon Purple
highlight! link VistaLineNr Fg
highlight! link VistaScopeKind Green
highlight! link VistaHeadNr Fg
highlight! link VistaPublic Blue
highlight! link VistaProtected Green
highlight! link VistaPrivate Purple
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
