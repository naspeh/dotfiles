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
    "nnoremap <leader><space> :nohls<CR>
    "nmap <silent> ,p :set invpaste<CR>:set paste?<CR>
    execute "nmap <leader>".a:key." :setlocal ".a:opt."! ".a:opt."?<cr>"
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
    setlocal wrap
    setlocal nolist
    setlocal nocursorline
    setlocal spell
    " Перемещать курсор на следующую строку при нажатии на клавиши вправо-влево и пр.
    set whichwrap+=<,>,[,]
endfun
nmap <leader>t :call TextMode()<cr>

" ------------------------------
" Configure
" ------------------------------
source ~/.vim/plugins.vim

"Вырубаем режим совместимости с VI:
set nocompatible

set title

"set background=dark
"color darkblue
"set background=light
"color delek
"color zellner
"color desert

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
"set smartindent
set smarttab

" Поиск
"set ignorecase
set hlsearch
set incsearch

syntax on
set number
let python_highlight_all=1

set list
"set listchars=tab:>-,trail:~,extends:+,precedes:+
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
set statusline=%<%f%h%m%r%=%{fugitive#statusline()}\ (%{&ff}\ %{&ft}\ %{&encoding})\ %b\ 0x%B\ %l,%c%V\ %P
set laststatus=2
" Показывать незавершенные команды в статусбаре
set showcmd
hi StatusLineBufferNumber guifg=fg guibg=bg gui=bold
set cmdheight=2
" использовать диалоги вместо сообщений об ошибках
set confirm
" report all changes
set report=0
" Не перерисовывать окно при работе макросов
set lazyredraw
set ttyfast

" Поддержка мыши
set mouse=r
set mousemodel=popup
set mousehide

" share clipboard with system clipboard
"set clipboard+=unnamed
set clipboard=unnamedplus

" Перемещать курсор на следующую строку при нажатии на клавиши вправо-влево и пр.
"set whichwrap+=<,>,[,]

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

    "set go-=m "remove menubar
endif

" http://blog.sanctum.geek.nz/vim-annoyances/
nnoremap <F1> <nop>
nnoremap Q <nop>
set shortmess+=I

let mapleader=","

filetype on            " enables filetype detection
filetype plugin on     " enables filetype specific plugins
"filetype plugin indent on

"autocmd BufNewFile,BufRead *.{html,htm} setlocal ft=html
autocmd BufNewFile,BufRead *.{css,less} setlocal ft=css
autocmd BufNewFile,BufRead *.{md,mkd,mdt} setlocal ft=markdown

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


" ------------------------------
" Hot keys
" ------------------------------
" Заставляет комбинацию shift-insert работать как в Xterm
imap <S-Insert> <MiddleMouse>
"map! <S-Insert> <MiddleMouse>

" CTRL-F для omni completion
imap <C-F> <C-X><C-O>

" < & > - делаем отступы для блоков
vmap < <gv
vmap > >gv

" Scrolling
"noremap <C-k> 14j14<C-e>
"noremap <C-l> 14k14<C-y>

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

set guioptions+=a
function! MakePattern(text)
  let pat=escape(a:text, '\')
  let pat=substitute(pat, '\_s\+$', '\\s\\*', '')
  let pat=substitute(pat, '^\_s\+', '\\s\\*', '')
  let pat=substitute(pat, '\_s\+',  '\\_s\\+', 'g')
  return '\\V' . escape(pat, '\"')
endfunction
nnoremap <F2> :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>
vnoremap <silent> <F2> :<C-U>let @/="<C-R>=MakePattern(@*)<CR>"<CR>:set hls<CR>
"nmap <leader><space> :set invhls<CR>:let @/="<C-r><C-w>"<CR>


" ------------------------------
" Misc
" ------------------------------
iab pybin #!/usr/bin/env python<esc>
iab pyutf # -*- coding: utf-8 -*-<esc>
iab pyutf8 # -*- coding: utf-8 -*-<esc>
iab pdb import pdb; pdb.set_trace()<esc>
iab ipdb import ipdb; ipdb.set_trace()<esc>

python << EOF
import os, sys
ve_dir = os.environ.get('VIRTUAL_ENV')
if ve_dir:
    ve_dir in sys.path or sys.path.insert(0, ve_dir)
    activate_this = os.path.join(os.path.join(ve_dir, 'bin'), 'activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF

set secure  " must be written at the last.  see :help 'secure'.
