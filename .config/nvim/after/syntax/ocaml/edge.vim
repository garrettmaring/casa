if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'ocaml') ==# -1
    call add(g:edge_loaded_file_types, 'ocaml')
else
    finish
endif
" syn_begin: ocaml {{{
" builtin: https://github.com/rgrinberg/vim-ocaml{{{
highlight! link ocamlArrow Purple
highlight! link ocamlEqual Purple
highlight! link ocamlOperator Purple
highlight! link ocamlKeyChar Purple
highlight! link ocamlModPath Blue
highlight! link ocamlFullMod Blue
highlight! link ocamlModule RedItalic
highlight! link ocamlConstructor Cyan
highlight! link ocamlModParam Fg
highlight! link ocamlModParam1 Fg
highlight! link ocamlAnyVar Fg " aqua
highlight! link ocamlPpxEncl Purple
highlight! link ocamlPpxIdentifier Fg
highlight! link ocamlSigEncl Purple
highlight! link ocamlModParam1 Fg
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
