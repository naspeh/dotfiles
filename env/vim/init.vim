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
nmap <leader>k :call ToggleQuickfixList()<CR>

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
nmap <leader>gh :python3 to_github()<cr>
vmap <leader>gh :python3 to_github()<cr>

" ------------------------------
" Plugins activate
" ------------------------------
" + https://github.com/tpope/vim-pathogen
runtime bundle/tpope--vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

" + https://github.com/altercation/vim-colors-solarized
set background=light
colorscheme solarized

" + https://github.com/romainl/flattened
" colorscheme flattened_light
set background=dark
colorscheme flattened_dark

" + https://github.com/axvr/photon.vim
" colorscheme antiphoton

" https://github.com/nightsense/cosmic_latte
" set background=light
" colorscheme cosmic_latte

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

" Check syntax in Vim asynchronously and fix files,
" with Language Server Protocol (LSP) support
"- + https://github.com/dense-analysis/ale
let g:airline#extensions#ale#enabled = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0
let g:ale_sign_column_always = 0
let g:ale_set_signs = 0
let g:ale_set_highlights = 1
" let g:ale_open_list = 1
" let g:ale_set_loclist = 0
" let g:ale_set_quickfix = 1
" nmap <F7> :ALELint<cr>
" max height for quicklist
" autocmd FileType qf 5wincmd_

" https://github.com/scrooloose/syntastic
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
let g:syntastic_enable_highlighting=1
let g:syntastic_always_populate_loc_list=0
let g:syntastic_auto_loc_list=2
let g:syntastic_loc_list_height=5
let g:syntastic_stl_format = '[%E{E%e}%B{, }%W{W%w}]'
"let g:syntastic_python_flake8_args='--ignore=W601,E711'
let g:syntastic_javascript_checkers = ['jshint', 'eslint']
let g:syntastic_go_checkers = ['govet', 'errcheck', 'go']
" nmap <F7> :SyntasticToggleMode<cr>
nmap <F8> :SyntasticCheck<cr>:Errors<cr>

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

" https://github.com/davidhalter/jedi-vim
"let g:jedi#force_py_version=3
" let g:jedi#auto_initialization=1
" let g:jedi#auto_vim_configuration=1
" let g:jedi#use_tabs_not_buffers=0
" let g:jedi#completions_enabled=1
" let g:jedi#smart_auto_mappings = 0
" let g:jedi#popup_on_dot=0
" let g:jedi#popup_select_first=1
" let g:jedi#show_call_signatures=2
" let g:jedi#rename_command=0
" let g:jedi#completions_command="<C-Space>"
" let g:jedi#goto_definitions_command="<leader>d"
" let g:jedi#goto_assignments_command="<leader>g"
" let g:jedi#documentation_command="<leader>jo"
" let g:jedi#usages_command="<leader>jd"
" let g:jedi#goto_stubs_command="<leader>js"
" nmap <leader>pp :call jedi#force_py_version_switch()<cr>

" https://github.com/ervandew/supertab
let g:SuperTabMappingForward='<nul>' " '<c-space>'
let g:SuperTabMappingBackward='<s-nul>' " '<s-c-space>'
let g:SuperTabDefaultCompletionType="<c-x><c-o>"
"let g:SuperTabContextDefaultCompletionType="<c-x><c-o>"

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

" https://github.com/powerman/vim-plugin-ruscmd
" https://github.com/lyokha/vim-xkbswitch
let g:XkbSwitchEnabled = 1
let g:XkbSwitchIMappings = ['ru']


" https://github.com/gabrielelana/vim-markdown
" https://github.com/tpope/vim-markdown

" https://github.com/Yggdroot/indentLine - A vim plugin to display the indention levels with thin vertical lines
" https://github.com/mhinz/vim-signify - Show a diff using Vim its sign column.
" https://github.com/liuchengxu/eleline.vim - Another elegant statusline for vim

runtime macros/matchit.vim
" https://github.com/Valloric/MatchTagAlways
" https://github.com/gregsexton/MatchTag

" https://github.com/itchyny/vim-cursorword - Underlines the word under the cursor
" https://github.com/RRethy/vim-illuminate - Vim plugin for automatically highlighting other uses of the word under the cursor

" https://github.com/itchyny/calendar.vim
let g:calendar_google_calendar = 1
let g:calendar_google_task = 0

" + https://github.com/tpope/vim-fugitive - A Git wrapper so awesome, it should be illegal
" https://github.com/lambdalisue/gina.vim -  is a plugin to asynchronously control git repositories.
" https://github.com/zivyangll/git-blame.vim - See Git Blame information in the status bar for the currently selected line.
nmap <leader>gb :<C-u>call gitblame#echo()<cr>
vmap <leader>gb :<C-u>call gitblame#echo()<cr>

