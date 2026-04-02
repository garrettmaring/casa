if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'tagbar') ==# -1
    call add(g:edge_loaded_file_types, 'tagbar')
else
    finish
endif
" syn_begin: tagbar {{{
" https://github.com/majutsushi/tagbar
highlight! link TagbarFoldIcon Blue
highlight! link TagbarSignature Green
highlight! link TagbarKind Purple
highlight! link TagbarScope Red
highlight! link TagbarNestedKind Blue
highlight! link TagbarVisibilityPrivate Red
highlight! link TagbarVisibilityPublic Blue
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
