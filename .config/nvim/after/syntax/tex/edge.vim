if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'tex') ==# -1
    call add(g:edge_loaded_file_types, 'tex')
else
    finish
endif
" syn_begin: tex {{{
" builtin: http://www.drchip.org/astronaut/vim/index.html#SYNTAX_TEX{{{
highlight! link texStatement RedItalic
highlight! link texOnlyMath Grey
highlight! link texDefName Green
highlight! link texNewCmd Cyan
highlight! link texCmdName Red
highlight! link texBeginEnd Purple
highlight! link texBeginEndName Blue
highlight! link texDocType PurpleItalic
highlight! link texDocTypeArgs Cyan
highlight! link texInputFile Blue
" }}}
" vimtex: https://github.com/lervag/vimtex {{{
highlight! link texCmd RedItalic
highlight! link texCmdClass Purple
highlight! link texCmdTitle Purple
highlight! link texCmdAuthor Purple
highlight! link texFileArg Blue
highlight! link texCmdDef Purple
highlight! link texDefArgName Yellow
highlight! link texPartArgTitle Yellow
highlight! link texCmdEnv Purple
highlight! link texCmdPart Purple
highlight! link texEnvArgName Green
highlight! link texMathEnvArgName Green
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
