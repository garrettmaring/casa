if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'clojure') ==# -1
    call add(g:edge_loaded_file_types, 'clojure')
else
    finish
endif
" syn_begin: clojure {{{
" builtin: https://github.com/guns/vim-clojure-static{{{
highlight! link clojureMacro Purple
highlight! link clojureFunc Blue
highlight! link clojureConstant YellowItalic
highlight! link clojureSpecial Purple
highlight! link clojureDefine Purple
highlight! link clojureKeyword Red
highlight! link clojureVariable Fg
highlight! link clojureMeta Yellow
highlight! link clojureDeref Yellow
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
