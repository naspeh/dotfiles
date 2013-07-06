set nocompatible
let mapleader=","

" ------------------------------
" Functions
" ------------------------------
fun! MapDo(key, cmd)
    execute "nmap ".a:key." " . a:cmd
    execute "cmap ".a:key." " . "<C-C>".a:cmd
    execute "imap ".a:key." " . "<Esc>".a:cmd
    execute "vmap ".a:key." " . "<Esc>".a:cmd."gv"
endfun

fun! MapToggle(key, opt)
    call MapDo(a:key, "set ".a:opt."! ".a:opt."?")
endfun

fun! LeaderToggle(key, opt)
    execute "nmap <leader>".a:key." :setlocal ".a:opt."! ".a:opt."?<cr>"
endfun

fun! VarToggle(name, ...)
    if a:0 >= 1
        let v1=a:1
    else
        let v1=0
    endif
    if a:0 >= 2
        let v2=a:2
    else
        let v2=1
    endif
    if eval(a:name) == v1
        execute 'let '.a:name.'="'.v2.'"'
    else
        execute 'let '.a:name.'="'.v1.'"'
    endif
    echo a:name.'='.eval(a:name)
endfun

fun! TextWidth()
    if v:version >= 703
        " highlight column 80
        setlocal colorcolumn=80
    else
        " Подсветка больше 80 символов
        highlight OverLength ctermbg=grey ctermfg=black guibg=#eeeeff
        match OverLength /\%80v.\+/
    endif
endfun
call MapDo('<F11>', ':call TextWidth()<cr>')
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
call MapDo('<F9>', ':call TrimSpaces()<cr>')

fun! TextMode()
    setlocal textwidth=80
    set formatoptions+=l
    setlocal nonumber
    setlocal wrap
    setlocal nolist
    setlocal nocursorline
    setlocal spell
    " Перемещать курсор на следующую строку при нажатии на клавиши вправо-влево и пр.
    set whichwrap+=<,>,[,]
endfun
nmap <leader>tt :call TextMode()<cr>


" ------------------------------
" Plugins activate
" ------------------------------
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'


Bundle 'tpope/vim-fugitive'
Bundle 'powerman/vim-plugin-ruscmd'
"Bundle 'lambdalisue/vim-python-virtualenv'
Bundle 'jQuery'
"Bundle 'hallettj/jslint.vim'
Bundle 'Jinja'
"Bundle 'othree/html5.vim'
Bundle 'othree/html5-syntax.vim'
Bundle 'gregsexton/MatchTag'
Bundle 'lepture/vim-css'
"Bundle 'hail2u/vim-css3-syntax'
"Bundle 'cakebaker/scss-syntax.vim'
"Bundle 'groenewege/vim-less'
"Bundle 'KohPoll/vim-less'
"Bundle 'Markdown'
"Bundle 'plasticboy/vim-markdown'

Bundle 'maksimr/vim-jsbeautify'
noremap <leader>j :call JsBeautify()<cr>

"http://vimcasts.org/episodes/aligning-text-with-tabular-vim/
Bundle "godlygeek/tabular"


Bundle 'scrooloose/syntastic'
"g:syntastic_less_use_less_lint=1
let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=0
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_enable_balloons=1
let g:syntastic_enable_highlighting=0
let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list=2
let g:syntastic_loc_list_height=2
let g:syntastic_stl_format = '[%E{Err: #%e}%B{, }%W{Warn: #%w}]'
nmap <leader>s :SyntasticToggleMode<cr>
call MapDo('<F8>', ':Errors<cr>')
nmap <leader>ss :call VarToggle('g:syntastic_auto_loc_list', 1, 2)<cr>


Bundle 'milkypostman/vim-togglelist'
"The default mappings are:
"nmap <leader>l :call ToggleLocationList()<CR>
"nmap <leader>q :call ToggleQuickfixList()<CR>


Bundle 'scrooloose/nerdtree'
"call MapDo('<F4>', ':NERDTreeToggle<cr>')
call MapDo('<leader>f', ':NERDTreeToggle<cr>')
let NERDTreeWinSize=35
let NERDTreeChDirMode=2
let NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.pyc$']


