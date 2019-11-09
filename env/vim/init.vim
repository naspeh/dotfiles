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

    setlocal formatoptions=1l

    " http://vim.wikia.com/wiki/VimTip989
    setlocal wrap
    setlocal linebreak
    setlocal nolist
    setlocal showbreak=❯
    setlocal textwidth=0
    setlocal wrapmargin=0
endfun
nmap <leader>tt :call TextMode()<cr>
nmap <leader>ta :setlocal formatoptions-=l<cr>:call TextMode()<cr>

fun! Tab2()
    setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
endfun
nmap <leader>2t :call Tab2()<cr>
autocmd FileType yaml,json,javascript,css,html call Tab2()

fun! ToggleQuickfixList()
    let qnr = winnr("$")
    cwindow
    let qnr2 = winnr("$")
    if qnr == qnr2
        cclose
    endif
endfun
fun! ToggleLocationList()
    let lnr = winnr("$")
    lwindow
    let lnr2 = winnr("$")
    if lnr == lnr2
        " close all locationlist at once
        windo if &buftype == "quickfix" || &buftype == "locationlist" | lclose | endif
    endif
endfun
nmap <leader>l :call ToggleLocationList()<CR>
nmap <leader>q :call ToggleQuickfixList()<CR>

python3 << EOF
"""
Create github url and put into clipboard for line or for multi-line selection

Inspired by:
- https://github.com/k0kubun/vim-open-github
- https://github.com/tonchis/vim-to-github
"""
import re
import subprocess as sp
import vim

cmd_tpl = """
path=$(realpath "%s")
cd $(dirname $path)
echo $path
git rev-parse --show-toplevel
git remote get-url origin
git rev-parse HEAD
"""

def to_github():
    selection = 'L%s-L%s' % (
        vim.current.range.start + 1,
        vim.current.range.end + 1
    )
    cmd = ['sh', '-c', cmd_tpl % vim.current.buffer.name]
    output = sp.check_output(cmd).strip()
    full_path, root, remote, hash = output.split()
    path = re.sub(r'^%s/' % re.escape(root), '', full_path)
    if re.match('git@', remote):
        base_url = re.sub('^git@(.*?)\:', r'https://\1/', remote)
    base_url = re.sub('\.git$', '', base_url)
    urls = (
        '%s/%s/%s/%s#%s' % (base_url, t, hash, path, selection)
        for t in ('blob', 'blame')
    )
    for url in urls:
        sp.call('echo "%s" | xsel -b; sleep 1' % url, shell=True)
EOF
nmap <leader>gh :python to_github()<cr>
vmap <leader>gh :python to_github()<cr>

" ------------------------------
" Plugins activate
" ------------------------------
" Bundle 'tpope/vim-pathogen'
runtime bundle/tpope--vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

" Bundle 'altercation/vim-colors-solarized'
set background=light
colorscheme solarized

"- Bundle 'nightsense/cosmic_latte'
" set background=light
" colorscheme cosmic_latte

" Bundle 'ctrlpvim/ctrlp.vim'
let g:ctrlp_custom_ignore='\v[\/]\.(git|hg|svn)$'
let g:ctrlp_mruf_relative=1
nmap <F3> :CtrlPBuffer<cr>
imap <F3> <esc>:CtrlPBuffer<cr>
nmap <F4> :CtrlPCurWD<cr>
imap <F4> <esc>:CtrlPCurWD<cr>
nmap <F5> :CtrlPBufTag<cr>
imap <F5> <esc>:CtrlPBufTag<cr>
nmap <F6> :CtrlPBufTagAll<cr>
imap <F6> <esc>:CtrlPBufTagAll<cr>
"nmap <F7> :CtrlPQuickfix<cr>
"imap <F7> <esc>:CtrlPQuickfix<cr>

"- Bundle 'w0rp/ale' # Asynchronous Lint Engine
" Bundle 'scrooloose/syntastic'
let g:syntastic_mode_map = {
    \"mode": "passive",
    \"active_filetypes": [],
    \"passive_filetypes": []
\}
let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=0
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_enable_balloons=1
let g:syntastic_enable_highlighting=0
let g:syntastic_always_populate_loc_list=0
let g:syntastic_auto_loc_list=2
let g:syntastic_loc_list_height=2
let g:syntastic_stl_format = '[%E{E%e}%B{, }%W{W%w}]'
"let g:syntastic_python_flake8_args='--ignore=W601,E711'
let g:syntastic_javascript_checkers = ['jshint', 'eslint']
nmap <F7> :SyntasticToggleMode<cr>
nmap <F8> :SyntasticCheck<cr>:Errors<cr>

