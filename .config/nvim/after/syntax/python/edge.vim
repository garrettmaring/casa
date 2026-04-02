if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'python') ==# -1
    call add(g:edge_loaded_file_types, 'python')
else
    finish
endif
let s:configuration = edge#get_configuration()
let s:palette = edge#get_palette(s:configuration.style, s:configuration.dim_foreground, s:configuration.colors_override)
" syn_begin: python {{{
" builtin: {{{
highlight! link pythonBuiltin RedItalic
highlight! link pythonExceptions Purple
highlight! link pythonDecoratorName CyanItalic
" }}}
" python-syntax: https://github.com/vim-python/python-syntax{{{
highlight! link pythonExClass RedItalic
highlight! link pythonBuiltinType Yellow
highlight! link pythonBuiltinObj Yellow
highlight! link pythonDottedName CyanItalic
highlight! link pythonBuiltinFunc Blue
highlight! link pythonFunction Blue
highlight! link pythonDecorator CyanItalic
highlight! link pythonInclude Include
highlight! link pythonImport PreProc
highlight! link pythonOperator Purple
highlight! link pythonConditional Purple
highlight! link pythonRepeat Purple
highlight! link pythonException Purple
highlight! link pythonNone Yellow
highlight! link pythonClassVar RedItalic
highlight! link pythonCoding Grey
highlight! link pythonDot Grey
" }}}
" semshi: https://github.com/numirias/semshi{{{
call edge#highlight('semshiUnresolved', s:palette.cyan, s:palette.none, 'undercurl')
highlight! link semshiImported TSInclude
highlight! link semshiParameter TSParameter
highlight! link semshiParameterUnused Grey
highlight! link semshiSelf TSVariableBuiltin
highlight! link semshiGlobal TSType
highlight! link semshiBuiltin TSTypeBuiltin
highlight! link semshiAttribute TSAttribute
highlight! link semshiLocal TSKeyword
highlight! link semshiFree TSKeyword
highlight! link semshiSelected CurrentWord
highlight! link semshiErrorSign RedSign
highlight! link semshiErrorChar RedSign
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
