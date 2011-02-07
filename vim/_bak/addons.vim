" ------------------------------
" Plugins activate
" ------------------------------
fun! ActivateAddons()
  set runtimepath+=~/.vim/addons/vim-addon-manager
  try
    "    \'reload',
    call scriptmanager#Activate(
        \'AutoComplPop', 'L9',
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
    \)

    " python30 == python_fn
    " pep83160 == pep8
    call scriptmanager#Activate(
        \'pythoncomplete',
        \'python_check_syntax',
        \'python30',
        \'pep83160',
        \
        \'Jinja',
    \)

    " New addons
    call scriptmanager#Activate('EasyGrep')
    call scriptmanager#Activate('python_tag_import', 'indentpython3003')
    call scriptmanager#Activate('scss-syntax')
    call scriptmanager#Activate('mako1858', 'mako2663')

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
let Tlist_WinWidth                = 30  " Taglist win width
let Tlist_Display_Tag_Scope       = 1   " Show tag scope next to the tag name

" NERDTree
let NERDTreeWinSize = 30
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

let g:acp_behaviorUserDefinedFunction = 'RopeCodeAssistInsertMode()'
let g:acp_ignorecaseOption = 0
