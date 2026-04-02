if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'elixir') ==# -1
    call add(g:edge_loaded_file_types, 'elixir')
else
    finish
endif
" syn_begin: elixir {{{
" vim-elixir: https://github.com/elixir-editors/vim-elixir{{{
highlight! link elixirStringDelimiter Green
highlight! link elixirKeyword Purple
highlight! link elixirInterpolation Yellow
highlight! link elixirInterpolationDelimiter Yellow
highlight! link elixirSelf RedItalic
highlight! link elixirPseudoVariable CyanItalic
highlight! link elixirModuleDefine Purple
highlight! link elixirBlockDefinition Purple
highlight! link elixirDefine Purple
highlight! link elixirPrivateDefine Purple
highlight! link elixirGuard Purple
highlight! link elixirPrivateGuard Purple
highlight! link elixirProtocolDefine Purple
highlight! link elixirImplDefine Purple
highlight! link elixirRecordDefine Purple
highlight! link elixirPrivateRecordDefine Purple
highlight! link elixirMacroDefine Purple
highlight! link elixirPrivateMacroDefine Purple
highlight! link elixirDelegateDefine Purple
highlight! link elixirOverridableDefine Purple
highlight! link elixirExceptionDefine Purple
highlight! link elixirCallbackDefine Purple
highlight! link elixirStructDefine Purple
highlight! link elixirExUnitMacro Purple
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