Bundle 'majutsushi/tagbar'
"call MapDo('<F5>', ':TagbarToggle<cr>')
call MapDo('<leader>t', ':TagbarToggle<cr>')
let g:tagbar_autofocus=1
let g:tagbar_sort=1
let g:tagbar_foldlevel=0


"Bundle 'AutoComplPop', 'L9'
"let g:acp_enableAtStartup=1
let g:acp_ignorecaseOption=0


Bundle 'Shougo/neocomplete.vim'
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#enable_fuzzy_completion = 0
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
let g:neocomplete#enable_insert_char_pre = 1
inoremap <expr><C-h> pumvisible() ? neocomplete#close_popup() : "\<C-h>"


"Bundle 'EasyGrep'
Bundle 'grep.vim'
let GrepSkipDirs1='.git .hg __pycache__'
let GrepSkipDirs2=GrepSkipDirs1.' migrations'
let GrepSkipDirs=GrepSkipDirs2
let Grep_Skip_Files='*.bak *~ *.pyc'
noremap <leader>gg :call VarToggle('g:GrepSkipDirs', GrepSkipDirs1, GrepSkipDirs2)<cr>


"Bundle 'python.vim'
Bundle 'hdima/python-syntax'
let python_highlight_all=1


Bundle 'kien/ctrlp.vim'
call MapDo('<F3>', ':CtrlPBuffer<cr>')
call MapDo('<F4>', ':CtrlPCurWD<cr>')
call MapDo('<F5>', ':CtrlPBufTag<cr>')
let g:ctrlp_custom_ignore={
    \'dir':  '\.git$\|\.hg$\|\.svn$\|__pycache__$',
\}
let g:ctrlp_extensions=['tag', 'quickfix', 'dir', 'line']
let g:ctrlp_working_path_mode=0
let g:ctrlp_mruf_relative=1
"let g:ctrlp_regexp=0
let g:ctrlp_ignore_=' | grep -v -e /migrations/ -e ^__pycache__'
let g:ctrlp_user_command={
    \'types': {
        \1: ['.git', 'cd %s && git ls-files' . g:ctrlp_ignore_],
        \2: ['.hg', 'hg --cwd %s locate -I .' . g:ctrlp_ignore_],
    \},
    \'fallback': 'find %s -type f' . g:ctrlp_ignore_
\}


Bundle 'xterm16.vim'
let xterm16_colormap='softlight'
let xterm16_brightness='high'
color xterm16


Bundle 'scrooloose/nerdcommenter'
let NERDCreateDefaultMappings=0
nnoremap <leader>c :call NERDComment('n', 'AlignLeft')<cr>
vnoremap <leader>c :call NERDComment('x', 'AlignLeft')<cr>gv
nnoremap <leader>cc :call NERDComment('n', 'Uncomment')<cr>
vnoremap <leader>cc :call NERDComment('x', 'Uncomment')<cr>gv


Bundle 'davidhalter/jedi-vim'
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#rename_command = 0
let g:jedi#related_names_command = 0
let g:jedi#popup_on_dot = 0
let g:jedi#show_function_definition = 0
let g:jedi#autocompletion_command = "<C-Space>"


" ------------------------------
" Configure
" ------------------------------

" set window title
set title

" Localization
set langmenu=none            " Always use english menu
set keymap=russian-jcukenwin " Переключение раскладок клавиатуры по <C-^>
set iminsert=0               " Раскладка по умолчанию - английская
set imsearch=0               " Раскладка по умолчанию при поиске - английская
set spelllang=en_us,ru_yo    " Языки для проверки правописания
set encoding=utf-8
set fileencodings=utf-8,cp1251,koi8-r,cp866
set termencoding=utf-8

" Не создавать резервных копий файлов
set nobackup
set noswapfile

set hidden
set undolevels=500
set history=500
" Включение отображения позиции курсора (всё время)
set ruler

" Включить автоотступы
set autoindent
"set smartindent
set smarttab

" Поиск
"set ignorecase
set hlsearch
set incsearch

syntax on
set number

set list
set listchars=tab:▸\ ,trail:·,extends:❯,precedes:❮
set linebreak

" Don't make chaos on my display
set nowrap
set backspace=indent,eol,start
set nojoinspaces
set nofoldenable

" Преобразовать Табы в пробелы
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

