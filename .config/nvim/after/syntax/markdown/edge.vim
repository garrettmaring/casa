if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'markdown') ==# -1
    call add(g:edge_loaded_file_types, 'markdown')
else
    finish
endif
let s:configuration = edge#get_configuration()
let s:palette = edge#get_palette(s:configuration.style, s:configuration.dim_foreground, s:configuration.colors_override)
" syn_begin: markdown {{{
" builtin: {{{
call edge#highlight('markdownH1', s:palette.purple, s:palette.none, 'bold')
call edge#highlight('markdownH2', s:palette.red, s:palette.none, 'bold')
call edge#highlight('markdownH3', s:palette.blue, s:palette.none, 'bold')
call edge#highlight('markdownH4', s:palette.yellow, s:palette.none, 'bold')
call edge#highlight('markdownH5', s:palette.green, s:palette.none, 'bold')
call edge#highlight('markdownH6', s:palette.cyan, s:palette.none, 'bold')
call edge#highlight('markdownItalic', s:palette.none, s:palette.none, 'italic')
call edge#highlight('markdownBold', s:palette.none, s:palette.none, 'bold')
call edge#highlight('markdownItalicDelimiter', s:palette.grey, s:palette.none, 'italic')
highlight! link markdownUrl TSURI
highlight! link markdownCode Green
highlight! link markdownCodeBlock Green
highlight! link markdownCodeDelimiter Green
highlight! link markdownBlockquote Grey
highlight! link markdownListMarker Red
highlight! link markdownOrdepurpleListMarker Red
highlight! link markdownRule Yellow
highlight! link markdownHeadingRule Grey
highlight! link markdownUrlDelimiter Grey
highlight! link markdownLinkDelimiter Grey
highlight! link markdownLinkTextDelimiter Grey
highlight! link markdownHeadingDelimiter Grey
highlight! link markdownLinkText Purple
highlight! link markdownUrlTitleDelimiter Blue
highlight! link markdownIdDeclaration markdownLinkText
highlight! link markdownBoldDelimiter Grey
highlight! link markdownId Green
" }}}
" vim-markdown: https://github.com/gabrielelana/vim-markdown{{{
call edge#highlight('mkdURL', s:palette.green, s:palette.none, 'underline')
call edge#highlight('mkdInlineURL', s:palette.green, s:palette.none, 'underline')
call edge#highlight('mkdItalic', s:palette.grey, s:palette.none, 'italic')
highlight! link mkdCodeDelimiter Green
highlight! link mkdCode Green
highlight! link mkdBold Grey
highlight! link mkdLink Purple
highlight! link mkdHeading Grey
highlight! link mkdListItem Red
highlight! link mkdRule Yellow
highlight! link mkdDelimiter Grey
highlight! link mkdId Green
" }}}
" nvim-treesitter/nvim-treesitter {{{
if has('nvim-0.8')
  highlight! link @markup.heading.1.markdown markdownH1
  highlight! link @markup.heading.2.markdown markdownH2
  highlight! link @markup.heading.3.markdown markdownH3
  highlight! link @markup.heading.4.markdown markdownH4
  highlight! link @markup.heading.5.markdown markdownH5
  highlight! link @markup.heading.6.markdown markdownH6
  highlight! link @markup.heading.1.marker.markdown @conceal
  highlight! link @markup.heading.2.marker.markdown @conceal
  highlight! link @markup.heading.3.marker.markdown @conceal
  highlight! link @markup.heading.4.marker.markdown @conceal
  highlight! link @markup.heading.5.marker.markdown @conceal
  highlight! link @markup.heading.6.marker.markdown @conceal
  if !has('nvim-0.10')
    call edge#highlight('@markup.italic', s:palette.none, s:palette.none, 'italic')
    call edge#highlight('@markup.strikethrough', s:palette.none, s:palette.none, 'strikethrough')
  endif
endif
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
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
