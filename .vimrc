" use vim instead of vi stuff
set nocompatible

" set up pathogen
execute pathogen#infect()

" change the leader from \ to ,
let mapleader=','

" backspace is always being flaky
set backspace=indent,eol,start

" i like cursor lines
set cursorline

" neat tab completion and ignore files
set wildmenu
set wildmode=longest:full,full
set wildignore=*/node_modules/*,*/elm-stuff/*

" case insensitive
set ignorecase
set smartcase

" options
set number
set clipboard+=unnamed
set encoding=utf-8
set nobackup
set nowritebackup
set directory=$HOME/.vim/tmp
set mouse=a
set noerrorbells
set numberwidth=4
set novisualbell
set scrolloff=2
set laststatus=2
set hidden
set history=10000
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" couple remaps
nnoremap <ESC><ESC> :set hlsearch!<CR>
inoremap jj <Esc>
nnoremap JJJJ <Nop>
nnoremap ; :
nnoremap : ;

syntax on
set hlsearch

" base16
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

" file type detection and language-specific indentatition
filetype plugin indent on
set autoindent

" sane search settings
set showmatch
set incsearch

" set title when running inside a terminal
set title

" bind pastemode to F2
set pastetoggle=<F2>

" real men don't use arrow keys
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" sane behaviour for moving over lines
nnoremap j gj
nnoremap k gk

" syntax highlighting fix
noremap <F12> <Esc>:syntax sync fromstart<CR>
inoremap <F12> <C-o>:syntax sync fromstart<CR>

" trim a string
function! StrTrim(txt)
  return substitute(a:txt, '^\n*\s*\(.\{-}\)\n*\s*$', '\1', '')
endfunction

" strip end of lines and change tabs to spaces
function! Clean()
  let _s=@/
  let l = line('.')
  let c = col('.')
  %s/\t/\ \ /ge
  %s/\s\+$//e
  let @/=_s
  call cursor(l, c)
  set ff=unix
endfunction
:nnoremap <F7> :call Clean()<CR>

" stop indenting my shit
:nnoremap <F8> :setl noai nocin nosi inde=<CR>

" easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Map W to write current buffer with superuser privileges
command W :execute ':silent w !sudo tee % >/dev/null' | :edit!
command Wq :execute ':silent w !sudo tee % >/dev/null' | :quit!

" Maps leader-R to reload .vimrc
map <leader>R ;source ~/.vimrc<cr>

" ctags
autocmd Filetype java set tags=$HOME/Documents/framework/.tags
autocmd Filetype jsp set tags=$HOME/Documents/framework/.tags

" theos
au BufNewFile,BufRead *.xm,*.xmm,*.l.mm setf logos

" be silent when grabbing scp files
let g:netrw_silent=1

" airline (bottom bar) theme
let g:airline_theme='papercolor'

" jsx
let g:jsx_ext_required = 0

" linting
let g:syntastic_mode_map = { 'mode': 'active', 'active_filetypes': ['python', 'javascript', 'javascript.jsx'], 'passive_filetypes': [] }

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']
let b:syntastic_javascript_eslint_exec = StrTrim(system('npm-which eslint'))

