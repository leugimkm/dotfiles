" PLUGINS ---------------------------------------------------------------- {{{

if empty(glob('/.vim/autoload/plug.vim'))
  silent !curl -flo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif


call plug#begin()
Plug 'morhetz/gruvbox'
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
\ 'coc-json',
\ 'coc-tsserver',
\ 'coc-html',
\ 'coc-css',
\ 'coc-clangd',
\ 'coc-pyright',
\ 'coc-markdownlint',
\ 'coc-ultisnips',
\ 'coc-sh',
\ 'coc-yaml',
\ 'coc-toml'
\]

" }}}

" autocmd vimenter * ++nested colorscheme gruvbox

" set rtp+=/usr/share/powerline/bindings/vim
set laststatus=2
match ErrorMsg /\s\+$/

let mapleader=" "
set nocompatible
set mouse=a
syntax on
filetype plugin indent on
set hidden
set hlsearch
set incsearch
set showcmd
set showmatch
set splitbelow
set splitright
set autoread
au FocusGained,BufEnter * silent! checktime

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smartindent
set encoding=utf-8
set fileencoding=utf-8
set t_Co=256
" set termguicolors
let &t_ut=''

set colorcolumn=80
set relativenumber
set nu
set scrolloff=8

" set belloff=all

set background=dark
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox
hi Normal guibg=NONE ctermbg=NONE

set nobackup
set nowritebackup
set noswapfile
set signcolumn=yes
" set updatetime=300
highlight clear signcolumn

au BufNewFile,BufRead *.js, *.html, *.css
  \ set tabstop=2
  \ softtabstop=2
  \ shiftwidth=2

au BufNewFile,BufRead *.py
  \ set tabstop=4
  \ shiftwidth=4
  \ softtabstop=4
  \ expandtab
  \ autoindent
  \ textwidth=79
  \ fileformat=unix

map <leader>h :noh<CR>
map <leader>e :NERDTreeToggle<CR>

map <leader>n :bnext<CR>
map <leader>p :bprevious<CR>
map <leader>d :bdelete<CR>

nmap <leader>- <C-W>s<C-W>l
nmap <leader>\ <C-W>v<C-W>l
nmap <leader>c <C-W>c

map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

vnoremap <C-c> "+y
vnoremap <C-v> "+P

" nnoremap <C-A-j> :w<CR>!clear; python %<CR>
autocmd FileType python nnoremap <C-A-j> :w<CR>:terminal python %<CR>

nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
" inoremap <A-j> <Esc>:m .+1<CR>==gi
" inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

au FileType python let b:AutoPairs = AutoPairsDefine({"f'" : "'", "r'" : "'", "b'" : "'"})

augroup toogle_number
    autocmd!
    autocmd BufLeave,FocusLost,InsertEnter,WinLeave * setlocal norelativenumber
    autocmd BufEnter,FocusGained,InsertLeave,WinEnter * setlocal relativenumber
augroup END

let g:netrw_banner=0
let g:netrw_winsize=25

let g:NERDTreeWinPos="right"
let NERDTreeQuitOnOpen=1
let NERDTreeIgnore = ['\.pyc$', '__pycache__', '^node_modules$']

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"
