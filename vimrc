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
" Plugins activate
" ------------------------------
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'


Bundle 'tpope/vim-fugitive'
Bundle 'powerman/vim-plugin-ruscmd'
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


"http://vimcasts.org/episodes/aligning-text-with-tabular-vim/
Bundle "godlygeek/tabular"


Bundle 'scrooloose/syntastic'
"g:syntastic_less_use_less_lint=1
let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=1
let g:syntastic_enable_highlighting=0
let g:syntastic_auto_loc_list=2
nmap <leader>s :SyntasticToggleMode<cr>
"call MapDo('<F7>', ':SyntasticToggleMode<cr>')
call MapDo('<F8>', ':SyntasticCheck<cr>')


Bundle 'milkypostman/vim-togglelist'
"The default mappings are:
"nmap <leader>l :call ToggleLocationList()<CR>
"nmap <leader>q :call ToggleQuickfixList()<CR>


Bundle 'scrooloose/nerdtree'
"call MapDo('<F4>', ':NERDTreeToggle<cr>')
let NERDTreeWinSize=35
let NERDTreeChDirMode=2
let NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.pyc$']


"Bundle 'bufexplorer.zip'
let g:bufExplorerShowRelativePath=1
let g:bufExplorerSplitOutPathName=0
let g:bufExplorerSortBy='fullpath'
let g:bufExplorerShowTabBuffer=1


"Bundle 'taglist.vim'
"call MapDo('<F5>', ':NERDTreeClose<cr>:TlistToggle<cr>')
let Tlist_Compact_Format          = 1   " Do not show help
let Tlist_Enable_Fold_Column      = 0   " Don't Show the fold indicator column
let Tlist_Exit_OnlyWindow         = 1   " If you are last kill your self
let Tlist_GainFocus_On_ToggleOpen = 1   " Jump to taglist window to open
let Tlist_Show_One_File           = 1   " Displaying tags for only one file
let Tlist_Use_Right_Window        = 0   " Split to rigt side of the screen
let Tlist_Use_SingleClick         = 1   " Single mouse click open tag
let Tlist_WinWidth                = 35  " Taglist win width
let Tlist_Display_Tag_Scope       = 1   " Show tag scope next to the tag name


Bundle 'majutsushi/tagbar'
"call MapDo('<F5>', ':TagbarToggle<cr>')
call MapDo('<leader>t', ':TagbarToggle<cr>')

Bundle 'AutoComplPop', 'L9'
let g:acp_ignorecaseOption=0
let g:acp_enableAtStartup=1


"Bundle 'Shougo/neocomplcache'
let g:neocomplcache_enable_at_startup=1
let g:neocomplcache_enable_auto_select=0
let g:neocomplcache_enable_smart_case= 1
let g:neocomplcache_manual_completion_start_length=0
let g:neocomplcache_enable_cursor_hold_i=1
let g:neocomplcache_enable_insert_char_pre=1
" Recommended key-mappings.
" <CR>: close popup and save indent.
"inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()


"Bundle 'EasyGrep'
Bundle 'grep.vim'
let Grep_Skip_Dirs='.ropeproject .git .hg _generated_media'
let Grep_Skip_Files='*.bak *~ *.pyc _generated_media*'
nnoremap <silent> <F1> :Grep<CR>


Bundle 'python.vim'
"Bundle 'pyflakes'
"Bundle 'pep8--Driessen'
"Bundle 'https://github.com/jbking/vim-pep8/'
"Bundle 'python_check_syntax.vim'
"Bundle 'pythoncomplete'


"Bundle 'nvie/vim-flake8'
let g:flake8_auto=0
nmap <leader>f :call Flake8()<cr>
fun! FlakeToggle()
    if g:flake8_auto == 0
        let g:flake8_auto=1
    else
        let g:flake8_auto=0
    endif
    echo 'g:flake8_auto ='g:flake8_auto
endfun
fun! FlakeAuto()
    if g:flake8_auto == 1
        call Flake8()
    endif
endfun
"autocmd BufWritePost *.py call FlakeAuto()
"nmap <leader>f :call FlakeToggle()<cr>
"call MapDo('<F7>', ':call FlakeToggle()<cr>')
"call MapDo('<F8>', ':call Flake8()<cr>')