" Формат строки состояния
set wildmenu
set wildmode=longest,full
set wildignore=*.pyc
"set wildcharm=<TAB>
set statusline=%<%f%h%m%r%=%{fugitive#statusline()}\ (%{&ff}\ %{&ft}\ %{&encoding})
set statusline+=\ %b\ 0x%B\ %l,%c%V\ %P
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set laststatus=2
" Показывать незавершенные команды в статусбаре
set showcmd
"hi StatusLineBufferNumber guifg=fg guibg=bg gui=bold
set cmdheight=2
" использовать диалоги вместо сообщений об ошибках
set confirm
" report all changes
set report=0

" Поддержка мыши
set mouse=r
set mousemodel=popup
set mousehide

" share clipboard with system clipboard
set clipboard=unnamedplus

" Перемещать курсор на следующую строку при нажатии на клавиши вправо-влево и пр.
"set whichwrap+=<,>,[,]

"GVIM
if has('gui')
    " Скрыть панель в gui версии
    set guioptions-=T
    " Отключаем графические диалоги
    set guioptions+=c
    " Отключаем графические табы (текстовые занимают меньше места)
    "set guioptions-=e

    " Disable scrollbars
    set guioptions+=LlRrb
    set guioptions-=LlRrb

    set guifont=monospace\ 8

    " Filename
    :amenu 20.351 &Edit.Copy\ FileName :let @*=expand("%:t")<CR>
    :amenu 20.353 &Edit.Copy\ FullPath :let @*=expand("%:p")<CR>

    "set go-=m "remove menubar
endif

" http://blog.sanctum.geek.nz/vim-annoyances/
nnoremap <F1> <nop>
nnoremap Q <nop>
set shortmess+=I

filetype on            " enables filetype detection
filetype plugin on     " enables filetype specific plugins
"filetype plugin indent on

"autocmd BufNewFile,BufRead *.{html,htm} setlocal ft=html
autocmd BufNewFile,BufRead *.{css,less} setlocal ft=css
autocmd BufNewFile,BufRead *.{md,mkd,mdt} setlocal ft=markdown
autocmd BufNewFile,BufRead *.t2t setlocal ft=txt2tags

set completeopt-=preview
"autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType css,less set omnifunc=csscomplete#CompleteCSS
"autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
"autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags

"autocmd FileType js,css,html setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2

" Highlight insert mode
autocmd InsertEnter * set cursorline
autocmd InsertLeave * set nocursorline

set autoread
autocmd BufWinEnter,WinEnter,InsertEnter,InsertLeave * checktime
autocmd FileChangedShell * echo "Warning: File changed on disk"

" Заставляет комбинацию shift-insert работать как в Xterm
imap <S-Insert> <MiddleMouse>

" < & > - делаем отступы для блоков
vmap < <gv
vmap > >gv

" Nice scrolling if line wrap
noremap j gj
noremap k gk
noremap <Down> gj
noremap <Up> gk

" Easy buffer navigation
noremap <C-l>  <C-w>l
noremap <C-h>  <C-w>h
noremap <C-j>  <C-w>j
noremap <C-k>  <C-w>k

" Leader
call LeaderToggle('h', 'hlsearch')
call LeaderToggle('p', 'paste')
call LeaderToggle('w', 'wrap')
call LeaderToggle('s', 'spell')
call LeaderToggle('m', 'modifiable')

nmap <leader>2t :setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2<cr>
nmap <leader>r :source ~/.vimrc<cr>
"nmap <leader>cc :cclose<cr>
"nmap <leader>c :copen<cr>
nmap <leader>a ggVG<cr>
nmap <leader>n :lnext<cr>
nmap <leader>nn :lfirst<cr>

nnoremap <F2> :let @/ = '\<'.expand('<cword>').'\>'\|set hlsearch<C-M>

" ------------------------------
" Misc
" ------------------------------
iab pybin #!/usr/bin/env python<esc>
iab pyutf # -*- coding: utf-8 -*-<esc>
iab pyutf8 # -*- coding: utf-8 -*-<esc>
iab pdb; import pdb; pdb.set_trace()<esc>
iab ipdb; import ipdb; ipdb.set_trace()<esc>

set secure  " must be written at the last.  see :help 'secure'.
