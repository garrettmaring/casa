if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'perl') ==# -1
    call add(g:edge_loaded_file_types, 'perl')
else
    finish
endif
" syn_begin: perl/pod {{{
" builtin: https://github.com/vim-perl/vim-perl{{{
highlight! link perlStatementPackage Purple
highlight! link perlStatementInclude Purple
highlight! link perlStatementStorage Purple
highlight! link perlStatementList Purple
highlight! link perlMatchStartEnd Purple
highlight! link perlVarSimpleMemberName Blue
highlight! link perlVarSimpleMember Fg
highlight! link perlMethod Blue
highlight! link podVerbatimLine Blue
highlight! link podCmdText Green
highlight! link perlVarPlain Fg
highlight! link perlVarPlain2 Fg
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
