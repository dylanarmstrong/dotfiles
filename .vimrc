" Use vim instead of vi stuff
set nocompatible

" Set up Pathogen
call pathogen#helptags()
call pathogen#infect('~/.vim/bundle')

" change the leader from \ to ,
let mapleader=","

set laststatus=2
set ttyfast

" Background buffers
set hidden
" Bigger history
set history=1000
" Tabbing settings
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" Neat tab completion
set wildmenu
set wildmode=longest:full,full

" highlight long lines
" set cc=80

" case insensitive searching except when string contains upper case characters
set ignorecase
set smartcase

" random options
let g:clipbrdDefaultRed = '+'
inoremap jj <Esc>
nnoremap JJJJ <Nop>
nnoremap ; :
nnoremap : ;
set number
set clipboard+=unnamed  
set encoding=utf-8
set runtimepath+=$HOME/.vim/autoload
set nobackup
set nowritebackup
set directory=$HOME/.vim/tmp
set mouse=a
set noerrorbells
set numberwidth=4
set novisualbell
set scrolloff=2
nnoremap <ESC><ESC> :set hlsearch!<CR>

" Paste
map <leader>pp ;r!xsel -p<CR>

" Taglist settings
let Tlist_Use_Right_Window=1
let Tlist_Exit_OnlyWindow=1
let Tlist_Use_SingleClick=1
let Tlist_Show_Menu=1
let Tlist_WinWidth=53
let Tlist_Inc_Winwidth=0
nnoremap <F3> :TlistToggle<CR>

syntax on
set hlsearch

" base16
set background=dark
colorscheme molokai

" File type detection and language-specific indentatition
filetype plugin indent on
set autoindent

" Sane search settings
set showmatch
set incsearch

" For all text files set width to 78 characters
" autocmd FileType text setlocal textwidth=78

" Set title when running inside a terminal
set title

" Bind pastemode to F2
set pastetoggle=<F2>

" Real men don't use arrow keys
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" Sane behaviour for moving over lines
nnoremap j gj
nnoremap k gk

" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Map W to write current buffer with superuser privileges
command W :execute ':silent w !sudo tee % >/dev/null' | :edit! 
command Wq :execute ':silent w !sudo tee % >/dev/null' | :quit!

" Map leader-f to open FuzzyFinder
map <leader>f ;FufFile<cr>
" Maps leader-h to open FuzzyFinder's help search
" map <leader>h ;FufHelp<cr>
map <leader>b ;FufBuffer<cr>

" Map for less 
nnoremap <leader>m :w <BAR> !lessc % > %:t:r.css<CR><space>

" Maps leader-R to reload .vimrc
map <leader>R ;source ~/.vimrc<cr>

map <leader>cd ;lcd %:h<cr>

" Remove whitespace function from http://vimcasts.org/episodes/tidying-whitespace/
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

function! Preserve(command)
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
nmap _$ :call Preserve("%s/\\s\\+$//e")<CR>
nmap _= :call Preserve("normal gg=G")<CR>

autocmd BufWritePre *.py,*.rb,*.hs,*.js :call <SID>StripTrailingWhitespaces()

