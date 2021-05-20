local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path })
  vim.api.nvim_command('packadd packer.nvim')
end

local use = require('packer').use
require('packer').startup(function()
  -- Packer
  use 'wbthomason/packer.nvim'

  -- Styling
  use "siduck76/nvim-base16.lua"

  -- Git
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    }
  }

  -- Finder
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      { 'nvim-lua/popup.nvim' },
      { 'nvim-lua/plenary.nvim' },
    }
  }

  -- Collection of configurations for built-in LSP client
  use 'neovim/nvim-lspconfig'

  -- Treesitter for fancy syntax
  use 'nvim-treesitter/nvim-treesitter'

  -- Lightline for statusbar
  use {
    'itchyny/lightline.vim',
    requires = {
      { 'spywhere/lightline-lsp' },
      { 'mike-hearn/base16-vim-lightline' },
    }
  }

  -- File tree
  use 'kyazdani42/nvim-tree.lua'
end)

-- Spaces
vim.bo.expandtab = true
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.bo.shiftwidth = 2

-- Just have a sign column ready
vim.wo.signcolumn = 'yes'

-- Searching
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.showmatch = true
vim.o.incsearch = true

-- Annoying backup stuff
vim.o.backup = false
vim.o.writebackup = false
vim.o.history = 10000
vim.o.hidden = true

-- Line numbers
vim.wo.number = true

-- Undo, can't get this to work correctly with lua yet
vim.cmd[[
set undofile
set undodir=~/.local/share/nvim/undo
]]

-- Ignore
vim.o.wildignore = '*/node_modules/*,*/elm-stuff/*'

-- Leader
vim.g.mapleader = ','

-- Cursor lines are nice
vim.o.cursorline = true

-- Paste
vim.o.pastetoggle = '<F2>'
vim.o.clipboard = 'unnamed'

-- Regex
vim.o.re = 0

require('telescope').setup {
  defaults = {
    file_ignore_patterns = {
      '.git',
      'node_modules',
    },
  }
}

local maps = {
  i = {
    ['jj'] = '<Esc>',
  },
  n = {
    [':'] = ';',
    [';'] = ':',
    ['<C-n>'] = '<cmd>NvimTreeToggle<cr>',
    ['<C-p>'] = '<cmd>Telescope find_files<cr>',
    ['<leader>D'] = '<cmd>lua vim.lsp.buf.type_definition()<cr>',
    ['<leader>a'] = '<cmd>Telescope live_grep<cr>',
    ['<leader>b'] = '<cmd>Telescope buffers<cr>',
    ['<leader>gd'] = '<cmd>Gdiff<cr>',
    ['<leader>rn'] = '<cmd>lua vim.lsp.buf.rename()<cr>',
    ['K'] = '<cmd>lua vim.lsp.buf.hover()<cr>',
    ['[d'] = '<cmd>lua vim.lsp.buf.goto_prev()<cr>',
    [']d'] = '<cmd>lua vim.lsp.buf.goto_next()<cr>',
    ['gd'] = '<cmd>lua vim.lsp.buf.definition()<cr>',
    ['gr'] = '<cmd>lua vim.lsp.buf.references()<cr>',
    ['j'] = 'gj',
    ['k'] = 'gk',
  },
  [''] = {
    ['<space>'] = '@q',
  }
}

for mode, mappings in pairs(maps) do
  for keys, mapping in pairs(mappings) do
    vim.api.nvim_set_keymap(mode, keys, mapping, { noremap = true })
  end
end

-- Templates
-- Go to line with %HERE% on it, thanks vim-template for idea
vim.cmd[[
function! Here()
  0
  if search('%HERE%', 'W')
    let l = line('.')
    let c = col('.')
    s/%HERE%//ge
    call cursor(l, c)
  endif
endfunction

augroup templates
  autocmd BufNewFile *.handlebars 0r ~/.vim/templates/skeleton.html | call Here()
  autocmd BufNewFile *.htm 0r ~/.vim/templates/skeleton.html | call Here()
  autocmd BufNewFile *.html 0r ~/.vim/templates/skeleton.html | call Here()
  autocmd BufNewFile *.py 0r ~/.vim/templates/skeleton.py | call Here()
  autocmd BufNewFile *.sh 0r ~/.vim/templates/skeleton.sh | call Here()
augroup END
]]

-- Colors
vim.o.termguicolors = true
vim.o.background = 'dark'
local base16 = require('base16')
base16(base16.themes[vim.env.BASE16_THEME], true)

-- SQL has a massive slowdown for me
vim.g.omni_sql_no_default_maps = 1

-- Better formatting and styling
require('nvim-treesitter.configs').setup {
  ensure_installed = 'maintained',
  ignore_install = {},
  highlight = {
    enable = true,
    use_languagetree = true,
  },
  indent = {
    enable = true,
  },
}

-- Status line
vim.g.lightline = {
  active = {
    left = {
      { 'mode', 'paste' },
      { 'readonly', 'filename', 'mod' },
    },
    right = {
      { 'linter_ok', 'linter_checking', 'linter_errors', 'linter_warnings', 'lineinfo' },
      { 'fileinfo' },
    },
  },
  colorscheme = 'base16_' .. vim.env.BASE16_THEME,
  component_expand = {
    linter_errors = 'lightline#lsp#errors',
    linter_hints = 'lightline#lsp#hints',
    linter_infos = 'lightline#lsp#infos',
    linter_ok = 'lightline#lsp#ok',
    linter_warnings = 'lightline#lsp#warnings',
  },
  component_type = {
    linter_errors = 'error',
    linter_hints = 'right',
    linter_infos = 'right',
    linter_ok = 'right',
    linter_warnings = 'warning',
  },
}

-- File browser
vim.g.nvim_tree_auto_close = true
vim.g.nvim_tree_show_icons = {
  git = false,
  folders = false,
  files = false,
}
require('nvim-tree.config')

-- Git
require('gitsigns').setup {}

-- LSP
local nvim_lsp = require('lspconfig')

local servers = {
  'bashls',
  'cssls',
  'dockerls',
  'html',
  'ocamlls',
  'pyright',
  'tsserver',
  'vimls',
}

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {}
end
