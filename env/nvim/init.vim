let mapleader=","

set title
set nobackup
set noswapfile

set number
set ruler
set linebreak
set nowrap

set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

fun! Tab2()
    setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
endfun
nmap <leader>2t :call Tab2()<cr>
autocmd FileType yaml,json,javascript,css,html call Tab2()

set mouse=r
set mousemodel=popup
set mousehide
imap <S-Insert> <MiddleMouse>

set wildoptions-=pum

set completeopt=menuone,noinsert,noselect

" share clipboard with system clipboard
set clipboard=unnamedplus

" Localization
set spelllang=en_us,uk,ru_yo
set encoding=utf-8
set termencoding=utf-8
set fileencodings=utf-8,cp1251,koi8-r,cp866

" Highlight insert mode
autocmd InsertEnter * set cursorline
autocmd InsertLeave * set nocursorline

" https://shapeshed.com/vim-netrw/
let g:netrw_banner=0
" let g:netrw_liststyle=3
" let g:netrw_list_hide = netrw_gitignore#Hide()
nnoremap - :Explore<cr>

" Sudo saves the file
command! Sw w !sudo tee % > /dev/null

set iskeyword+=-
nmap <F2> :let @/ = '\<'.expand('<cword>').'\>'\|set hlsearch<C-M>

" Indent blocks
vmap < <gv
vmap > >gv

imap <C-space> <C-x><C-o>
imap <nul> <C-x><C-o>
imap <C-a> <C-x><C-o>
imap <C-f> <C-x><C-f>

nmap <leader>s :setlocal spell! spell?<cr>
nmap <leader>h :setlocal hlsearch! hlsearch?<cr>
nmap <leader>r :source ~/.config/nvim/init.vim<cr>
nmap <leader>a ggVG<cr>
nmap <leader>f :echo @%<cr>
nmap <leader>fj :%!python -m json.tool --sort-keys --indent=2<cr>

" Trim spaces
" https://vim.fandom.com/wiki/Remove_unwanted_spaces#Simple_commands_to_remove_unwanted_whitespace
nnoremap <F9> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" https://robots.thoughtbot.com/faster-grepping-in-vim
" http://codeinthehole.com/tips/using-the-silver-searcher-with-vim/
if executable('rg')
  set grepprg=rg\ --vimgrep
  set grepformat=%f:%l:%c:%m
  let g:ctrlp_user_command = 'rg --files %s'
  let g:ctrlp_use_caching = 0

  command -nargs=+ -complete=file -bar Rg silent! lgrep! <args> | lwindow | redraw!
  nmap <leader>gg :Rg<SPACE>
 nmap <leader>g :Rg<SPACE>
endif

fun! ToggleQuickfixList()
    let qnr = winnr("$")
    cwindow
    let qnr2 = winnr("$")
    if qnr == qnr2
        cclose
    endif
endfun
fun! ToggleLocationList()
    let lnr = winnr("$")
    lwindow
    let lnr2 = winnr("$")
    if lnr == lnr2
        " close all locationlist at once
        windo if &buftype == "quickfix" || &buftype == "locationlist" | lclose | endif
    endif
endfun
nmap <leader>l :call ToggleLocationList()<CR>
nmap <leader>q :call ToggleQuickfixList()<CR>

python3 << EOF
"""
Create github/gitlab url and put into clipboard for line or for multi-line selection

Inspired by:
- https://github.com/k0kubun/vim-open-github
- https://github.com/tonchis/vim-to-github
"""
import re
import subprocess as sp
import vim

cmd_tpl = """
path=$(realpath "%s")
cd $(dirname $path)
echo $path
git rev-parse --show-toplevel
git remote get-url origin
git rev-parse HEAD
"""

def push_git_urls_to_clipboard():
    selection = {vim.current.range.start + 1, vim.current.range.end + 1}
    selection = '-'.join('L%s' % i for i in selection if i)
    cmd = ['sh', '-c', cmd_tpl % vim.current.buffer.name]
    output = sp.check_output(cmd).decode().strip()
    full_path, root, remote, hash = output.split()
    path = re.sub(r'^%s/' % re.escape(root), '', full_path)
    base_url = remote
    if re.match('git@', remote):
        base_url = re.sub('^git@(.*?)\:', r'https://\1/', remote)
    base_url = re.sub('\.git$', '', base_url)
    urls = (
        '%s/%s/%s/%s#%s' % (base_url, t, hash, path, selection)
        for t in ('blob', 'blame')
    )
    for url in urls:
        sp.call('echo "%s" | xsel -b; sleep 1' % url, shell=True)
EOF
nmap <leader>u :python3 push_git_urls_to_clipboard()<cr>
vmap <leader>u :python3 push_git_urls_to_clipboard()<cr>

" + https://github.com/tpope/vim-pathogen
runtime bundle/tpope--vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

" colorscheme
set background=dark
if has('termguicolors')
  set termguicolors
endif

" https://github.com/romainl/flattened
" set background=light
" colorscheme flattened_light
" colorscheme flattened_dark

" https://github.com/craftzdog/solarized-osaka.nvim
" colorscheme solarized-osaka

" https://github.com/neanias/everforest-nvim - A Lua port of the Everforest colour scheme
" + https://github.com/sainnhe/everforest - 🌲 Comfortable & Pleasant Color Scheme for Vim
let g:everforest_background = 'soft'
let g:everforest_better_performance = 1
let g:everforest_disable_italic_comment = 1
colorscheme everforest

" + https://github.com/ctrlpvim/ctrlp.vim
let g:ctrlp_custom_ignore='\v[\/]\.(git|hg|svn)$'
let g:ctrlp_mruf_relative=1
let g:ctrlp_regexp = 0
nmap <F3> :CtrlPBuffer<cr>
imap <F3> <esc>:CtrlPBuffer<cr>
nmap <F4> :CtrlPMixed<cr>
imap <F4> <esc>:CtrlPMixed<cr>
nmap <F5> :CtrlPBufTag<cr>
imap <F5> <esc>:CtrlPBufTag<cr>
"nmap <F6> :CtrlPBufTagAll<cr>
"imap <F6> <esc>:CtrlPBufTagAll<cr>
nmap <F6> :CtrlPCurWD<cr>
imap <F6> <esc>:CtrlPCurWD<cr>
nmap <F7> :CtrlPUndo<cr>
imap <F7> <esc>:CtrlPUndo<cr>

" https://github.com/numToStr/Comment.nvim - 🧠 💪 Smart and powerful comment plugin for neovim. Supports treesitter, dot repeat, left-right/up-down motions, hooks, and more
" + https://github.com/tpope/vim-commentary - comment stuff out
vmap <leader>c :Commentary<cr>gv
nmap <leader>c :Commentary<cr>

lua <<EOF

-- + https://github.com/nvim-lualine/lualine.nvim - A blazing fast and easy to configure neovim statusline plugin written in pure lua
require('lualine').setup{
    options = {
        theme = 'auto',
        icons_enabled = false,
    },
}

-- + https://github.com/neovim/nvim-lspconfig - Quickstart configs for Nvim LSP
local lspconfig = require('lspconfig')
--lspconfig.pyright.setup{}
lspconfig.pylsp.setup{}
lspconfig.tsserver.setup{}
lspconfig.gopls.setup{}
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<F8>', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', '<leader>d', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', '<leader>i', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<leader>ls', vim.lsp.buf.signature_help, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>la', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>lf', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
EOF
