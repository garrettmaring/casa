if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'vim') ==# -1
    call add(g:edge_loaded_file_types, 'vim')
else
    finish
endif
let s:configuration = edge#get_configuration()
let s:palette = edge#get_palette(s:configuration.style, s:configuration.dim_foreground, s:configuration.colors_override)
" syn_begin: vim {{{
call edge#highlight('vimCommentTitle', s:palette.grey, s:palette.none, 'bold')
highlight! link vimLet Purple
highlight! link vimFunction Blue
highlight! link vimIsCommand Fg
highlight! link vimUserFunc Blue
highlight! link vimFuncName Blue
highlight! link vimMap Purple
highlight! link vimMapModKey Red
highlight! link vimNotation Red
highlight! link vimMapLhs Blue
highlight! link vimMapRhs Blue
highlight! link vimOption CyanItalic
highlight! link vimUserAttrbKey RedItalic
highlight! link vimUserAttrb Blue
highlight! link vimSynType CyanItalic
highlight! link vimHiBang Purple
highlight! link vimSet Yellow
highlight! link vimSetEqual Yellow
highlight! link vimSetSep Grey
highlight! link vimVar Fg
highlight! link vimFuncVar Fg
highlight! link vimContinue Grey
highlight! link vimAutoCmdSfxList CyanItalic
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
