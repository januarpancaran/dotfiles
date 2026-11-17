" line numbers
set number
set relativenumber
set signcolumn=yes

" scroll
set scrolloff=10
set wrap

" tab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" indent
set smartindent
set autoindent

" search
set nohlsearch
set incsearch

" undo
set noswapfile
set nobackup
set undofile
if has("win32") || has("win64")
  set undodir=$USERPROFILE/vimfiles/undodir
else
  set undodir=$HOME/.vim/undodir
endif

" others
set updatetime=50
set termguicolors
set guicursor=
set clipboard=unnamed

" keybindings
nnoremap j jzz
nnoremap k kzz
nnoremap { {zz
nnoremap } }zz

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
