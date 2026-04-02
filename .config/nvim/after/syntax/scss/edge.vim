if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'scss') ==# -1
    call add(g:edge_loaded_file_types, 'scss')
else
    finish
endif
" syn_begin: css/scss/sass/less {{{
" builtin: https://github.com/JulesWang/css.vim{{{
highlight! link cssStringQ Green
highlight! link cssStringQQ Green
highlight! link cssAttrComma Grey
highlight! link cssBraces Grey
highlight! link cssTagName Yellow
highlight! link cssClassNameDot Grey
highlight! link cssClassName Purple
highlight! link cssFunctionName Cyan
highlight! link cssAttr Blue
highlight! link cssCommonAttr Blue
highlight! link cssProp Red
highlight! link cssPseudoClassId Blue
highlight! link cssPseudoClassFn Cyan
highlight! link cssPseudoClass Blue
highlight! link cssImportant Purple
highlight! link cssSelectorOp Cyan
highlight! link cssSelectorOp2 Cyan
highlight! link cssColor Green
highlight! link cssUnitDecorators Green
highlight! link cssValueLength Green
highlight! link cssValueInteger Green
highlight! link cssValueNumber Green
highlight! link cssValueAngle Green
highlight! link cssValueTime Green
highlight! link cssValueFrequency Green
highlight! link cssVendor Grey
highlight! link cssNoise Grey
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
" syn_begin: scss {{{
" scss-syntax: https://github.com/cakebaker/scss-syntax.vim{{{
highlight! link scssMixinName Cyan
highlight! link scssSelectorChar Grey
highlight! link scssSelectorName Purple
highlight! link scssInterpolationDelimiter Blue
highlight! link scssVariableValue Green
highlight! link scssNull Yellow
highlight! link scssBoolean Yellow
highlight! link scssVariableAssignment Grey
highlight! link scssAttribute Blue
highlight! link scssFunctionName Cyan
highlight! link scssVariable Fg
highlight! link scssAmpersand Yellow
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
