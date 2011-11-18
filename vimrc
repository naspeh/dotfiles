"Вырубаем режим совместимости с VI:
set nocompatible

" Localization
set langmenu=none            " Always use english menu
set keymap=russian-jcukenwin " Переключение раскладок клавиатуры по <C-^>
set iminsert=0               " Раскладка по умолчанию - английская
set imsearch=0               " Раскладка по умолчанию при поиске - английская
set spelllang=en,ru          " Языки для проверки правописания
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
set smartindent
set smarttab

" Поиск
set ignorecase
set hlsearch
set incsearch

syntax on
set number
let python_highlight_all = 1

set list
set listchars=tab:>-,trail:~,extends:+,precedes:+
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
set wildcharm=<TAB>
set wildignore=*.pyc
" Удалить pythonhelper.vim, чтоб эта строка отображалась
set statusline=%<%f%h%m%r%=%{fugitive#statusline()}\ (%{&ff}\ %{&ft}\ %{&encoding})\ %b\ 0x%B\ %l,%c%V\ %P
set laststatus=2
" Показывать незавершенные команды в статусбаре
set showcmd
hi StatusLineBufferNumber guifg=fg guibg=bg gui=bold
set cmdheight=2
" использовать диалоги вместо сообщений об ошибках
set confirm
" использовать сокращённые диалоги
"set shortmess=fimnrxoOtTI
" report all changes
set report=0
" Не перерисовывать окно при работе макросов
set lazyredraw
set ttyfast

" Поддержка мыши
set mouse=a
set mousemodel=popup
set mousehide

" Перемещать курсор на следующую строку при нажатии на клавиши вправо-влево и пр.
set whichwrap+=<,>,[,]

if has('gui')
    " Скрыть панель в gui версии
    set guioptions-=T
    " Отключаем графические диалоги
    set guioptions+=c
    " Отключаем графические табы (текстовые занимают меньше места)
    "set guioptions-=e

    "set guifont=monospace\ 9

    " Filename
    :amenu 20.351 &Edit.Copy\ FileName :let @*=expand("%:t")<CR>
    :amenu 20.353 &Edit.Copy\ FullPath :let @*=expand("%:p")<CR>

endif


" ------------------------------
" Plugins activate
" ------------------------------
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

Bundle 'scrooloose/nerdtree'
let NERDTreeWinSize = 35
let NERDTreeChDirMode=2
let NERDTreeShowBookmarks=1

Bundle 'bufexplorer.zip'
let g:bufExplorerShowRelativePath=1
let g:bufExplorerSplitOutPathName=0
let g:bufExplorerSortBy='fullpath'
let g:bufExplorerShowTabBuffer=1


Bundle 'taglist.vim'
let Tlist_Compact_Format          = 1   " Do not show help
let Tlist_Enable_Fold_Column      = 0   " Don't Show the fold indicator column
let Tlist_Exit_OnlyWindow         = 1   " If you are last kill your self
let Tlist_GainFocus_On_ToggleOpen = 1   " Jump to taglist window to open
let Tlist_Show_One_File           = 1   " Displaying tags for only one file
let Tlist_Use_Right_Window        = 0   " Split to rigt side of the screen
let Tlist_Use_SingleClick         = 1   " Single mouse click open tag
let Tlist_WinWidth                = 35  " Taglist win width
let Tlist_Display_Tag_Scope       = 1   " Show tag scope next to the tag name

Bundle 'AutoComplPop', 'L9'
let g:acp_ignorecaseOption = 0

Bundle 'tpope/vim-fugitive'

"Bundle 'ack.vim'
"let g:ackprg='ack-grep --with-filename --nocolor --nogroup --column'
Bundle 'EasyGrep'

Bundle 'pyflakes'
Bundle 'python.vim'
Bundle 'pep8--Driessen'
"Bundle 'https://github.com/jbking/vim-pep8/'
"Bundle 'python_check_syntax.vim'

Bundle 'jQuery'
Bundle 'jslint.vim'
Bundle 'Jinja'
Bundle 'othree/html5.vim'
Bundle 'othree/html5-syntax.vim'
Bundle 'cakebaker/scss-syntax.vim'
Bundle 'Markdown'

"Bundle 'https://github.com/jeetsukumaran/vim-buffergator.git'
let g:buffergator_sort_regime = 'filepath'
let g:buffergator_display_regime = 'filepath'
let g:buffergator_viewport_split_policy = 'B'

if v:version >= 703
    Bundle 'Gundo'
    let g:gundo_width = 35
endif

" Ropevim
"let g:ropevim_vim_completion=1
"let g:ropevim_extended_complete=0
let g:ropevim_guess_project=1
"let g:ropevim_enable_autoimport=0
"let g:ropevim_codeassist_maxfixes=3
"let g:ropevim_autoimport_modules = []

"Bundle 'pyflakes.vim'
"let g:pyflakes_use_quickfix = 0
let no_pyflakes_maps = 1

"Bundle 'minibufexpl.vim'
"let g:miniBufExplVSplit = 20   " column width in chars
"let g:miniBufExplMaxSize = 20
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplUseSingleClick = 1
let g:miniBufExplorerMoreThanOne = 1
let g:miniBufExplModSelTarget = 1
"let g:miniBufExplForceSyntaxEnable = 1
let g:miniBufExplSplitBelow = 0

Bundle 'LustyJuggler'
Bundle 'unite.vim'

filetype plugin indent on     " required!


" ------------------------------
" Functions
" ------------------------------
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

fun! TrimSpaces()
  if !&binary && &filetype != 'diff'
    normal mz
    normal Hmy
    %s/\s\+$//e
    normal 'yz<CR>
    normal `z
  endif
endfun

fun! MapDo(key, cmd)
    execute "nmap ".a:key." " . ":".a:cmd."<CR>"
    execute "cmap ".a:key." " . "<C-C>:".a:cmd."<CR>"
    execute "imap ".a:key." " . "<Esc>:".a:cmd."<CR>"
    execute "vmap ".a:key." " . "<Esc>:".a:cmd."<CR>gv"
endfun

fun! MapToggle(key, opt)
    call MapDo(a:key, "set ".a:opt."! ".a:opt."?")
endfun

fun! LeaderToggle(key, opt)
    "nnoremap <leader><space> :nohls<CR>
    "nmap <silent> ,p :set invpaste<CR>:set paste?<CR>
    execute "nmap <leader>".a:key." :setlocal ".a:opt."! ".a:opt."?<cr>"
endfun


" ------------------------------
" Hot keys
" ------------------------------

" Заставляет комбинацию shift-insert работать как в Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

" Text navigation in insert mode
imap <M-l> <Right>
imap <M-h> <Left>
imap <M-j> <Down>
imap <M-k> <Up>

" Nice scrolling if line wrap
noremap j gj
noremap k gk
noremap <Down> gj
noremap <Up> gk

" Fast scrool
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" set custom map leader to ','
let mapleader = ","

" Leader
"call LeaderToggle('<space>', 'hlsearch')
call LeaderToggle('h', 'hlsearch')
call LeaderToggle('p', 'paste')
call LeaderToggle('w', 'wrap')
call LeaderToggle('s', 'spell')
call LeaderToggle('m', 'modifiable')

" .vimrc reload
nmap <leader>r :source ~/.vimrc<cr>
nmap <leader>c :cwin<cr>
nmap <leader>cc :cclose<cr>
nmap <leader>a ggVG<cr>
"nmap <leader>b :LustyJuggler<cr>
nmap <leader>b :Unite buffer<cr>

" New line and exit from insert mode
"map <S-O> i<CR><ESC>

" CTRL-F для omni completion
imap <C-F> <C-X><C-O>

" < & > - делаем отступы для блоков
vmap < <gv
vmap > >gv

" F2 - Previous window
"call MapDo('<F2>', ':wincmd p')
call MapDo('<F2>', 'wincmd w')

" F3 - BufExplorer
call MapDo('<F3>', 'BufExplorer')
"call MapDo('<F3>', 'TSelectBuffer')

" F4 - NERDTree
call MapDo('<F4>', 'TlistClose<cr>:NERDTreeToggle')

" F5 - ctags
call MapDo('<F5>', 'NERDTreeClose<cr>:TlistToggle')

" F6 - Gundo
"set pastetoggle=<F6>
call MapDo('<F6>', 'GundoToggle')

" F7
"let g:pcs_hotkey='<F7>'
call MapDo('<F7>', 'call Pyflakes()')
autocmd BufWritePost *.py call Pyflakes()

" F8 - Pep8
call MapDo('<F8>', 'call Pep8()')
"call MapDo('<F8>', 'Pep8Update')

" F9 - Trim trailing spaces
call MapDo('<F9>', 'call TrimSpaces()')

" F11
"call MapDo('<F11>', 'TMiniBufExplorer')
call MapDo('<F11>', 'call TextWidth()')


" ------------------------------
" Autocommands
" ------------------------------

filetype on            " enables filetype detection
filetype plugin on     " enables filetype specific plugins
"filetype plugin indent on

autocmd BufNewFile,BufRead *.{html,htm} setlocal ft=html
autocmd BufNewFile,BufRead *.{less,css} setlocal ft=css
autocmd BufNewFile,BufRead *.{md,mkd,mdt} setlocal ft=markdown

autocmd FileType python call TextWidth()
"autocmd FileType python set omnifunc=pythoncomplete#Complete
"autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
"autocmd FileType css set omnifunc=csscomplete#CompleteCSS
"autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
"autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags

autocmd FileType js,css,html setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2

" Highlight insert mode
autocmd InsertEnter * set cursorline
autocmd InsertLeave * set nocursorline

" Auto reload vim settins
"au! bufwritepost rc.vim source ~/.vimrc


" ------------------------------
" Misc
" ------------------------------
iab pybin #!/usr/bin/env python<esc>
iab pyutf8 # -*- coding: utf-8 -*-<esc>
iab pytrace import pdb; pdb.set_trace()<esc>

python << EOF
import site
site.addsitedir(
    '/usr/local/lib/python2.7/dist-packages'
)
EOF

set secure  " must be written at the last.  see :help 'secure'.