" Bundle 'tpope/vim-commentary'
vnoremap <leader>c :Commentary<cr>gv
noremap <leader>c :Commentary<cr>

" Bundle 'davidhalter/jedi-vim'
"let g:jedi#force_py_version=3
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

"- Bundle 'ervandew/supertab'
let g:SuperTabMappingForward='<nul>' " '<c-space>'
let g:SuperTabMappingBackward='<s-nul>' " '<s-c-space>'
let g:SuperTabDefaultCompletionType="<c-x><c-o>"
"let g:SuperTabContextDefaultCompletionType="<c-x><c-o>"

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

"- Bundle 'powerman/vim-plugin-ruscmd'
"- Bundle 'lyokha/vim-xkbswitch'
let g:XkbSwitchEnabled = 1
let g:XkbSwitchIMappings = ['ru']


"- Bundle 'gabrielelana/vim-markdown'
"- Bundle 'tpope/vim-markdown'

"- Bundle 'mhinz/vim-signify'
" Bundle 'Yggdroot/indentLine'
"- Bundle 'tpope/vim-fugitive'
"- Bundle 'liuchengxu/eleline.vim'

runtime macros/matchit.vim
"- Bundle 'Valloric/MatchTagAlways'
"- Bundle 'gregsexton/MatchTag'

"- Bundle 'itchyny/vim-cursorword'
"- Bundle 'itchyny/calendar.vim'
let g:calendar_google_calendar = 1
let g:calendar_google_task = 0

" TODO: frontend related
"- Bundle 'maksimr/vim-jsbeautify'
" nnoremap <leader>j :call JsBeautify()<cr>
"- Bundle 'marijnh/tern_for_vim'
"- Bundle 'posva/vim-vue'

" TODO: Try to write config from scratch with:
"- Bundle 'tpope/vim-sensible'
"- Bundle 'tpope/vim-unimpaired'

" ------------------------------
" Configure
" ------------------------------
set exrc

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


" undercurl
" https://github.com/vim/vim/issues/1306
" hi SpellBad gui=undercurl guisp=red term=undercurl cterm=undercurl
" let &t_8u = "\<Esc>[58;2;%lu;%lu;%lum"
let &t_Cs = "\e[4:3m"
let &t_Ce = "\e[4:0m"

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

" https://shapeshed.com/vim-netrw/
"let g:netrw_liststyle=3
let g:netrw_banner=0
let g:netrw_list_hide = netrw_gitignore#Hide()
nnoremap - :Explore<cr>

" https://robots.thoughtbot.com/faster-grepping-in-vim
" http://codeinthehole.com/tips/using-the-silver-searcher-with-vim/
" https://elliotekj.com/2016/11/22/setup-ctrlp-to-use-ripgrep-in-vim/
if executable('ag')
    set grepprg=ag\ --vimgrep
    set grepformat=%f:%l:%c:%m
    let g:ctrlp_user_command = 'ag -g . %s'
    let g:ctrlp_use_caching = 0

endif
if executable('rg')
  set grepprg=rg\ --vimgrep
  set grepformat=%f:%l:%c:%m
  let g:ctrlp_user_command = 'rg --files %s'
  let g:ctrlp_use_caching = 0
endif
command! -nargs=+ -complete=file -bar G silent! lgrep! <args>|lwindow|redraw!
nnoremap <leader>gg :G<SPACE>
nnoremap <leader>gv :lvimgrep //jg **

filetype on
filetype plugin on

autocmd BufNewFile,BufRead *.{css,less} setlocal ft=css
autocmd BufNewFile,BufRead *.{md,mdt} setlocal ft=markdown
autocmd BufNewFile,BufRead *.mustache setlocal ft=html

"autocmd Syntax javascript set omnifunc=javascriptcomplete#CompleteJS
"autocmd Syntax css set omnifunc=csscomplete#CompleteCSS
"autocmd Syntax html set omnifunc=htmlcomplete#CompleteTags
"autocmd Syntax xml set omnifunc=xmlcomplete#CompleteTags

" Highlight insert mode
autocmd InsertEnter * set cursorline
autocmd InsertLeave * set nocursorline

if executable('xkb-switch')
    autocmd InsertLeave * !xkb-switch -s us
endif

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
nmap <leader>f :echo @%<cr>

set iskeyword+=-
nmap <F2> :let @/ = '\<'.expand('<cword>').'\>'\|set hlsearch<C-M>

imap <C-space> <C-x><C-o>
imap <nul> <C-x><C-o>
imap <C-a> <C-x><C-o>
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