"Bundle 'gordyt/rope-vim'
"Bundle 'timo/rope-vim'
"Bundle 'rygwdn/rope-omni'
"nmap <leader>g :RopeGotoDefinition<cr>
"nmap <leader>i :RopeOrganizeImports<cr>
"let g:ropevim_vim_completion=1
"let g:ropevim_extended_complete=0
let g:ropevim_guess_project=1
"let g:ropevim_enable_autoimport=0
"let g:ropevim_codeassist_maxfixes=3
"let g:ropevim_autoimport_modules=[]


"Bundle 'pyflakes.vim'
"let g:pyflakes_use_quickfix=0
let no_pyflakes_maps=1


if v:version >= 703
    Bundle 'Gundo'
    call MapDo('<F6>', ':GundoToggle<cr>')
    let g:gundo_width=35
endif


Bundle 'kien/ctrlp.vim'
call MapDo('<F3>', ':CtrlPBuffer<cr>')
call MapDo('<F4>', ':CtrlPCurWD<cr>')
call MapDo('<F5>', ':CtrlPBufTag<cr>')
let g:ctrlp_custom_ignore={
    \'dir':  '\.git$\|\.hg$\|\.svn$\|_generated_media$',
\}
let g:ctrlp_extensions=['tag', 'quickfix', 'dir', 'line']
let g:ctrlp_working_path_mode=0
let g:ctrlp_mruf_relative=1
"let g:ctrlp_regexp=0
let g:ctrlp_ignore_=' | grep -v -e /migrations/ -e ^_generated_media -e ^\.ropeproject'
let g:ctrlp_user_command={
    \'types': {
        \1: ['.git', 'cd %s && git ls-files' . g:ctrlp_ignore_],
        \2: ['.hg', 'hg --cwd %s locate -I .' . g:ctrlp_ignore_],
    \},
    \'fallback': 'find %s -type f' . g:ctrlp_ignore_
\}
"let g:ctrlp_user_command='find %s -type f'


Bundle 'xterm16.vim'
let xterm16_colormap='softlight'
let xterm16_brightness='high'
color xterm16


Bundle 'scrooloose/nerdcommenter'
let NERDCreateDefaultMappings=0
nnoremap <leader>c :call NERDComment('n', 'AlignLeft')<cr>
vnoremap <leader>c :call NERDComment('x', 'AlignLeft')<cr>
nnoremap <leader>cc :call NERDComment('n', 'Uncomment')<cr>
vnoremap <leader>cc :call NERDComment('x', 'Uncomment')<cr>

"Bundle 'tomtom/tcomment_vim'
"Bundle 'comments.vim'


"set foldenable
"set foldcolumn=1
"Bundle 'Python-Syntax-Folding'
"Bundle 'Efficient-python-folding'
"Bundle 'sunsol/vim_python_fold_compact'
"noremap f zA
"noremap F za


Bundle 'davidhalter/jedi-vim'
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#rename_command = 0
let g:jedi#popup_on_dot = 0
let g:jedi#show_function_definition = 0


"Bundle 't9md/vim-quickhl'
"call MapDo('<leader><space>', '<Plug>(quickhl-toggle)')
"call MapDo('<leader><space><space>', '<Plug>(quickhl-reset)')
"call MapDo('<leader>j', '<Plug>(quickhl-match)')


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
" Autocommands
" ------------------------------
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


" ------------------------------
" Misc
" ------------------------------
iab pybin #!/usr/bin/env python<esc>
iab pyutf # -*- coding: utf-8 -*-<esc>
iab pyutf8 # -*- coding: utf-8 -*-<esc>
iab pdb import pdb; pdb.set_trace()<esc>
iab ipdb import ipdb; ipdb.set_trace()
iab pudb import pudb; pudb.set_trace()<esc>

python << EOF
import os, sys
ve_dir = os.environ.get('VIRTUAL_ENV')
if ve_dir:
    ve_dir in sys.path or sys.path.insert(0, ve_dir)
    activate_this = os.path.join(os.path.join(ve_dir, 'bin'), 'activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF

set secure  " must be written at the last.  see :help 'secure'.
