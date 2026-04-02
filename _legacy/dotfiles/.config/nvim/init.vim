 " GarrettMaring
 
" Plugins {{{
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'camspiers/animate.vim'
Plug 'camspiers/lens.vim'
Plug 'tpope/vim-abolish' " Advanced search and replace
Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim' " Provide better text object manipulation
Plug 'scrooloose/nerdTree'
Plug 'scrooloose/nerdcommenter'
Plug 'lambdalisue/gina.vim'
Plug 'pangloss/vim-javascript'
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'posva/vim-vue' " Vue syntax highlighting
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'w0rp/ale' " Linting & language server
Plug 'ternjs/tern_for_vim'
Plug 'hail2u/vim-css3-syntax'
Plug 'cakebaker/scss-syntax.vim'
Plug 'racer-rust/vim-racer' " Rust autocomplete
Plug 'rust-lang/rust.vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'takac/vim-hardtime'
Plug 'keith/swift.vim' " Swift syntax
Plug 'mitsuse/autocomplete-swift'
Plug 'dhruvasagar/vim-table-mode'
Plug 'Shougo/neosnippet'
Plug 'leafgarland/typescript-vim'
"" Both the below plugins are needed for vim-notes
Plug 'xolox/vim-misc'
Plug 'xolox/vim-notes'
Plug 'vimwiki/vimwiki'
"" Dash
Plug 'rizzatti/dash.vim'
Plug 'jeetsukumaran/vim-indentwise'
"" Prose
Plug 'junegunn/goyo.vim' " Minimalist editor view
Plug 'reedes/vim-pencil' " Undo points, soft line wraps, general writing tools
Plug 'reedes/vim-lexical' " Spell-check and thesaurus
Plug 'reedes/vim-wordy' " Enforce writing best practices
Plug 'leafOfTree/vim-svelte-plugin' 
call plug#end()
" }}}
" Colors {{{
color apprentice

autocmd ColorScheme * highlight Comment ctermfg=Red
autocmd ColorScheme * highlight Folded ctermfg=Green cterm=NONE ctermbg=NONE
autocmd ColorScheme * highlight VertSplit cterm=NONE ctermfg=Blue ctermbg=NONE

au Syntax * call matchadd('Todo',  '\W\zs\(TODO\|FIXME\|CHANGED\|XXX\|BUG\|HACK\|READ\)')
" }}}
" UI Layout {{{
" nicer vertical characters
set fillchars+=vert:\|
" allow vim to set title of the shell
set title
" flash errors instead of beeping
set visualbell
" lines numbers relative to line that cursor is on
set relativenumber
" see current absolute line number
set number
" No column length restriction for syntax highlighting
set synmaxcol=0
" disable left scrollbar
set guioptions-=l
" disable right scrollbar
set guioptions-=r
" }}}
" Core {{{
let mapleader=" "
" enable filetype detection and: 
" * load plugins relevant to filetype
" * calculate indentation based on fileype
"filetype plugin indent on
filetype plugin on
" No .swp file
set noswapfile 
" no legacy vi compatibility
set nocompatible
" force manually configuring pasted text
set nopaste
" default to English spelling
set spelllang=en_us

" esc
inoremap <LEADER>jk <ESC>
" write
noremap <LEADER>w <ESC> :w<CR>
" quit
noremap <LEADER>q <ESC> :q<CR>
" quit all
noremap <LEADER>qq <ESC> :qa<CR>
" write and quit
inoremap <LEADER>wq <ESC> :wq<CR>
" load .vimrc
noremap <LEADER>source <ESC> :source ~/.vimrc<CR>
" }}}
" Splits {{{
set splitbelow
set splitright

" right movement
noremap <C-K> <C-W>l
" left movement
noremap <C-J> <C-W>h
" easier vertical split
noremap <LEADER>v :vsp<CR>
" easier horizontal split
noremap <LEADER>h :split<CR>
" }}}
" Editing {{{
inoremap <LEADER>pp <C-R>"
" <C-O> runs a normal mode command in insert mode
inoremap <LEADER>dd <C-O>dd
" Replace remaing words on the line as you just did
map <Leader>rm :s/<C-r>-/<C-r>.<CR>
" }}}
" Mouse & Keyboard {{{
" backspace works as expected
set backspace=indent,eol,start
" enable mouse in all modes
set mouse=a
" }}}
" Movement {{{
" }}}
" Tabs & Spaces {{{
" copies indentation of current line when entering a new line with 'O'
"set autoindent
" tab key inserts spaces instead of tab character
set expandtab
" indents conform to edited tab settings
set smarttab
set softtabstop=0
" width of an indent in space
set shiftwidth=2
" width of a hardtabstop in spaces
set tabstop=2
" }}}
" Search & Select {{{
" system clipboard support
let g:clipboard = {
  \ 'name': 'pbcopy',
  \ 'copy': {
  \    '+': 'pbcopy',
  \    '*': 'pbcopy',
  \  },
  \ 'paste': {
  \    '+': 'pbpaste',
  \    '*': 'pbpaste',
  \ },
  \ 'cache_enabled': 0,
  \ }
