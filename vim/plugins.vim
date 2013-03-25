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
let g:syntastic_enable_signs=0
let g:syntastic_enable_highlighting=0
let g:syntastic_auto_loc_list=1
nmap <leader>s :SyntasticToggleMode<cr>
"call MapDo('<F7>', ':SyntasticToggleMode<cr>')
call MapDo('<F8>', ':Errors<cr>:lclose<cr>')
nmap <leader>ss :call VarToggle('g:syntastic_auto_loc_list')<cr>

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
let g:tagbar_autofocus=1
let g:tagbar_sort=1
let g:tagbar_foldlevel=0


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
"nmap <leader>f :call Flake8()<cr>
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
nnoremap <leader>c :call NERDComment('n', 'AlignLeft')<cr>gv
vnoremap <leader>c :call NERDComment('x', 'AlignLeft')<cr>gv
nnoremap <leader>cc :call NERDComment('n', 'Uncomment')<cr>gv
vnoremap <leader>cc :call NERDComment('x', 'Uncomment')<cr>gv

"Bundle 'tomtom/tcomment_vim'
"Bundle 'comments.vim'
"Bundle 'tpope/vim-commentary'
"autocmd FileType python set commentstring=#%s


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
let g:jedi#related_names_command = 0
let g:jedi#popup_on_dot = 0
let g:jedi#show_function_definition = 0
let g:jedi#autocompletion_command = "<C-Space>"

"Bundle 't9md/vim-quickhl'
"call MapDo('<leader><space>', '<Plug>(quickhl-toggle)')
"call MapDo('<leader><space><space>', '<Plug>(quickhl-reset)')
"call MapDo('<leader>j', '<Plug>(quickhl-match)')
