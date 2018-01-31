" line numbers
set number

" gimme spaces please
set tabstop=2
set shiftwidth=2
set softtabstop=2
set numberwidth=4
set expandtab

" set title when running inside a terminal
set title

" better search
set ignorecase
set smartcase
set showmatch
set incsearch

" ignore these
set wildignore=*/node_modules/*,*/elm-stuff/*

" bind pastemode to F2
set pastetoggle=<F2>

" i just dont care for \
let mapleader=','

" colors
set termguicolors

" i like cursor lines
set cursorline

" couple saner remaps
inoremap jj <Esc>
nnoremap ; :
nnoremap : ;

" real men don't use arrow keys
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" sane behaviour for moving over lines
nnoremap j gj
nnoremap k gk

" map W to write current buffer with superuser privileges
command W :execute ':silent w !sudo tee % >/dev/null' | :edit!
command Wq :execute ':silent w !sudo tee % >/dev/null' | :quit!

" ctags
autocmd Filetype java set tags=$HOME/Documents/framework/.tags
autocmd Filetype jsp set tags=$HOME/Documents/framework/.tags

" plugins
call plug#begin()
Plug('https://github.com/ElmCast/elm-vim')
Plug('https://github.com/ctrlpvim/ctrlp.vim')
Plug('https://github.com/leafgarland/typescript-vim')
Plug('https://github.com/mxw/vim-jsx.git')
Plug('https://github.com/pangloss/vim-javascript.git')
Plug('https://github.com/posva/vim-vue.git')
Plug('https://github.com/tpope/vim-fugitive')
Plug('https://github.com/vim-airline/vim-airline')
Plug('https://github.com/vim-airline/vim-airline-themes')
Plug('https://github.com/wavded/vim-stylus')
call plug#end()

" airline (bottom bar) theme
let g:airline_theme='papercolor'

" be silent when grabbing scp files
let g:netrw_silent=1

" jsx
let g:jsx_ext_required = 0

