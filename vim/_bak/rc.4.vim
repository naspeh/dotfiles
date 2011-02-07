set runtimepath+=~/.vim/init.d

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

" Включить автоотступы
set autoindent
set smartindent
set smarttab

" Поиск
set ignorecase
set hlsearch
set incsearch

set number
syntax on
let python_highlight_all = 1

set list
set listchars=tab:>-,trail:~,extends:+,precedes:+
set linebreak

" Don't make chaos on my display
set nowrap
set backspace=indent,eol,start
set nojoinspaces
set nofoldenable

" Pretty select with mouse and shifted special keys
behave mswin
" ...but not reset selection with not-shifted special keys
set keymodel-=stopsel
set selection=inclusive


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
set statusline=%<%f\ %y[%{&encoding}\]%1*%{(&modified)?'\ [+]\ ':''}%*%=%c%V,%l\ %P\ [%n]
set laststatus=2
" Показывать незавершенные команды в статусбаре
set showcmd
" использовать диалоги вместо сообщений об ошибках
set cmdheight=2
set confirm
" использовать сокращённые диалоги
set shortmess=fimnrxoOtTI
" report all changes
set report=0

" Поддержка мыши
set mouse=a
set mousemodel=popup
set mousehide

" Не создавать резервных копий файлов
set nobackup
set noswapfile

set undolevels=500
set history=500
set ruler
set hidden

if has('gui')
    " Скрыть панель в gui версии
    set guioptions-=T
    " Отключаем графические диалоги
    set guioptions+=c
    " Отключаем графические табы (текстовые занимают меньше места)
    set guioptions-=e

    set guifont=monospace\ 9

    " Filename
    :amenu 20.351 &Edit.Copy\ FileName :let @*=expand("%:t")<CR>
    :amenu 20.353 &Edit.Copy\ FullPath :let @*=expand("%:p")<CR>

endif


" ------------------------------
" Hot keys
" ------------------------------

" set custom map leader to ','
let mapleader = ","

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

" Fast scrool
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" Set paste mode for paste from terminal
nmap <silent> ,p :set invpaste<CR>:set paste?<CR>

" New line and exit from insert mode
map <S-O> i<CR><ESC>

" Drop hightlight search result
nnoremap <leader><space> :nohls<CR>

" CTRL-F для omni completion
imap <C-F> <C-X><C-O>

map <C-A> ggVG

" < & > - делаем отступы для блоков
vmap < <gv
vmap > >gv

" F2 - Previous window
"call rc#SetMap('<F2>', ':wincmd p')
call rc#SetMap('<F2>', 'wincmd w')

" F3 - BufExplorer
call rc#SetMap('<F3>', 'BufExplorer')

" F4 - NERDTree
call rc#SetMap('<F4>', 'TlistClose<cr>:NERDTreeToggle')

" F5 - ctags
call rc#SetMap('<F5>', 'NERDTreeClose<cr>:TlistToggle')

" F6 - Paste toggle
set pastetoggle=<F6>

" F7
let g:pcs_hotkey='<F7>'

" F8 - Pep8
call rc#SetMap('<F8>', ':call Pep8()')

" F9 - Trim trailing spaces
call rc#SetMap('<F9>', ':call TrimSpaces()')

" F12 - wrap mode
call rc#SetMapToggle('<F12>',  'wrap')


" ------------------------------
" Autocommands
" ------------------------------

filetype on            " enables filetype detection
filetype plugin on     " enables filetype specific plugins

autocmd FileType python call TextWidth()
" autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags

" Auto reload vim settins
au! bufwritepost rc.vim source ~/.vimrc

autocmd BufNewFile,BufRead *.html,*.htm set ft=xhtml
autocmd BufNewFile,BufRead *.less set ft=css

" Highlight insert mode
autocmd InsertEnter * set cursorline
autocmd InsertLeave * set nocursorline


" Templates
iab pybin #!/usr/bin/env python<esc>
iab pyutf8 # -*- coding: utf-8 -*-<esc>

python << EOF
import site
site.addsitedir(
    '/usr/local/lib/python2.6/dist-packages'
)
EOF

set secure  " must be written at the last.  see :help 'secure'.
