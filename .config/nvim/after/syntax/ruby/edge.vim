if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'ruby') ==# -1
    call add(g:edge_loaded_file_types, 'ruby')
else
    finish
endif
" syn_begin: ruby {{{
" builtin: https://github.com/vim-ruby/vim-ruby{{{
highlight! link rubyKeywordAsMethod Blue
highlight! link rubyInterpolation Yellow
highlight! link rubyInterpolationDelimiter Yellow
highlight! link rubyStringDelimiter Green
highlight! link rubyBlockParameterList Fg
highlight! link rubyDefine Purple
highlight! link rubyModuleName Purple
highlight! link rubyAccess Purple
highlight! link rubyMacro Purple
highlight! link rubySymbol Fg
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
