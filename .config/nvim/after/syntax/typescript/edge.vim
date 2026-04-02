if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'typescript') ==# -1
    call add(g:edge_loaded_file_types, 'typescript')
else
    finish
endif
" syn_begin: typescript/typescriptreact {{{
" vim-typescript: https://github.com/leafgarland/typescript-vim{{{
highlight! link typescriptStorageClass Purple
highlight! link typescriptEndColons Fg
highlight! link typescriptSource RedItalic
highlight! link typescriptMessage Blue
highlight! link typescriptGlobalObjects RedItalic
highlight! link typescriptInterpolation Yellow
highlight! link typescriptInterpolationDelimiter Yellow
highlight! link typescriptBraces Fg
highlight! link typescriptParens Fg
" }}}
" yats: https:github.com/HerringtonDarkholme/yats.vim{{{
highlight! link typescriptMethodAccessor Purple
highlight! link typescriptVariable Purple
highlight! link typescriptVariableDeclaration Fg
highlight! link typescriptTypeReference RedItalic
highlight! link typescriptBraces Fg
highlight! link typescriptEnumKeyword Purple
highlight! link typescriptEnum RedItalic
highlight! link typescriptIdentifierName Fg
highlight! link typescriptProp Fg
highlight! link typescriptCall Fg
highlight! link typescriptInterfaceName RedItalic
highlight! link typescriptEndColons Fg
highlight! link typescriptMember Fg
highlight! link typescriptMemberOptionality Purple
highlight! link typescriptObjectLabel Fg
highlight! link typescriptDefaultParam Fg
highlight! link typescriptArrowFunc Purple
highlight! link typescriptAbstract Purple
highlight! link typescriptObjectColon Grey
highlight! link typescriptTypeAnnotation Grey
highlight! link typescriptAssign Purple
highlight! link typescriptBinaryOp Purple
highlight! link typescriptUnaryOp Purple
highlight! link typescriptFuncComma Fg
highlight! link typescriptClassName RedItalic
highlight! link typescriptClassHeritage RedItalic
highlight! link typescriptInterfaceHeritage RedItalic
highlight! link typescriptIdentifier YellowItalic
highlight! link typescriptTry Purple
highlight! link typescriptGlobal RedItalic
highlight! link typescriptOperator Purple
highlight! link typescriptNodeGlobal RedItalic
highlight! link typescriptExport Purple
highlight! link typescriptImport Purple
highlight! link typescriptTypeParameter RedItalic
highlight! link typescriptReadonlyModifier Purple
highlight! link typescriptAccessibilityModifier Purple
highlight! link typescriptAmbientDeclaration Purple
highlight! link typescriptTemplateSubstitution Yellow
highlight! link typescriptTemplateSB Yellow
highlight! link typescriptExceptions Purple
highlight! link typescriptCastKeyword Purple
highlight! link typescriptOptionalMark Purple
highlight! link typescriptNull YellowItalic
highlight! link typescriptMappedIn Purple
highlight! link typescriptFuncTypeArrow Purple
highlight! link typescriptTernaryOp Purple
highlight! link typescriptParenExp Fg
highlight! link typescriptIndexExpr Fg
highlight! link typescriptDotNotation Grey
highlight! link typescriptGlobalNumberDot Grey
highlight! link typescriptGlobalStringDot Grey
highlight! link typescriptGlobalArrayDot Grey
highlight! link typescriptGlobalObjectDot Grey
highlight! link typescriptGlobalSymbolDot Grey
highlight! link typescriptGlobalMathDot Grey
highlight! link typescriptGlobalDateDot Grey
highlight! link typescriptGlobalJSONDot Grey
highlight! link typescriptGlobalRegExpDot Grey
highlight! link typescriptGlobalPromiseDot Grey
highlight! link typescriptGlobalURLDot Grey
highlight! link typescriptGlobalMethod Blue
highlight! link typescriptDOMStorageMethod Blue
highlight! link typescriptFileMethod Blue
highlight! link typescriptFileReaderMethod Blue
highlight! link typescriptFileListMethod Blue
highlight! link typescriptBlobMethod Blue
highlight! link typescriptURLStaticMethod Blue
highlight! link typescriptNumberStaticMethod Blue
highlight! link typescriptNumberMethod Blue
highlight! link typescriptDOMNodeMethod Blue
highlight! link typescriptPaymentMethod Blue
highlight! link typescriptPaymentResponseMethod Blue
highlight! link typescriptHeadersMethod Blue
highlight! link typescriptRequestMethod Blue
highlight! link typescriptResponseMethod Blue
highlight! link typescriptES6SetMethod Blue
highlight! link typescriptReflectMethod Blue
highlight! link typescriptBOMWindowMethod Blue
highlight! link typescriptGeolocationMethod Blue
highlight! link typescriptServiceWorkerMethod Blue
highlight! link typescriptCacheMethod Blue
highlight! link typescriptES6MapMethod Blue
highlight! link typescriptFunctionMethod Blue
highlight! link typescriptRegExpMethod Blue
highlight! link typescriptXHRMethod Blue
highlight! link typescriptBOMNavigatorMethod Blue
highlight! link typescriptServiceWorkerMethod Blue
highlight! link typescriptIntlMethod Blue
highlight! link typescriptDOMEventTargetMethod Blue
highlight! link typescriptDOMEventMethod Blue
highlight! link typescriptDOMDocMethod Blue
highlight! link typescriptStringStaticMethod Blue
highlight! link typescriptStringMethod Blue
highlight! link typescriptSymbolStaticMethod Blue
highlight! link typescriptObjectStaticMethod Blue
highlight! link typescriptObjectMethod Blue
highlight! link typescriptJSONStaticMethod Blue
highlight! link typescriptEncodingMethod Blue
highlight! link typescriptBOMLocationMethod Blue
highlight! link typescriptPromiseStaticMethod Blue
highlight! link typescriptPromiseMethod Blue
highlight! link typescriptSubtleCryptoMethod Blue
highlight! link typescriptCryptoMethod Blue
highlight! link typescriptBOMHistoryMethod Blue
highlight! link typescriptDOMFormMethod Blue
highlight! link typescriptConsoleMethod Blue
highlight! link typescriptDateStaticMethod Blue
highlight! link typescriptDateMethod Blue
highlight! link typescriptArrayStaticMethod Blue
highlight! link typescriptArrayMethod Blue
highlight! link typescriptMathStaticMethod Blue
highlight! link typescriptStringProperty Fg
highlight! link typescriptDOMStorageProp Fg
highlight! link typescriptFileReaderProp Fg
highlight! link typescriptURLUtilsProp Fg
highlight! link typescriptNumberStaticProp Fg
highlight! link typescriptDOMNodeProp Fg
highlight! link typescriptBOMWindowProp Fg
highlight! link typescriptRequestProp Fg
highlight! link typescriptResponseProp Fg
highlight! link typescriptPaymentProp Fg
highlight! link typescriptPaymentResponseProp Fg
highlight! link typescriptPaymentAddressProp Fg
highlight! link typescriptPaymentShippingOptionProp Fg
highlight! link typescriptES6SetProp Fg
highlight! link typescriptServiceWorkerProp Fg
highlight! link typescriptES6MapProp Fg
highlight! link typescriptRegExpStaticProp Fg
highlight! link typescriptRegExpProp Fg
highlight! link typescriptBOMNavigatorProp Blue
highlight! link typescriptXHRProp Fg
highlight! link typescriptDOMEventProp Fg
highlight! link typescriptDOMDocProp Fg
highlight! link typescriptBOMNetworkProp Fg
highlight! link typescriptSymbolStaticProp Fg
highlight! link typescriptEncodingProp Fg
highlight! link typescriptBOMLocationProp Fg
highlight! link typescriptCryptoProp Fg
highlight! link typescriptDOMFormProp Fg
highlight! link typescriptBOMHistoryProp Fg
highlight! link typescriptMathStaticProp Fg
" }}}
" nvim-treesitter/nvim-treesitter {{{
highlight! link tsxTSConstructor TSType
if has('nvim-0.8')
  highlight! link @constructor.tsx tsxTSConstructor
endif
if has('nvim-0.9')
  highlight! link @lsp.typemod.variable.defaultLibrary.typescript TSConstBuiltin
  highlight! link @lsp.typemod.variable.defaultLibrary.typescriptreact TSConstBuiltin
endif
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
