if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'lua') ==# -1
    call add(g:edge_loaded_file_types, 'lua')
else
    finish
endif
" syn_begin: lua {{{
" builtin: {{{
highlight! link luaFunc Blue
highlight! link luaFunction Purple
highlight! link luaTable Fg
highlight! link luaIn Purple
" }}}
" vim-lua: https://github.com/tbastos/vim-lua {{{
highlight! link luaFuncCall Blue
highlight! link luaLocal Purple
highlight! link luaSpecialValue Blue
highlight! link luaBraces Fg
highlight! link luaBuiltIn RedItalic
highlight! link luaNoise Grey
highlight! link luaLabel Yellow
highlight! link luaFuncTable RedItalic
highlight! link luaFuncArgName Fg
highlight! link luaEllipsis Purple
highlight! link luaDocTag Blue
" }}}
" nvim-treesitter/nvim-treesitter {{{
highlight! link luaTSConstructor luaBraces
if has('nvim-0.8')
  highlight! link @constructor.lua luaTSConstructor
endif
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
