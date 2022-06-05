" vim:ft=vim
set nocompatible
let mapleader=","

" ------------------------------
" Functions
" ------------------------------
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
nmap <leader>k :call ToggleQuickfixList()<CR>

python3 << EOF
"""
Create github/gitlab url and put into clipboard for line or for multi-line selection

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

def push_git_urls_to_clipboard():
    selection = {vim.current.range.start + 1, vim.current.range.end + 1}
    selection = '-'.join('L%s' % i for i in selection if i)
    cmd = ['sh', '-c', cmd_tpl % vim.current.buffer.name]
    output = sp.check_output(cmd).decode().strip()
    full_path, root, remote, hash = output.split()
    path = re.sub(r'^%s/' % re.escape(root), '', full_path)
    base_url = remote
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
nmap <leader>gh :python3 push_git_urls_to_clipboard()<cr>
vmap <leader>gh :python3 push_git_urls_to_clipboard()<cr>

" ------------------------------
" Plugins activate
" ------------------------------
" + https://github.com/tpope/vim-pathogen
runtime bundle/tpope--vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

" + https://github.com/romainl/flattened
" colorscheme flattened_light
set background=dark
colorscheme flattened_dark

" + https://github.com/ctrlpvim/ctrlp.vim
let g:ctrlp_custom_ignore='\v[\/]\.(git|hg|svn)$'
let g:ctrlp_mruf_relative=1
let g:ctrlp_regexp = 0
nmap <F3> :CtrlPBuffer<cr>
imap <F3> <esc>:CtrlPBuffer<cr>
nmap <F4> :CtrlPMixed<cr>
imap <F4> <esc>:CtrlPMixed<cr>
nmap <F5> :CtrlPBufTag<cr>
imap <F5> <esc>:CtrlPBufTag<cr>
"nmap <F6> :CtrlPBufTagAll<cr>
"imap <F6> <esc>:CtrlPBufTagAll<cr>
nmap <F6> :CtrlPCurWD<cr>
imap <F6> <esc>:CtrlPCurWD<cr>
nmap <F7> :CtrlPUndo<cr>
imap <F7> <esc>:CtrlPUndo<cr>

" + https://github.com/prabirshrestha/vim-lsp - async language server protocol plugin for vim and neovim
" https://github.com/prabirshrestha/asyncomplete.vim
" https://github.com/prabirshrestha/asyncomplete-lsp.vim
" https://github.com/mattn/vim-lsp-settings
" augroup LspGo
"   au!
"   autocmd User lsp_setup call lsp#register_server({
"       \ 'name': 'go-lang',
"       \ 'cmd': {server_info->['gopls']},
"       \ 'whitelist': ['go'],
"       \ })
"   autocmd FileType go setlocal omnifunc=lsp#complete
"   autocmd FileType go nmap <buffer> gd <plug>(lsp-definition)
"   autocmd FileType go nmap <buffer> ,n <plug>(lsp-next-error)
"   autocmd FileType go nmap <buffer> ,p <plug>(lsp-previous-error)
" augroup END

" autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
" set completeopt-=preview
set completeopt=menuone,longest,noinsert,noselect
let g:lsp_async_completion = 1
let g:lsp_diagnostics_enabled = 0
let g:lsp_signs_enabled = 0
" let g:lsp_log_file = '/tmp/lsp.log'
" let g:lsp_log_verbose = 0
if executable('pylsp')
    autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'pylsp',
        \ 'cmd': {server_info->['pylsp']},
        \ 'allowlist': ['python'],
        \ })
endif
if executable('pyls')
    autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'allowlist': ['python'],
        \ })
endif
if executable('gopls')
   autocmd User lsp_setup call lsp#register_server({
       \ 'name': 'go-lang',
       \ 'cmd': {server_info->['gopls']},
       \ 'allowlist': ['go'],
       \ })
endif
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nmap <leader>d <plug>(lsp-definition)
    " nmap <F8> :LspDocumentDiagnostics<cr>

    " refer to doc to add more commands
endfunction
augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" + https://github.com/tpope/vim-commentary
vnoremap <leader>c :Commentary<cr>gv
noremap <leader>c :Commentary<cr>

" + https://github.com/itchyny/vim-gitbranch
" + https://github.com/vim-airline/vim-airline
" + https://github.com/vim-airline/vim-airline-themes
let g:airline_theme='solarized'
if !exists('g:airline_symbols')
    let g:airline_symbols={}
endif
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_section_b='⎇  %{gitbranch#name()}'

runtime macros/matchit.vim

" Writting
" + https://github.com/reedes/vim-pencil Rethinking Vim as a tool for writers
nmap <leader>tt :PencilToggle<cr>

" + https://github.com/neomake/neomake - is a plugin for Vim/Neovim to asynchronously run programs.
" call neomake#configure#automake('rnw', 1000)
" let g:neomake_place_signs = 0
let g:neomake_open_list = 2
" let g:neomake_list_height = 5
nmap <F8> :Neomake<cr>

" + https://github.com/wincent/ferret
let g:FerretMap=0
nmap <F10> <Plug>(FerretLack)
nmap <leader>gg <Plug>(FerretLack)

"+ https://github.com/pechorin/any-jump.vim - Jump to any definition and references eye IDE madness without overhead
" + https://github.com/editorconfig/editorconfig-vim

" https://github.com/ms-jpq/coq_nvim Fast as FUCK nvim completion. SQLite, concurrent scheduler, hundreds of hours of optimization.
" https://github.com/ms-jpq/chadtree File manager for Neovim. Better than NERDTree.

" TODO: Try to write config from scratch with:
" https://github.com/tpope/vim-sensible

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
set undodir=~/.vim-undofiles
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

"set list
"set listchars=tab:▸\ ,trail:·,extends:❯,precedes:❮
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
let g:netrw_banner=0
" let g:netrw_liststyle=3
" let g:netrw_list_hide = netrw_gitignore#Hide()
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

filetype on
filetype plugin on

autocmd BufNewFile,BufRead *.{css,less} setlocal ft=css
autocmd BufNewFile,BufRead *.{md,mdt} setlocal ft=markdown
autocmd BufNewFile,BufRead *.mustache setlocal ft=html
autocmd BufNewFile,BufRead *.go setlocal noexpandtab
autocmd FileType python setlocal colorcolumn=80

" Highlight insert mode
autocmd InsertEnter * set cursorline
autocmd InsertLeave * set nocursorline

if executable('xkb-switch')
    autocmd InsertLeave * !xkb-switch -s us
endif

set autoread
autocmd BufWinEnter,WinEnter,InsertEnter,InsertLeave * checktime
autocmd FileChangedShell * echo "Warning: File changed on disk"

" Sudo saves the file
command! Sw w !sudo tee % > /dev/null

" Indent blocks
vmap < <gv
vmap > >gv

" Nice scrolling if line wrap
" noremap j gj
" noremap k gk
" noremap <Down> gj
" noremap <Up> gk

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
nmap <leader>fj :%!python -m json.tool --sort-keys --indent=2<cr>

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
    let g:python3_host_prog = "/usr/bin/python3"
endif

" ------------------------------
" Misc
" ------------------------------
iab pybin #!/usr/bin/env python<esc>
iab pyutf # -*- coding: utf-8 -*-<esc>
iab pdb; import pdb; pdb.set_trace()<esc>
iab ipdb; import ipdb; ipdb.set_trace()<esc>
iab pprint; import pprint as _; _.pprint(
iab log; import logging; log = logging.getLogger(__name__).info

set secure  " must be written at the last.  see :help 'secure'.
