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

function! TrimSpaces()
  if !&binary && &filetype != 'diff'
    normal mz
    normal Hmy
    %s/\s\+$//e
    normal 'yz<CR>
    normal `z
  endif
endfunction

fun! SetMap(key, cmd)
    execute "nmap ".a:key." " . ":".a:cmd."<CR>"
    execute "cmap ".a:key." " . "<C-C>:".a:cmd."<CR>"
    execute "imap ".a:key." " . "<Esc>:".a:cmd."<CR>"
    execute "vmap ".a:key." " . "<Esc>:".a:cmd."<CR>gv"
endfun

fun! SetMapToggle(key, opt)
    call SetMap(a:key, "set ".a:opt."! ".a:opt."?")
endfun

