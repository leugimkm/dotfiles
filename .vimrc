" PLUGINS ---------------------------------------------------------------- {{{

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -flo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin()
  Plug 'morhetz/gruvbox'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim',
  Plug 'preservim/nerdtree'
  Plug 'jistr/vim-nerdtree-tabs'
  Plug 'preservim/tagbar'
  Plug 'jiangmiao/auto-pairs'
  Plug 'vim-scripts/indentpython.vim'
  Plug 'lepture/vim-jinja'
  Plug 'pangloss/vim-javascript'
  Plug 'alvan/vim-closetag'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'vim-airline/vim-airline'
  Plug 'dense-analysis/ale'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'yaegassy/coc-astro', {'do': 'yarn install --frozen-lockfile'}
  Plug 'yaegassy/coc-esbonio', {'do': 'yarn install --frozen-lockfile'}
call plug#end()

let g:coc_global_extensions = [
\ 'coc-clangd',
\ 'coc-css',
\ 'coc-html',
\ 'coc-json',
\ 'coc-markdownlint',
\ 'coc-pyright',
\ 'coc-rust-analyzer',
\ 'coc-sh',
\ 'coc-toml',
\ 'coc-tsserver',
\ 'coc-ultisnips',
\ 'coc-yaml',
\]

" }}}

let mapleader="\<Space>"
set nocompatible
set mouse=a
syntax on
filetype plugin indent on
set hidden
set ruler
set laststatus=2
set autoread
au FocusGained,BufEnter * silent! checktime
set wildmenu
set magic
set lazyredraw
match ErrorMsg /\s\+$/
set signcolumn=yes
highlight clear signcolumn
set colorcolumn=80
" set foldmethod=marker
" set updatetime=300
set hlsearch
set incsearch
set ignorecase
set smartcase
set showcmd
set showmatch
set splitbelow
set splitright
set expandtab
set smarttab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent
set relativenumber
set number
set scrolloff=8
set belloff=all
set nobackup
set nowritebackup
set noswapfile
set history=1024
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set ttyfast
set backspace=indent,eol,start
set fileformats=unix,dos,mac
set t_Co=256
let &t_ut=''
set termguicolors
set background=dark
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_italic=1
let g:gruvbox_transparent_bg=1
colorscheme gruvbox
highlight Normal guibg=NONE ctermbg=NONE
highlight clear SignColumn

autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* loadview

au BufNewFile,BufRead *.js, *.jsx, *.tsx, *.ts, *.msj, *.astro, *.html, *.css, *.lua
  \ set tabstop=2
  \ softtabstop=2
  \ shiftwidth=2

au BufNewFile,BufRead *.py
  \ set tabstop=4
  \ shiftwidth=4
  \ softtabstop=4
  \ textwidth=79

if has('unnamedplus')
  set clipboard+=unnamed,unnamedplus
endif

let s:platform = {
\   'osx': has('macunix'),
\   'linux': has('unix') && !has('macunix') && !has('win32unix'),
\   'windows': has('win32') || has('win64'),
\}

" let &listchars="eol:$,tab:\u258f,trail:~,extends:>,precedes:<,nbsp:%,space:\xb7"
let &listchars="eol:$,tab:>-,trail:~,extends:>,precedes:<,nbsp:%,space:\xb7"
set nolist

nmap <silent> <leader><tab> :set nolist!<CR>
nnoremap <silent> <leader><CR> :noh<CR>
noremap <leader>e :NERDTreeToggle<CR>
map <leader>uw :set wrap!<CR>

nnoremap + <C-a>
nnoremap - <C-x>

nnoremap sh <C-w><
nnoremap sl <C-w>>
nnoremap sj <C-w>-
nnoremap sk <C-w>+
" nnoremap <silent> <leader>+ :exe "resize " . (winheight(0) * 3/2)<CR>

map <leader>bn :bnext<CR>
map <leader>bp :bprevious<CR>
map <leader>bd :bdelete<CR>
map <S-h> :bprevious<CR>
map <S-l> :bnext<CR>
map <S-x> :bdelete<CR>

nmap <leader>- <C-W>s<C-W>l
nmap <leader>\| <C-W>v<C-W>l
nmap <leader>c <C-W>c

map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