" search as characters are entered
set incsearch
" default to ignore case
set ignorecase
" will not ignore case if capital characters are entered
set smartcase
" highlight search
set hlsearch
" substiture with /g by default
set gdefault

" turn off search highlight
nnoremap <LEADER>nh :noh<CR>
" highlight everything inside block (inclusive)
noremap <LEADER>%% V$%
vnoremap <LEADER>%% $%
" copy to system clipboard
vnoremap <LEADER>C :w !pbcopy<CR>

" bring up fuzzy line searching
nnoremap <LEADER>s :Ag<CR>
" }}}
" Folding {{{
set foldenable
set foldnestmax=10
set foldmethod=marker

" toggle fold
noremap zz za
" }}}
" Top Tabs {{{
" hide buffers instead of closing them
set hidden
" ignore QuickFix buffer
augroup qf
  autocmd!
  autocmd FileType qf set nobuflisted
augroup end

" create new buffer
nnoremap <C-T> :enew<CR>
" go to next buffer
nnoremap <C-l> :bnext<CR>
" go to previous buffer
nnoremap <C-h> :bprevious<CR>
"" close buffer and move to previous one - like closing a tab
nnoremap <C-q> :bp <BAR> bd #<CR>
"" toggle between last open buffer and current buffer
nnoremap <C-TAB> :b #<CR>
" }}}
" Tables {{{
let g:table_mode_header_fillchar="="
let g:table_mode_corner_corner="\u25CB"
" }}}
" Regex {{{
"" (http://vim.wikia.com/wiki/Simplifying_regular_expressions_using_magic_and_no-magic)
nnoremap / /\v
vnoremap / /\v
cnoremap %s/ %smagic/
cnoremap \>s/ \>smagic/
nnoremap :g/ :g/\v
nnoremap :g// :g//
" }}}
" Git {{{
" max width for commit messages
au FileType gitcommit set tw=72
" }}}
" Languages {{{
syntax enable

" javascript & typescript {{{
" replace all single quotes
nnoremap <LEADER>"" :%s/'/"<CR>
" delete all semicolons
nnoremap <LEADER>;; :%s/;//<CR>
" Put this in vimrc or a plugin file of your own.
" After this is configured, :ALEFix will try and fix your JS code with ESLint.
let g:ale_fixers = {
\   'javascript': ['prettier'],
\   'typescript': ['prettier'],
\   'css': ['prettier'],
\}
"" }}}
" css & friends {{{
" au FileType css setlocal omnifunc=csscomplete#CompleteCSS
" this fixes issues with names like vertical-align etc.
augroup VimCSS3Syntax
  autocmd!
  autocmd FileType css setlocal iskeyword+=-
augroup END

" scss
" au BufRead,BufNewFile *.scss set filetype=scss.css
" au FileType scss setlocal omnifunc=csscomplete#CompleteCSS
" }}}
" rust {{{
let g:racer_cmd="/Users/garrettmaring/.cargo/bin/racer"
let $RUST_SRC_PATH="~/.rustup/toolchains/stable-x86_64-apple-darwin/lib/rustlib/src/rust/src"
let g:racer_experimental_completer = 1
autocmd BufReadPost *.rs setlocal filetype=rust
"let g:LanguageClient_serverCommands = {
    "\ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    "\ }

" Automatically start language servers.
let g:LanguageClient_autoStart = 1

" Maps K to hover, gd to goto definition, F2 to rename
nnoremap <silent> K :call LanguageClient_textDocument_hover()
nnoremap <silent> gd :call LanguageClient_textDocument_definition()
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()
au FileType rust nmap <silent> <C-]> <Plug>(rust-def)
au FileType rust nmap <silent> <C-w><C-]> <Plug>(rust-def-vertical)
au FileType rust nmap <silent> <C-w>} <Plug>(rust-def-split)
au FileType rust nmap <silent> <C-k> <Plug>(rust-doc)
"let g:ale_linters = {
            "\ 'rust': [ 'rls' ],
            "\ }
" }}}
" swift {{{
" build on every write
autocmd Filetype swift setlocal ts=4 sw=4 sts=0 expandtab
" }}}
" Languages }}}
" Plugin Configs {{{
" Status Line (lightline) {{{
" since lightline shows the mode, disable the default
set noshowmode
" configure lightline
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'gitbranch#name'
      \ },
      \ }
