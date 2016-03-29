" vim:ft=vim
set nocompatible
let mapleader=","

" ------------------------------
" Functions
" ------------------------------
fun! TextWidth()
    " highlight column 80
    if v:version >= 703
        setlocal colorcolumn=80
    else
        highlight OverLength ctermbg=grey ctermfg=black guibg=#eeeeff
        match OverLength /\%80v.\+/
    endif
endfun
nmap <F11> :call TextWidth()<cr>
autocmd FileType python call TextWidth()

fun! TrimSpaces()
  if !&binary && &filetype != 'diff'
    normal mz
    normal Hmy
    %s/\s\+$//e
    normal 'yz<CR>
    normal `z
  endif
endfun
nmap <F9> :call TrimSpaces()<cr>

fun! TextMode()
    setlocal nonumber
    setlocal spell
    setlocal whichwrap+=<,>,[,]

    " setlocal textwidth=90
    " setlocal formatoptions=aw2tql

    " http://vim.wikia.com/wiki/VimTip989
    setlocal wrap
    setlocal linebreak
    setlocal nolist
    setlocal showbreak=❯
    setlocal formatoptions-=t
    setlocal formatoptions+=l
    setlocal textwidth=0
    setlocal wrapmargin=0
endfun
nmap <leader>tt :call TextMode()<cr>
nmap <leader>ta :setlocal formatoptions-=l<cr>:call TextMode()<cr>

fun! Tab2()
    setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
endfun
nmap <leader>2t :call Tab2()<cr>
autocmd FileType yaml call Tab2()

" ------------------------------
" Plugins activate
" ------------------------------
" Bundle 'tpope/vim-pathogen'
runtime bundle/tpope--vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

"- Bundle 'vim-scripts/xterm16.vim'
" let xterm16_colormap='softlight'
" let xterm16_brightness='high'
" colorscheme xterm16

"- Bundle 'junegunn/seoul256.vim'
" let g:seoul256_background = 254
" colorscheme seoul256

" Bundle 'altercation/vim-colors-solarized'
" set t_Co=256
" let g:solarized_termcolors=256
set background=light
colorscheme solarized


" Bundle 'kien/ctrlp.vim'
let g:ctrlp_custom_ignore={
    \'dir':  '\.git$\|\.hg$\|\.svn$\|__pycache__$',
\}
"let g:ctrlp_extensions=['tag', 'quickfix', 'dir']
let g:ctrlp_working_path_mode=0
let g:ctrlp_mruf_relative=1
nmap <F3> :CtrlPBuffer<cr>
imap <F3> <esc>:CtrlPBuffer<cr>
nmap <F4> :CtrlPCurWD<cr>
imap <F4> <esc>:CtrlPCurWD<cr>
nmap <F5> :CtrlPBufTag<cr>
imap <F5> <esc>:CtrlPBufTag<cr>
nmap <F6> :CtrlPBufTagAll<cr>
imap <F6> <esc>:CtrlPBufTagAll<cr>


" Bundle 'scrooloose/syntastic'
let g:syntastic_check_on_open=0
let g:syntastic_enable_signs=0
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_enable_balloons=1
let g:syntastic_enable_highlighting=1
let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list=2
let g:syntastic_loc_list_height=2
let g:syntastic_stl_format = '[%E{Err: #%e}%B{, }%W{Warn: #%w}]'
" let g:syntastic_python_flake8_args='--ignore=W601,E711'
let g:syntastic_javascript_checkers = ['jshint', 'eslint']
nmap <F8> :SyntasticCheck<cr>:Errors<cr>


" Bundle 'milkypostman/vim-togglelist'
nmap <leader>l :call ToggleLocationList()<CR>
nmap <leader>q :call ToggleQuickfixList()<CR>


" Bundle 'tpope/vim-commentary'
vnoremap <leader>c :Commentary<cr>gv
noremap <leader>c :Commentary<cr>


let g:jedi#force_py_version=3
" Bundle 'davidhalter/jedi-vim'
let g:jedi#auto_initialization=1
let g:jedi#auto_vim_configuration=1
let g:jedi#use_tabs_not_buffers=0
let g:jedi#completions_enabled=1
let g:jedi#smart_auto_mappings = 0
let g:jedi#popup_on_dot=0
let g:jedi#popup_select_first=1
let g:jedi#show_call_signatures=2
let g:jedi#rename_command=0
let g:jedi#goto_definitions_command="<leader>d"
let g:jedi#goto_assignments_command="<leader>g"
let g:jedi#documentation_command="<leader>o"
let g:jedi#usages_command="<leader>i"
let g:jedi#completions_command="<C-Space>"
nmap <leader>pp :call jedi#force_py_version_switch()<cr>


" Bundle 'ervandew/supertab'
let g:SuperTabMappingForward='<nul>' " '<c-space>'
let g:SuperTabMappingBackward='<s-nul>' " '<s-c-space>'
let g:SuperTabDefaultCompletionType="<c-x><c-o>"
"let g:SuperTabContextDefaultCompletionType="<c-x><c-o>"


"- Bundle 'tpope/vim-dispatch'
" Bundle 'mhinz/vim-grepper'
cnoremap <c-n> <down>
cnoremap <c-p> <up>
nnoremap <leader>gg :Grepper<cr>
let g:grepper = {
    \'jump': 0,
    \'open': 1,
    \'switch': 1,
    \'dispatch': 0
\}


" Bundle 'itchyny/vim-gitbranch'
" Bundle 'vim-airline/vim-airline'
" Bundle 'vim-airline/vim-airline-themes'
let g:airline_theme='solarized'
if !exists('g:airline_symbols')
    let g:airline_symbols={}
endif
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_section_b='⎇  %{gitbranch#name()}'


"- Bundle 'Shougo/neocomplete.vim'
let g:neocomplete#enable_at_startup=0


"- Bundle 'maksimr/vim-jsbeautify'
" nnoremap <leader>j :call JsBeautify()<cr>


" Bundle 'marijnh/tern_for_vim'
"- Bundle 'othree/javascript-libraries-syntax.vim'
"- Bundle 'mxw/vim-jsx'
" let g:jsx_ext_required = 0

" Bundle 'tpope/vim-vinegar'
" Bundle 'powerman/vim-plugin-ruscmd'
" Bundle 'gregsexton/MatchTag'
"- Bundle 'vim-scripts/dbext.vim'
"- Bundle 'mustache/vim-mustache-handlebars'
"- Bundle 'tpope/vim-repeat'
"- Bundle 'tpope/vim-fugitive'
"- Bundle 'tpope/vim-sensible'
"- Bundle 'mitsuhiko/vim-jinja'
"- Bundle 'cohama/agit.vim'


" ------------------------------
" Configure
" ------------------------------

set title
set nobackup
set noswapfile

set hidden
set undolevels=500
set history=500

" Localization
set langmenu=none " Always use english menu
set spelllang=en_us,ru_yo
set encoding=utf-8
set fileencodings=utf-8,cp1251,koi8-r,cp866
set termencoding=utf-8

"undo settings
set undodir=~/.vim/undofiles
set undofile

set smartcase
set hlsearch
set incsearch

syntax on
set number
set ruler
set colorcolumn=+1 "mark the ideal max text width

set list
set listchars=tab:▸\ ,trail:·,extends:❯,precedes:❮
set linebreak

set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

set autoindent
set smarttab

set wildmenu
set wildmode=longest,full
set wildignore+=*.pyc,__pycache__

set showcmd
set showmode
set cmdheight=2
set confirm
set report=0
set laststatus=2

set mouse=r
set mousemodel=popup
set mousehide
imap <S-Insert> <MiddleMouse>

" share clipboard with system clipboard
set clipboard=unnamedplus

"GVIM
if has('gui')
    set guioptions-=T   "disable panel
    set guioptions+=c   "disable dailogs
    "set guioptions-=e   "disable tabs
    "set guioptions-=m   "remove menubar

    " Disable scrollbars
    set guioptions+=LlRrb
    set guioptions-=LlRrb

    set guifont=monospace\ 8
endif

" http://blog.sanctum.geek.nz/vim-annoyances/
nnoremap <F1> <nop>
nnoremap Q <nop>
set shortmess+=I

" Don't make chaos on my display
set nowrap
set backspace=indent,eol,start
set nojoinspaces
set nofoldenable

" Vimmers, You Don’t Need NerdTree
" https://medium.com/@mozhuuuuu/vimmers-you-dont-need-nerdtree-18f627b561c3
let g:netrw_liststyle=3
nnoremap <leader>f :Explore<cr>

filetype on
filetype plugin on

autocmd BufNewFile,BufRead *.{css,less} setlocal ft=css
autocmd BufNewFile,BufRead *.{md,mdt} setlocal ft=markdown
autocmd BufNewFile,BufRead *.mustache setlocal ft=html

autocmd Syntax javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd Syntax css set omnifunc=csscomplete#CompleteCSS
autocmd Syntax html set omnifunc=htmlcomplete#CompleteTags
autocmd Syntax xml set omnifunc=xmlcomplete#CompleteTags

" Highlight insert mode
autocmd InsertEnter * set cursorline
autocmd InsertLeave * set nocursorline

set autoread
autocmd BufWinEnter,WinEnter,InsertEnter,InsertLeave * checktime
autocmd FileChangedShell * echo "Warning: File changed on disk"
autocmd BufWritePost ~/todo.rst :silent !my todo

" Sudo saves the file
command! Sw w !sudo tee % > /dev/null

" Indent blocks
vmap < <gv
vmap > >gv

" Nice scrolling if line wrap
noremap j gj
noremap k gk
noremap <Down> gj
noremap <Up> gk

nmap <leader>h :setlocal hlsearch! hlsearch?<cr>
nmap <leader>m :setlocal modifiable! modifiable?<cr>
nmap <leader>p :setlocal paste! paste?<cr>
nmap <leader>w :setlocal wrap! wrap?<cr>
nmap <leader>s :setlocal spell! spell?<cr>

" Maximize/Unmaximize window
nmap <leader>z :set winwidth=9999<cr>
nmap <leader>zz :set winwidth=1<cr><C-W>=

nmap <leader>r :source ~/.vimrc<cr>
nmap <leader>a ggVG<cr>
nmap <leader>n :lnext<cr>
nmap <leader>nn :lfirst<cr>

nmap <F2> :let @/ = '\<'.expand('<cword>').'\>'\|set hlsearch<C-M>

imap <C-f> <C-x><C-f>

" Neovim
if exists(':tnoremap')
    tnoremap <Esc> <C-\><C-n>
    let g:terminal_scrollback_buffer_size=100000
endif

" ------------------------------
" Misc
" ------------------------------
iab pybin #!/usr/bin/env python<esc>
iab pyutf # -*- coding: utf-8 -*-<esc>
iab pdb; import ptpdb; ptpdb.set_trace()<esc>
iab ipdb; import ipdb; ipdb.set_trace()<esc>
iab bpdb; import bpdb; bpdb.set_trace()<esc>
iab pprint; import pprint as _; _.pprint(
iab log; import logging; log = logging.getLogger(__name__).info

set secure  " must be written at the last.  see :help 'secure'.
