if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'rust') ==# -1
    call add(g:edge_loaded_file_types, 'rust')
else
    finish
endif
" syn_begin: rust {{{
" builtin: https://github.com/rust-lang/rust.vim{{{
highlight! link rustStructure Purple
highlight! link rustIdentifier CyanItalic
highlight! link rustModPath RedItalic
highlight! link rustModPathSep Grey
highlight! link rustSelf YellowItalic
highlight! link rustSuper YellowItalic
highlight! link rustDeriveTrait Yellow
highlight! link rustEnumVariant Yellow
highlight! link rustMacroVariable CyanItalic
highlight! link rustAssert Blue
highlight! link rustPanic Blue
highlight! link rustPubScopeCrate RedItalic
highlight! link rustAttribute Purple
" }}}
" coc-rust-analyzer: https://github.com/fannheyward/coc-rust-analyzer {{{
highlight! link CocRustChainingHint Grey
highlight! link CocRustTypeHint Grey
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
