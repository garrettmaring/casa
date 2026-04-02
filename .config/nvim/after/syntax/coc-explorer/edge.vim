if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'coc-explorer') ==# -1
    call add(g:edge_loaded_file_types, 'coc-explorer')
else
    finish
endif
" syn_begin: coc-explorer {{{
" https://github.com/weirongxu/coc-explorer
highlight! link CocExplorerBufferRoot Purple
highlight! link CocExplorerBufferExpandIcon Red
highlight! link CocExplorerBufferBufnr Yellow
highlight! link CocExplorerBufferModified Yellow
highlight! link CocExplorerBufferReadonly Red
highlight! link CocExplorerBufferBufname Grey
highlight! link CocExplorerBufferFullpath Grey
highlight! link CocExplorerFileRoot Purple
highlight! link CocExplorerFileRootName Green
highlight! link CocExplorerFileExpandIcon Red
highlight! link CocExplorerFileFullpath Grey
highlight! link CocExplorerFileDirectory Green
highlight! link CocExplorerFileGitStaged Purple
highlight! link CocExplorerFileGitUnstaged Yellow
highlight! link CocExplorerFileGitRootStaged Purple
highlight! link CocExplorerFileGitRootUnstaged Yellow
highlight! link CocExplorerGitPathChange Fg
highlight! link CocExplorerGitContentChange Fg
highlight! link CocExplorerGitRenamed Purple
highlight! link CocExplorerGitCopied Fg
highlight! link CocExplorerGitAdded Green
highlight! link CocExplorerGitUntracked Blue
highlight! link CocExplorerGitUnmodified Fg
highlight! link CocExplorerGitUnmerged Cyan
highlight! link CocExplorerGitMixed Cyan
highlight! link CocExplorerGitModified Yellow
highlight! link CocExplorerGitDeleted Red
highlight! link CocExplorerGitIgnored Grey
highlight! link CocExplorerFileSize Blue
highlight! link CocExplorerTimeAccessed Cyan
highlight! link CocExplorerTimeCreated Cyan
highlight! link CocExplorerTimeModified Cyan
highlight! link CocExplorerIndentLine Conceal
highlight! link CocExplorerHelpDescription Grey
highlight! link CocExplorerHelpHint Grey
highlight! link CocExplorerDiagnosticError Red
highlight! link CocExplorerDiagnosticWarning Yellow
highlight! link CocExplorerFileHidden Grey
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
