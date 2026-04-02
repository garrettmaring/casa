if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'dashboard') ==# -1
    call add(g:edge_loaded_file_types, 'dashboard')
else
    finish
endif
" syn_begin: dashboard {{{
" https://github.com/glepnir/dashboard-nvim
highlight! link DashboardHeader Purple
highlight! link DashboardCenter Green
highlight! link DashboardShortcut Blue
highlight! link DashboardFooter Red
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
