if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'html') ==# -1
    call add(g:edge_loaded_file_types, 'html')
else
    finish
endif
let s:configuration = edge#get_configuration()
let s:palette = edge#get_palette(s:configuration.style, s:configuration.dim_foreground, s:configuration.colors_override)
" syn_begin: html/markdown/javascriptreact/typescriptreact {{{
" builtin: https://notabug.org/jorgesumle/vim-html-syntax{{{
call edge#highlight('htmlH1', s:palette.purple, s:palette.none, 'bold')
call edge#highlight('htmlH2', s:palette.red, s:palette.none, 'bold')
call edge#highlight('htmlH3', s:palette.blue, s:palette.none, 'bold')
call edge#highlight('htmlH4', s:palette.yellow, s:palette.none, 'bold')
call edge#highlight('htmlH5', s:palette.green, s:palette.none, 'bold')
call edge#highlight('htmlH6', s:palette.cyan, s:palette.none, 'bold')
call edge#highlight('htmlLink', s:palette.none, s:palette.none, 'underline')
call edge#highlight('htmlBold', s:palette.none, s:palette.none, 'bold')
call edge#highlight('htmlBoldUnderline', s:palette.none, s:palette.none, 'bold,underline')
call edge#highlight('htmlBoldItalic', s:palette.none, s:palette.none, 'bold,italic')
call edge#highlight('htmlBoldUnderlineItalic', s:palette.none, s:palette.none, 'bold,underline,italic')
call edge#highlight('htmlUnderline', s:palette.none, s:palette.none, 'underline')
call edge#highlight('htmlUnderlineItalic', s:palette.none, s:palette.none, 'underline,italic')
call edge#highlight('htmlItalic', s:palette.none, s:palette.none, 'italic')
highlight! link htmlTag Purple
highlight! link htmlEndTag Purple
highlight! link htmlTagN PurpleItalic
highlight! link htmlTagName PurpleItalic
highlight! link htmlArg Red
highlight! link htmlScriptTag Blue
highlight! link htmlSpecialTagName PurpleItalic
highlight! link htmlString Green
" }}}
" nvim-treesitter/nvim-treesitter {{{
highlight! link htmlTSText TSNone
if has('nvim-0.8')
  highlight! link @text.html htmlTSText
endif
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