" -- git command on current file
fun! GitCommand(command)
  silent! !clear
  exec "!git " . a:command . " %"
endfun
" -- git diff for current file
" map <leader>gd :call GitCommand("diff") <CR>
" -- git log for current file
"map <leader>gl :call GitCommand("log -p") <CR>
" -- git blame for current file
"map <leader>gb :call GitCommand("blame") <CR>

" + https://github.com/rhysd/git-messenger.vim
let g:git_messenger_include_diff = "current"
let g:git_messenger_no_default_mappings = "v:true"
nmap <leader>gm <Plug>(git-messenger)

" https://github.com/psf/black
" https://github.com/romainl/vim-cool - Vim-cool disables search highlighting when you are done searching and re-enables it when you search again.

" https://github.com/fatih/vim-go

" https://github.com/vim-scripts/Smart-Tabs - Use tabs for indent, spaces for alignment
" https://github.com/dpc/vim-smarttabs

" Writting
" + https://github.com/reedes/vim-pencil Rethinking Vim as a tool for writers
" https://github.com/rhysd/vim-grammarous - A powerful grammar checker for Vim using LanguageTool.
" https://github.com/amperser/proselint - A linter for prose.
" https://github.com/reedes/vim-wordy - Uncover usage problems in your writing
" https://github.com/raghur/vim-ghost - Vim/Nvim client for GhostText - Edit browser text areas in Vim/Neovim

" TODO: Interesting
" https://github.com/tmsvg/pear-tree - A Vim auto-pair plugin that supports multi-character pairs, intelligent matching, and more
" https://github.com/sbdchd/neoformat
" https://github.com/maralla/validator.vim - Syntax check framework for vim which checks syntax on the fly asynchronously.
" https://github.com/maralla/completor.vim - is an asynchronous code completion framework for vim8.
" https://github.com/liuchengxu/vim-which-key -  displays available keybindings in popup.
" https://github.com/t9md/vim-quickhl - quickly highlight <cword> or visually selected word
" https://github.com/tyru/caw.vim - comment plugin

" + https://github.com/Shougo/echodoc.vim - Print documents in echo area.
let g:echodoc#enable_at_startup = 1
" let g:echodoc#type = 'popup'
" let g:echodoc#type = 'floating'
" highlight link EchoDocPopup Pmenu

" https://github.com/ajh17/VimCompletesMe - A super simple, super minimal, super light-weight tab-completion plugin for Vim.
let b:vcm_tab_complete = "omni"

" + https://github.com/neomake/neomake - is a plugin for Vim/Neovim to asynchronously run programs.
" call neomake#configure#automake('rnw', 1000)
" let g:neomake_place_signs = 0
let g:neomake_open_list = 2
" let g:neomake_list_height = 5
nmap <F8> :Neomake<cr>


" https://github.com/mhinz/vim-grepper - Helps you win at grep.
" let g:grepper = {}
" let g:grepper.tools = ['rg', 'ag', 'git']
" nnoremap <leader>gg :Grepper<cr>
" nmap gs <plug>(GrepperOperator)
" xmap gs <plug>(GrepperOperator)

" https://github.com/yegappan/grep - Plugin to integrate Grep search tools with Vim
" nmap <F10> :Rg<cr>
" nmap <leader>gg :Rg<cr>

" + https://github.com/wincent/ferret
let g:FerretMap=0
nmap <F10> <Plug>(FerretLack)
nmap <leader>gg <Plug>(FerretLack)


" + https://github.com/eugen0329/vim-esearch - Perform search in files easily
let g:esearch = {}
let g:esearch.out = 'qflist'

" https://github.com/pechorin/any-jump.vim - Jump to any definition and references eye IDE madness without overhead

" TODO: frontend related
" https://github.com/maksimr/vim-jsbeautify
" nnoremap <leader>j :call JsBeautify()<cr>
" https://github.com/marijnh/tern_for_vim
" https://github.com/posva/vim-vue

" TODO: Try to write config from scratch with:
" https://github.com/tpope/vim-sensible
" https://github.com/tpope/vim-unimpaired

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

filetype on
filetype plugin on

autocmd BufNewFile,BufRead *.{css,less} setlocal ft=css
autocmd BufNewFile,BufRead *.{md,mdt} setlocal ft=markdown
autocmd BufNewFile,BufRead *.mustache setlocal ft=html
autocmd BufNewFile,BufRead *.go setlocal noexpandtab
autocmd FileType python setlocal colorcolumn=80

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
