if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'yaml') ==# -1
    call add(g:edge_loaded_file_types, 'yaml')
else
    finish
endif
" syn_begin: yaml {{{
highlight! link yamlKey Purple
highlight! link yamlBlockMappingKey Purple
highlight! link yamlConstant RedItalic
highlight! link yamlString Green
highlight! link yamlKeyValueDelimiter Grey
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
