if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/plugins_by_vimplug')
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/syntastic'
Plug 'vim-airline/vim-airline'
call plug#end()

set nocompatible "get rid of vi compatibility
filetype indent plugin on
syntax enable
set wildmenu
set showcmd
set hlsearch
set ignorecase
set smartcase
set backspace=indent,eol,start
set autoindent
set confirm
set noeb vb
set cmdheight=2
set pastetoggle=<F11>
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
set number
set laststatus=2
set ttimeoutlen=50

" syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" airline
let g:airline#extensions#quickfix#quickfix_text = 'Quickfix'
let g:airline#extensions#quickfix#location_text = 'Location'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'

" netrw
nnoremap <C-e> :Lexplore<CR>
let g:netrw_brows_split = 4
let g:netrow_altv = 1
let g:netrw_liststyle = 3

" cursor
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

nnoremap <C-L> :nohl<CR><C-L>
vnoremap // y/<C-R>"<CR>

" workaround for ghost characters on startup
autocmd VimEnter * redraw!

