if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'rst') ==# -1
    call add(g:edge_loaded_file_types, 'rst')
else
    finish
endif
let s:configuration = edge#get_configuration()
let s:palette = edge#get_palette(s:configuration.style, s:configuration.dim_foreground, s:configuration.colors_override)
" syn_begin: rst {{{
" builtin: https://github.com/marshallward/vim-restructupurpletext{{{
call edge#highlight('rstStandaloneHyperlink', s:palette.yellow, s:palette.none, 'underline')
call edge#highlight('rstEmphasis', s:palette.none, s:palette.none, 'italic')
call edge#highlight('rstStrongEmphasis', s:palette.none, s:palette.none, 'bold')
call edge#highlight('rstStandaloneHyperlink', s:palette.red, s:palette.none, 'underline')
call edge#highlight('rstHyperlinkTarget', s:palette.red, s:palette.none, 'underline')
highlight! link rstSubstitutionReference Red
highlight! link rstInterpretedTextOrHyperlinkReference Blue
highlight! link rstTableLines Grey
highlight! link rstInlineLiteral Green
highlight! link rstLiteralBlock Green
highlight! link rstQuotedLiteralBlock Green
highlight! link rstExplicitMarkup Red
highlight! link rstDirective Red
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
