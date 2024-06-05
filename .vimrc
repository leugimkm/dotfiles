call plug#begin()
Plug 'morhetz/gruvbox'
Plug 'preservim/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'majutsushi/tagbar'
Plug 'jiangmiao/auto-pairs'
Plug 'vim-scripts/indentpython.vim'
Plug 'lepture/vim-jinja'
Plug 'pangloss/vim-javascript'
Plug 'alvan/vim-closetag'
" Plug 'davidhalter/jedi-vim'
" Plug 'valloric/YouCompleteMe'
call plug#end()

filetype plugin indent on
syntax on
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
