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
"set statusline=%<%f\ [%R%W]%y[%{&encoding}\]%1*%{(&modified)?'\ [+]\ ':''}%*%=%c%V,%l\ %P\ [%n]
"set statusline=%<%f\ %y[%{&encoding}\]%1*%{(&modified)?'\ [+]\ ':''}%*%=%c%V,%l\ %P\ [%n]
"set statusline=[%l,%v\ %P%M]\ %f\ %r%h%w\ (%{&ff}\ %{&ft}\ %{&encoding})\ %{fugitive#statusline()}
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

    set guifont=monospace\ 9

    " Filename
    :amenu 20.351 &Edit.Copy\ FileName :let @*=expand("%:t")<CR>
    :amenu 20.353 &Edit.Copy\ FullPath :let @*=expand("%:p")<CR>

endif


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

fun! Add(addons, ...)
    call vam#ActivateAddons(a:addons)
endfun

" ------------------------------
" Plugins activate
" ------------------------------
fun! ActivateAddons()
  set runtimepath+=~/.vim/addons/vim-addon-manager
  try
    call Add([
        \'The_NERD_tree',
        \'The_NERD_Commenter',
        \'bufexplorer.zip',
        \'grep',
        \'matchit.zip',
        \'taglist',
        \'xmledit',
        \
        \'vcscommand',
        \'fugitive',
        \
        \'Gist',
    \])

    call Add('ack')
    let g:ackprg="ack-grep -H --nocolor --nogroup --column"

    call Add(['AutoComplPop', 'L9'])
    "call Add('neocomplcache')

    call Add('python30', '#python_fn')
    call Add('pep83160', '#pep8')
    call Add('pep83430', '#pep8', 'https://github.com/jbking/vim-pep8/')
    "call Add('pyflakes2441')
    "call Add('pyflakes3161', 'При сохранении')
    call Add('python_check_syntax')
    "call Add('pythoncomplete')
    "call Add(['python_tag_import', 'indentpython3003'])

    call Add('html5')
    call Add('Jinja')
    "call Add(['mako1858', 'mako2663'])

    " CSS
    "call Add('css_color')
    call Add('scss-syntax')

    call Add('EasyGrep')
    call Add('Gundo')
    call Add('ScrollColors')
    call Add(['tlib', 'tregisters', 'tselectbuffer'])
    "call Add('minibufexplorer_-_Elegant_buffer_explorer')
  catch /.*/
    echoe v:exception
  endtry
endf
call ActivateAddons()


" ------------------------------
" Plugins setup
" ------------------------------

" Taglist
let Tlist_Compact_Format          = 1   " Do not show help
let Tlist_Enable_Fold_Column      = 0   " Don't Show the fold indicator column
let Tlist_Exit_OnlyWindow         = 1   " If you are last kill your self
let Tlist_GainFocus_On_ToggleOpen = 1   " Jump to taglist window to open
let Tlist_Show_One_File           = 1   " Displaying tags for only one file
let Tlist_Use_Right_Window        = 0   " Split to rigt side of the screen
let Tlist_Use_SingleClick         = 1   " Single mouse click open tag
let Tlist_WinWidth                = 35  " Taglist win width
let Tlist_Display_Tag_Scope       = 1   " Show tag scope next to the tag name

" NERDTree
let NERDTreeWinSize = 35
let NERDTreeChDirMode=2
let NERDTreeShowBookmarks=1

" Ropevim
"let g:ropevim_vim_completion=1
"let g:ropevim_extended_complete=0
let g:ropevim_guess_project=1
"let g:ropevim_enable_autoimport=0
"let g:ropevim_codeassist_maxfixes=3
"let g:ropevim_autoimport_modules = []

" BufExplorer
let g:bufExplorerShowRelativePath=1
let g:bufExplorerSplitOutPathName=0
let g:bufExplorerSortBy='fullpath'
let g:bufExplorerShowTabBuffer=1

"let g:acp_behaviorUserDefinedFunction = 'RopeCodeAssistInsertMode()'
let g:acp_ignorecaseOption = 0

" Disable AutoComplPop.
" let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Pyflakes
"let g:pyflakes_use_quickfix = 0
let no_pyflakes_maps = 1

" Gundo
let g:gundo_width = 35

" MiniBufExplorer
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
call LeaderToggle('w',  'wrap')
call LeaderToggle('s',  'spell')
call LeaderToggle('m',  'modifiable')

" .vimrc reload
nmap <leader>r :source ~/.vimrc<cr>
nmap <leader>c :cwin<cr>
nmap <leader>cc :cclose<cr>

" New line and exit from insert mode
"map <S-O> i<CR><ESC>

" CTRL-F для omni completion
imap <C-F> <C-X><C-O>

map <C-A> ggVG

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
let g:pcs_hotkey='<F7>'
"call MapDo('<F7>', 'call Pyflakes()')

" F8 - Pep8
call MapDo('<F8>', 'call Pep8()')
"call MapDo('<F8>', 'Pep8Update')

" F9 - Trim trailing spaces
call MapDo('<F9>', 'call TrimSpaces()')

" F11
"call MapDo('<F11>', 'TMiniBufExplorer')

" ------------------------------
" Autocommands
" ------------------------------

filetype on            " enables filetype detection
filetype plugin on     " enables filetype specific plugins
"filetype plugin indent on

autocmd FileType python call TextWidth()
" autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags

" Auto reload vim settins
"au! bufwritepost rc.vim source ~/.vimrc

autocmd BufNewFile,BufRead *.html,*.htm set ft=html
autocmd BufNewFile,BufRead *.less set ft=css

"autocmd BufWritePost *.py call Pyflakes()

" Highlight insert mode
autocmd InsertEnter * set cursorline
autocmd InsertLeave * set nocursorline


" ------------------------------
" Misc
" ------------------------------

" Templates
iab pybin #!/usr/bin/env python<esc>
iab pyutf8 # -*- coding: utf-8 -*-<esc>
iab pdbtrace import pdb; pdb.set_trace()<esc>

python << EOF
import site
site.addsitedir(
    '/usr/local/lib/python2.6/dist-packages'
)
EOF

set secure  " must be written at the last.  see :help 'secure'.
