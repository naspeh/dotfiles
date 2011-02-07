if exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = 'css'
endif

runtime! syntax/scss.vim
runtime! syntax/css.vim
unlet b:current_syntax

let b:current_syntax = "scss"
