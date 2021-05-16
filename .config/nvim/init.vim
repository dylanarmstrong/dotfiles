" line numbers
set number

" gimme spaces please
set tabstop=2
set shiftwidth=2
set softtabstop=2
set numberwidth=4
set expandtab

" just stop please
set nobackup
set nowritebackup
set history=10000
set hidden

" copy and paste
set clipboard=unnamed

" infinite undo
set undofile
set undodir=~/.local/share/nvim/undo

" better search
set ignorecase
set smartcase
set showmatch
set incsearch

" regex
set re=0

" ignore these
set wildignore=*/node_modules/*,*/elm-stuff/*

" bind pastemode to F2
set pastetoggle=<F2>

" i just dont care for \
let mapleader=','

" i like cursor lines
set cursorline

" couple saner remaps
inoremap jj <Esc>
nnoremap ; :
nnoremap : ;

" sane behaviour for moving over lines
nnoremap j gj
nnoremap k gk

" templates
" go to line with %HERE% on it, thanks vim-template for idea
function! Here()
  0
  if search('%HERE%', 'W')
    let l = line('.')
    let c = col('.')
    s/%HERE%//ge
    call cursor(l, c)
  endif
endfunction

" group of template loads
augroup templates
  autocmd BufNewFile *.handlebars 0r ~/.vim/templates/skeleton.html | call Here()
  autocmd BufNewFile *.htm 0r ~/.vim/templates/skeleton.html | call Here()
  autocmd BufNewFile *.html 0r ~/.vim/templates/skeleton.html | call Here()
  autocmd BufNewFile *.py 0r ~/.vim/templates/skeleton.py | call Here()
  autocmd BufNewFile *.sh 0r ~/.vim/templates/skeleton.sh | call Here()
augroup END

" map W to write current buffer with superuser privileges
command W :execute ':silent w !sudo tee % >/dev/null' | :edit!
command Wq :execute ':silent w !sudo tee % >/dev/null' | :quit!

" plugins
call plug#begin()
" Elixir
Plug('https://github.com/elixir-editors/vim-elixir')

" Browsing
Plug('https://github.com/scrooloose/nerdtree')

" Comments
Plug('https://github.com/tyru/caw.vim')

" Elm
Plug('https://github.com/ElmCast/elm-vim')

" Formatting
Plug('https://github.com/machakann/vim-sandwich')

" Git
" Plug('https://github.com/airblade/vim-gitgutter')
Plug('https://github.com/tpope/vim-fugitive')

" Javascript
Plug('https://github.com/MaxMEllon/vim-jsx-pretty')
Plug('https://github.com/herringtondarkholme/yats.vim')
Plug('https://github.com/pangloss/vim-javascript')

" JSON
Plug('https://github.com/elzr/vim-json')

" Lightline
Plug('https://github.com/itchyny/lightline.vim')
Plug('https://github.com/maximbaz/lightline-ale')
Plug('https://github.com/mike-hearn/base16-vim-lightline')

" Linting
Plug('https://github.com/w0rp/ale')

" Logos
Plug('/Users/dylan/src/logos/extras/vim')

" Markdown
Plug('https://github.com/tpope/vim-markdown')

" Pug (Jade)
Plug('https://github.com/digitaltoad/vim-pug')

" ReasonML
Plug('https://github.com/reasonml-editor/vim-reason-plus')

" Rescript
Plug('https://github.com/rescript-lang/vim-rescript')

" Styling
Plug('https://github.com/fnune/base16-vim')

" Stylus
Plug('https://github.com/wavded/vim-stylus')

" Swift
Plug('https://github.com/keith/swift.vim')

" Telescope
Plug('https://github.com/nvim-lua/popup.nvim')
Plug('https://github.com/nvim-lua/plenary.nvim')
Plug('https://github.com/nvim-telescope/telescope.nvim')

" Undo
Plug('https://github.com/mbbill/undotree')

" Vue
Plug('https://github.com/posva/vim-vue.git')
call plug#end()

" Telescope
nnoremap <leader>a :Telescope live_grep<cr>
nnoremap <leader>b :Telescope buffers<cr>
nnoremap <C-p> :Telescope find_files<cr>

" filetypes
augroup filetypes
  au BufNewFile,BufRead *.md set filetype=markdown
  au BufNewFile,BufRead *.tsx,*.jsx set filetype=javascriptreact
  au BufNewFile,BufRead *.x,*.xm,*.xmm,*.l.mm setf logos
augroup END

" vim-json
let g:vim_json_syntax_conceal = 0

" Thank you HN, easy macro use
noremap <Space> @q

" nerdtree
nnoremap <C-n> :NERDTreeToggle<CR>
augroup nerd
  autocmd bufenter * if (winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree()) | q | endif
  autocmd vimenter * wincmd p
augroup END

" undotree
nnoremap <leader>m :UndotreeToggle<CR>

" vim-javascript
let g:javascript_plugin_flow = 1

" fugitive
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gca :Gcommit --amend<CR>
nnoremap <leader>gw :Gwrite<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gp :Gpush<CR>
nnoremap <leader>gv :Gvdiff<CR>
nnoremap <leader>gs :Gstatus<CR>

" ALE Prettier
let g:ale_fixers = {
        \ 'javascript': [ 'eslint' ],
        \ 'typescript': [ 'eslint' ],
        \ 'javascriptreact': [ 'eslint' ],
        \ 'typescriptreact': [ 'eslint' ],
        \ 'javascript.jsx': [ 'eslint' ],
        \ 'typescript.jsx': [ 'eslint' ]
      \ }

let g:ale_fix_on_save = 0
let g:ale_sign_column_always = 1
let g:ale_set_highlights = 0
nnoremap <leader>f :ALEFix<CR>
nnoremap <leader>k :ALEPreviousWrap<CR>
nnoremap <leader>j :ALENextWrap<CR>

" lightline
let g:lightline = {
        \ 'colorscheme': 'base16_dracula',
        \ 'active': {
          \ 'left': [
            \ [ 'mode', 'paste' ],
            \ [ 'readonly', 'filename', 'mod' ]
          \ ],
          \ 'right': [
            \ [ 'linter_ok', 'linter_checking', 'linter_errors', 'linter_warnings', 'lineinfo' ],
            \ [ 'fileinfo' ]
          \ ]
        \ },
        \ 'component': {
          \ 'lineinfo': '%l:%-v'
        \ },
        \ 'component_expand': {
          \ 'linter_checking': 'lightline#ale#checking',
          \ 'linter_errors': 'lightline#ale#errors',
          \ 'linter_ok': 'lightline#ale#ok',
          \ 'linter_warnings': 'lightline#ale#warnings'
        \ },
        \ 'component_type': {
          \ 'linter_checking': 'left',
          \ 'linter_errors': 'error',
          \ 'linter_ok': 'left',
          \ 'linter_warnings': 'warning'
        \ },
        \ 'component_function': {
          \ 'gitbranch': 'fugitive#head',
          \ 'pwd': 'LightlineWorkingDirectory',
          \ 'fileinfo': 'LightlineFileinfo'
        \ }
      \ }

function! LightlineFileinfo()
  if winwidth(0) < 90
    return ''
  endif

  let encoding = &fenc !=# '' ? &fenc : &enc
  let format = &ff
  let type = &ft !=# '' ? &ft : 'no ft'
  return type . ' | ' . format . ' | ' . encoding
endfunction

function! LightlineWorkingDirectory()
  return &ft =~ 'help\|qf' ? '' : fnamemodify(getcwd(), ':~:.')
endfunction

" be silent when grabbing scp files
let g:netrw_silent = 1

" jsx
let g:jsx_ext_required = 0

" colors
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let g:base16_shell_path = expand('~/src/base16/base16-shell/scripts')
if filereadable(expand('~/.vimrc_background'))
  let base16colorspace = 256
  source ~/.vimrc_background
endif
set background=dark
set termguicolors

" annoying sql
let g:omni_sql_no_default_maps = 1

" custom highlighting
" highlight Comment cterm=italic

lua << EOF
require('telescope').setup{
  defaults = {
    file_ignore_patterns = {
      '.git',
      'node_modules',
    },
  },
}
EOF