" }}}
" Neosnippets {{{
" do not run default snippets as they are not installed
let g:neosnippet#disable_runtime_snippets= {
\   '_': 1,
\ }
" set directory
let g:neosnippet#snippets_directory='~/.vim/Snippets'
" hides text of snippet
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif
" use javascript snippets in jsx files
let g:neosnippet#scope_aliases = {
\   'javascript.jsx': 'javascript',
\ }

imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
" }}}
" Dash {{{
nnoremap <Leader>d :Dash<CR>
" }}}
" NerdTree {{{
" open nerdTree when vim open
"autocmd vimenter * NERDTree
" open nerdTre even if no files specified
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" open nerdTree if opening a directory
autocmd StdinReadPre * let s:std_in=1
let g:loaded_nerdtree_exec_menuitem=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
" move to file buffer if file present
"autocmd VimEnter * if argc() == 1 | NERDTree | wincmd p | endif
" close nerdTree if it's the only buffer left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

map <LEADER>n :NERDTreeToggle<CR>
nnoremap <LEADER>f :GitFiles<CR>
nnoremap <LEADER>nf :NERDTreeFind<CR>
" }}}
" Ale {{{
let g:ale_completion_enabled = 1

" Set this setting in vimrc if you want to fix files automatically on save.
" This is off by default.
let g:ale_fix_on_save = 1
" Only use configured lints
"let g:ale_linters_explicit = 1
nmap <Leader>ar :ALEFindReferences<CR>
nmap <Leader>ad :ALEGoToDefinition<CR>
" }}}
" IndentWise {{{
map <C-u> <Plug>(IndentWisePreviousEqualIndent)
map <C-y> <Plug>(IndentWiseNextEqualIndent)
map <C-o> <Plug>(IndentWisePreviousLesserIndent)
map <C-i> <Plug>(IndentWiseNextGreaterIndent)
" Defaults
map [+ <Plug>(IndentWisePreviousGreaterIndent)
map ]- <Plug>(IndentWiseNextLesserIndent)
map [_ <Plug>(IndentWisePreviousAbsoluteIndent)
map ]_ <Plug>(IndentWiseNextAbsoluteIndent)
map [% <Plug>(IndentWiseBlockScopeBoundaryBegin)
map ]% <Plug>(IndentWiseBlockScopeBoundaryEnd)
" }}}

" https://github.com/posva/vim-vue#my-syntax-highlighting-stops-working-randomly
autocmd FileType vue syntax sync fromstart

nmap <Leader>lo :lopen<CR>
nmap <Leader>lc :lclose<CR>
nmap <Leader>ll :lnext<CR>
nmap <Leader>ln :lnext<CR>
nmap <Leader>lp :lprev<CR>
" Notes {{{
let g:notes_directories = ['~/Notes' ]
let g:notes_suffix = '.txt'
" }}}
" Tern {{{
au FileType javascript setlocal omnifunc=tern#Complete

au filetype javascript nnoremap <leader>type :TernType<CR>
au filetype javascript nnoremap <leader>def :TernDef<CR>
au filetype javascript nnoremap <leader>doc :TernDoc<CR>
" }}}
" vim-jsx {{{
"// let g:jsx_ext_required = 0
" }}}
" Gina {{{
" gina-done: Used for review flow. Add stage the current file and return the
" status
function AddStatus()
  :Gina add %
  :Gina status
endfunction
noremap <Leader>gd :call AddStatus()<CR>

" Vertifical git diff
set diffopt=filler,vertical
" }}}
" Plugin Configs }}}
" Misc {{{
"let g:hardtime_default_on = 1

map <Leader>for :%!python -m json.tool<CR>
" add support for local .vimrc configurations

" Search for a local.vim file
let vfile = globpath(getcwd(), "/Config/Vim/local.vim")

try 
  exec "source" . vfile
catch
  " no-op
endtry 

" svelte
let g:vim_svelte_plugin_load_full_syntax = 1

" local .vimrc file. See http://vimdoc.sourceforge.net/htmldoc/options.html#'secure'

"
" This is to get tab complete with Ale
" yeah, so inoremap just maps a command in insert mode, while disallowing using mappings for the right hand side (otherwise the tab thing would be recursive). <expr> means instead of inserting whatever follows, we’re telling vim that it’s an expression to be evaluated. <silent> I’m unsure of, not sure what happens if we don’t specify that, maybe it shows the expression in the status bar or something. After that it’s just a ternary operator; if pumvisible (“Returns non-zero when the popup menu is visible”), then send Ctrl-N, which  will tell omnicomplete to go forward one (could have also used arrow down here), otherwise just send a tab
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" : "\<TAB>"
" The same as above but use shift-tab to select previous
"inoremap <silent><expr> <S-Tab>
      "\ pumvisible() ? "\<C-p>" : "\<S-TAB>"
" }}}