tnoremap <silent> <C-j> <C-W>j
tnoremap <silent> <C-k> <C-W>k
tnoremap <silent> <C-h> <C-W>h
tnoremap <silent> <C-l> <C-W>l
tnoremap <Esc> <C-\><C-n>

vnoremap <C-c> "+y
vnoremap <C-v> "+P

<<<<<<< HEAD
nnoremap <leader>wt :%s/\s\+$//e<CR>
nnoremap <C-/> :terminal<CR>

if s:platform['osx']
  vmap <C-x> :!pbcopy<CR>
  vmap <C-c> :w !pbcopy<CR><CR>
  nnoremap <C-A-j> :!clear; python3 %<CR>
  " autocmd FileType python nnoremap <C-A-j> :terminal python3 %<CR>
  autocmd FileType python nnoremap <silent> <leader>sh :terminal python3 %<CR>
else
  nnoremap <C-A-j> :!clear; python %<CR>
  " autocmd FileType python nnoremap <C-A-j> :terminal python %<CR>
  autocmd FileType python nnoremap <silent> <leader>sh :terminal python %<CR>
endif
=======
nnoremap <silent> <C-/> :terminal<CR>
nnoremap <C-A-j> :!clear; python %<CR>
" autocmd FileType python nnoremap <C-A-j> :terminal python %<CR>
autocmd FileType python nnoremap <silent> <leader>sh :terminal python %<CR>
>>>>>>> 051077acb17b6f7b9ec3036f4edff5d9aae15419

nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
" inoremap <A-j> <Esc>:m .+1<CR>==gi
" inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <S-j> :m '>+1<CR>gv=gv
vnoremap <S-k> :m '<-2<CR>gv=gv

au FileType python let b:AutoPairs = AutoPairsDefine({"f'" : "'", "r'" : "'", "b'" : "'"})

augroup toogle_number
  autocmd!
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave * setlocal norelativenumber
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * setlocal relativenumber
augroup END

let g:netrw_banner=0
let g:netrw_winsize=25

let g:NERDTreeWinPos="right"
let g:NERDTreeWinSize=35
let NERDTreeQuitOnOpen=1
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.pyc$', '__pycache__', '^node_modules$']

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ coc#pum#visible() ? coc#pum#next(1) :
  \ CheckBackspace() ? "\<Tab>" :
  \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"

nmap <leader>cr <Plug>(coc-rename)
nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)
nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)
nmap <silent><nowait> gd <Plug>(coc-definition)
nmap <silent><nowait> gy <Plug>(coc-type-definition)
nmap <silent><nowait> gi <Plug>(coc-implementation)
nmap <silent><nowait> gr <plug>(coc-references)
nnoremap <silent> K :call ShowDocumentation()<CR>

xmap <leader>cf  <Plug>(coc-format-selected)
nmap <leader>cf  <Plug>(coc-format-selected)

function! RunPythonFile(split_type)
  let l:file = expand("%:p")
  let l:cmd = "python " . shellescape(l:file)
  let l:send_keys = 'vim ' . shellescape(l:file) . '" C-m'
  if empty($TMUX)
    echo "No tmux session!"
    " let l:com = 'tmux new-session -A -s vimux \; send-keys "' . l:send_keys
    " silent execute "! " . l:com
    " quit
  endif
  let l:tmux_cmd = "tmux split-window -" . a:split_type
  let l:shell_cmd = "'zsh -c \"" . l:cmd . "; exec zsh\"'"
  call system(l:tmux_cmd . " " . l:shell_cmd)
endfunction

nnoremap <leader>j- :call RunPythonFile('v')<CR>
nnoremap <leader>j\ :call RunPythonFile('h')<CR>

let g:airline_mode_map = {
  \ '__'     : '',
  \ 'c'      : '󰑮',
  \ 'i'      : '',
  \ 'ic'     : '',
  \ 'ix'     : '',
  \ 'n'      : '',
  \ 'multi'  : '',
  \ 'ni'     : '',
  \ 'no'     : '',
  \ 'R'      : '',
  \ 'Rv'     : '',
  \ 's'      : '',
  \ 'S'      : '',
  \ ''     : '',
  \ 't'      : '',
  \ 'v'      : '󰸿',
  \ 'V'      : '󰸽',
  \ ''     : '󰹀',
  \ }
