" PLUGINS ---------------------------------------------------------------- {{{

if empty(glob('/.vim/autoload/plug.vim'))
    silent !curl -flo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin()
Plug 'morhetz/gruvbox'
Plug 'preservim/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'preservim/tagbar'
Plug 'jiangmiao/auto-pairs'
Plug 'vim-scripts/indentpython.vim'
Plug 'lepture/vim-jinja'
Plug 'pangloss/vim-javascript'
Plug 'alvan/vim-closetag'
Plug 'dense-analysis/ale'
" Plug 'davidhalter/jedi-vim'
" Plug 'valloric/YouCompleteMe'
call plug#end()
" }}}

" set rtp+=/usr/share/powerline/bindings/vim
" set laststatus=2

syntax on
filetype plugin indent on
set incsearch
set hlsearch

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smartindent
set encoding=utf-8
set fileencoding=utf-8
set t_Co=256
let &t_ut=''

set colorcolumn=80
set relativenumber
set nu
set scrolloff=8
colorscheme gruvbox
set background=dark
hi Normal ctermbg=None

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

au FileType python let b:AutoPairs = AutoPairsDefine({"f'" : "'", "r'" : "'", "b'" : "'"})

let NERDTreeIgnore = ['\.pyc$', '__pycache__']
