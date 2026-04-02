if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'octave') ==# -1
    call add(g:edge_loaded_file_types, 'octave')
else
    finish
endif
" syn_begin: octave {{{
" vim-octave: https://github.com/McSinyx/vim-octave{{{
highlight! link octaveDelimiter Fg
highlight! link octaveSemicolon Grey
highlight! link octaveOperator Purple
highlight! link octaveVariable YellowItalic
highlight! link octaveVarKeyword YellowItalic
highlight! link octaveUserVar RedItalic
highlight! link octaveQueryVar RedItalic
highlight! link octaveSetVar RedItalic
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
