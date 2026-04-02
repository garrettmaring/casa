if !exists('g:colors_name') || g:colors_name !=# 'edge'
    finish
endif
if index(g:edge_loaded_file_types, 'javascript') ==# -1
    call add(g:edge_loaded_file_types, 'javascript')
else
    finish
endif
" syn_begin: javascript/javascriptreact {{{
" builtin: http://www.fleiner.com/vim/syntax/javascript.vim{{{
highlight! link javaScriptNull YellowItalic
highlight! link javaScriptIdentifier RedItalic
highlight! link javaScriptParens Fg
highlight! link javaScriptBraces Fg
highlight! link javaScriptNumber Yellow
highlight! link javaScriptLabel Purple
highlight! link javaScriptGlobal RedItalic
highlight! link javaScriptMessage RedItalic
" }}}
" vim-javascript: https://github.com/pangloss/vim-javascript{{{
highlight! link jsNoise Fg
highlight! link Noise Fg
highlight! link jsParens Fg
highlight! link jsBrackets Fg
highlight! link jsObjectBraces Fg
highlight! link jsThis YellowItalic
highlight! link jsUndefined YellowItalic
highlight! link jsNull YellowItalic
highlight! link jsNan YellowItalic
highlight! link jsSuper YellowItalic
highlight! link jsPrototype CyanItalic
highlight! link jsFunction Purple
highlight! link jsGlobalNodeObjects RedItalic
highlight! link jsGlobalObjects RedItalic
highlight! link jsArrowFunction Purple
highlight! link jsArrowFuncArgs Fg
highlight! link jsFuncArgs Fg
highlight! link jsObjectProp Fg
highlight! link jsVariableDef Fg
highlight! link jsObjectKey Fg
highlight! link jsParen Fg
highlight! link jsParenIfElse Fg
highlight! link jsParenRepeat Fg
highlight! link jsParenSwitch Fg
highlight! link jsParenCatch Fg
highlight! link jsBracket Fg
highlight! link jsObjectValue Fg
highlight! link jsDestructuringBlock Fg
highlight! link jsBlockLabel Yellow
highlight! link jsFunctionKey Blue
highlight! link jsClassDefinition RedItalic
highlight! link jsDot Grey
highlight! link jsSpreadExpression Yellow
highlight! link jsSpreadOperator Blue
highlight! link jsModuleKeyword RedItalic
highlight! link jsTemplateExpression Yellow
highlight! link jsTemplateBraces Yellow
highlight! link jsClassMethodType RedItalic
highlight! link jsExceptions RedItalic
highlight! link jsLabel Purple
" }}}
" yajs: https://github.com/othree/yajs.vim{{{
highlight! link javascriptOpSymbol Purple
highlight! link javascriptOpSymbols Purple
highlight! link javascriptIdentifierName Fg
highlight! link javascriptVariable RedItalic
highlight! link javascriptObjectLabel Fg
highlight! link javascriptPropertyNameString Fg
highlight! link javascriptFuncArg Fg
highlight! link javascriptObjectLiteral Blue
highlight! link javascriptIdentifier CyanItalic
highlight! link javascriptArrowFunc Purple
highlight! link javascriptTemplate Yellow
highlight! link javascriptTemplateSubstitution Yellow
highlight! link javascriptTemplateSB Yellow
highlight! link javascriptNodeGlobal RedItalic
highlight! link javascriptDocTags PurpleItalic
highlight! link javascriptDocNotation Red
highlight! link javascriptClassSuper YellowItalic
highlight! link javascriptClassName RedItalic
highlight! link javascriptClassSuperName RedItalic
highlight! link javascriptOperator Purple
highlight! link javascriptBrackets Fg
highlight! link javascriptBraces Fg
highlight! link javascriptLabel Yellow
highlight! link javascriptEndColons Grey
highlight! link javascriptObjectLabelColon Grey
highlight! link javascriptDotNotation Grey
highlight! link javascriptGlobalArrayDot Grey
highlight! link javascriptGlobalBigIntDot Grey
highlight! link javascriptGlobalDateDot Grey
highlight! link javascriptGlobalJSONDot Grey
highlight! link javascriptGlobalMathDot Grey
highlight! link javascriptGlobalNumberDot Grey
highlight! link javascriptGlobalObjectDot Grey
highlight! link javascriptGlobalPromiseDot Grey
highlight! link javascriptGlobalRegExpDot Grey
highlight! link javascriptGlobalStringDot Grey
highlight! link javascriptGlobalSymbolDot Grey
highlight! link javascriptGlobalURLDot Grey
highlight! link javascriptMethod Blue
highlight! link javascriptMethodName Blue
highlight! link javascriptObjectMethodName Blue
highlight! link javascriptGlobalMethod Blue
highlight! link javascriptDOMStorageMethod Blue
highlight! link javascriptFileMethod Blue
highlight! link javascriptFileReaderMethod Blue
highlight! link javascriptFileListMethod Blue
highlight! link javascriptBlobMethod Blue
highlight! link javascriptURLStaticMethod Blue
highlight! link javascriptNumberStaticMethod Blue
highlight! link javascriptNumberMethod Blue
highlight! link javascriptDOMNodeMethod Blue
highlight! link javascriptES6BigIntStaticMethod Blue
highlight! link javascriptBOMWindowMethod Blue
highlight! link javascriptHeadersMethod Blue
highlight! link javascriptRequestMethod Blue
highlight! link javascriptResponseMethod Blue
highlight! link javascriptES6SetMethod Blue
highlight! link javascriptReflectMethod Blue
highlight! link javascriptPaymentMethod Blue
highlight! link javascriptPaymentResponseMethod Blue
highlight! link javascriptTypedArrayStaticMethod Blue
highlight! link javascriptGeolocationMethod Blue
highlight! link javascriptES6MapMethod Blue
highlight! link javascriptServiceWorkerMethod Blue
highlight! link javascriptCacheMethod Blue
highlight! link javascriptFunctionMethod Blue
highlight! link javascriptXHRMethod Blue
highlight! link javascriptBOMNavigatorMethod Blue
highlight! link javascriptServiceWorkerMethod Blue
highlight! link javascriptDOMEventTargetMethod Blue
highlight! link javascriptDOMEventMethod Blue
highlight! link javascriptIntlMethod Blue
highlight! link javascriptDOMDocMethod Blue
highlight! link javascriptStringStaticMethod Blue
highlight! link javascriptStringMethod Blue
highlight! link javascriptSymbolStaticMethod Blue
highlight! link javascriptRegExpMethod Blue
highlight! link javascriptObjectStaticMethod Blue
highlight! link javascriptObjectMethod Blue
highlight! link javascriptBOMLocationMethod Blue
highlight! link javascriptJSONStaticMethod Blue
highlight! link javascriptGeneratorMethod Blue
highlight! link javascriptEncodingMethod Blue
highlight! link javascriptPromiseStaticMethod Blue
highlight! link javascriptPromiseMethod Blue
highlight! link javascriptBOMHistoryMethod Blue
highlight! link javascriptDOMFormMethod Blue
highlight! link javascriptClipboardMethod Blue
highlight! link javascriptTypedArrayStaticMethod Blue
highlight! link javascriptBroadcastMethod Blue
highlight! link javascriptDateStaticMethod Blue
highlight! link javascriptDateMethod Blue
highlight! link javascriptConsoleMethod Blue
highlight! link javascriptArrayStaticMethod Blue
highlight! link javascriptArrayMethod Blue
highlight! link javascriptMathStaticMethod Blue
highlight! link javascriptSubtleCryptoMethod Blue
highlight! link javascriptCryptoMethod Blue
highlight! link javascriptProp Fg
highlight! link javascriptBOMWindowProp Fg
highlight! link javascriptDOMStorageProp Fg
highlight! link javascriptFileReaderProp Fg
highlight! link javascriptURLUtilsProp Fg
highlight! link javascriptNumberStaticProp Fg
highlight! link javascriptDOMNodeProp Fg
highlight! link javascriptRequestProp Fg
highlight! link javascriptResponseProp Fg
highlight! link javascriptES6SetProp Fg
highlight! link javascriptPaymentProp Fg
highlight! link javascriptPaymentResponseProp Fg
highlight! link javascriptPaymentAddressProp Fg
highlight! link javascriptPaymentShippingOptionProp Fg
highlight! link javascriptTypedArrayStaticProp Fg
highlight! link javascriptServiceWorkerProp Fg
highlight! link javascriptES6MapProp Fg
highlight! link javascriptRegExpStaticProp Fg
highlight! link javascriptRegExpProp Fg
highlight! link javascriptXHRProp Fg
highlight! link javascriptBOMNavigatorProp Blue
highlight! link javascriptDOMEventProp Fg
highlight! link javascriptBOMNetworkProp Fg
highlight! link javascriptDOMDocProp Fg
highlight! link javascriptSymbolStaticProp Fg
highlight! link javascriptSymbolProp Fg
highlight! link javascriptBOMLocationProp Fg
highlight! link javascriptEncodingProp Fg
highlight! link javascriptCryptoProp Fg
highlight! link javascriptBOMHistoryProp Fg
highlight! link javascriptDOMFormProp Fg
highlight! link javascriptDataViewProp Fg
highlight! link javascriptBroadcastProp Fg
highlight! link javascriptMathStaticProp Fg
" }}}
" vim-jsx-pretty: https://github.com/maxmellon/vim-jsx-pretty{{{
highlight! link jsxTagName PurpleItalic
highlight! link jsxOpenPunct Blue
highlight! link jsxClosePunct Red
highlight! link jsxEscapeJs Yellow
highlight! link jsxAttrib Red
" }}}
if has('nvim-0.9')
  highlight! link @lsp.typemod.variable.defaultLibrary.javascript TSConstBuiltin
  highlight! link @lsp.typemod.variable.defaultLibrary.javascriptreact TSConstBuiltin
endif
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
