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
  use {
    'siduck76/nvim-base16.lua',
    config = function()
      local base16 = require('base16')
      base16(base16.themes[vim.env.BASE16_THEME], true)
    end
  }

  -- Git
  use 'tpope/vim-fugitive'
  use 'airblade/vim-gitgutter'

  -- Finder
  use {
    'nvim-telescope/telescope.nvim',
    run = 'vim.cmd[[TSUpdate]]',
    requires = {
      { 'nvim-lua/popup.nvim' },
      { 'nvim-lua/plenary.nvim' },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          file_ignore_patterns = {
            '.git',
            'node_modules',
          },
        }
      }
    end
  }

  -- LSP
  use {
    'neovim/nvim-lspconfig',
    config = function()
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
    end
  }

  -- Treesitter for fancy syntax
  use {
    'nvim-treesitter/nvim-treesitter',
    config = function()
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
    end
  }

  -- Status line
  use {
    'hoob3rt/lualine.nvim',
    config = function()
      -- Get character under cursor
      local get_hex = function()
        local hex = vim.api.nvim_exec([[
          ascii
        ]], true)
        if hex == nil then
          return 'nil'
        end

        hex = hex:match(',  Hex ([^,]+)')
        if hex == nil then
          return 'nil'
        end

        return '0x' .. hex
      end

      local get_diagnostics = function(bufnr)
        local levels = {
          E = 'Error',
          W = 'Warning',
          I = 'Info',
          H = 'Hint',
        }
        local res = ''
        for k, level in pairs(levels) do
          local n = vim.lsp.diagnostic.get_count(bufnr, level)
          if n > 0 then
            if res ~= '' then
              res = res .. ' | '
            end
            res = res .. k .. ': ' .. n
          end
        end
        return res
      end

      require('lualine').setup {
        options = {
          icons_enabled = false,
          component_separators = '|',
          section_separators = '',
          theme = 'dracula',
        },
        sections = {
          lualine_y = {
            get_diagnostics,
            get_hex,
          }
        },
      }
    end
  }

  -- Autocompletion
  use {
    'hrsh7th/nvim-compe',
    config = function()
      require('compe').setup {
        enabled = true,
        autocomplete = true,
        debug = false,
        min_length = 1,
        preselect = 'enable',
        throttle_time = 80,
        source_timeout = 200,
        incomplete_delay = 400,
        max_abbr_width = 100,
        max_kind_width = 100,
        max_menu_width = 100,
        documentation = true,

        source = {
          path = true,
          buffer = true,
          calc = true,
          nvim_lsp = true,
          nvim_lua = true,
          vsnip = false,
          ultisnips = false,
        },
      }
    end
  }

  -- Icons
  use {
    'kyazdani42/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup {
        default = true,
        override = {
          ['.conkyrc'] = {
            icon = '',
            color = '#6d8086',
            name = 'Conkyrc'
          },
          ['.xinitrc'] = {
            icon = '',
            color = '#6d8086',
            name = 'Xinitrc'
          },
          ['.Xresources'] = {
            icon = '',
            color = '#6d8086',
            name = 'XResources',
          },
        }
      }
    end
  }

  -- File browser
  use {
    'kyazdani42/nvim-tree.lua',
    config = function()
      require('nvim-tree.config')
    end
  }

  -- Diagnostics
  use {
    'folke/trouble.nvim',
    config = function()
      require('trouble').setup {}
    end
  }
end)

-- Spaces
-- Cannot wait for PR https://github.com/neovim/neovim/pull/13479
vim.bo.expandtab = true
vim.bo.shiftwidth = 2
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.bo.tabstop = 2
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.tabstop = 2

-- Completion
vim.o.completeopt = 'menuone,noselect'

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

-- Undo
vim.bo.undofile = true
vim.o.undodir = vim.env.HOME .. '/.local/share/nvim/undo'

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
    ['<leader>e'] = '<cmd>TroubleToggle lsp_workspace_diagnostics<cr>',
    ['<leader>f'] = '<cmd>lua vim.lsp.buf.formatting()<cr>',
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
  v = {
    -- Sort lines under visual select
    ['<leader>s'] = ":'<,'>sort<cr>",
  },
  [''] = {
    ['<space>'] = '@q',
  },
}

for mode, mappings in pairs(maps) do
  for keys, mapping in pairs(mappings) do
    vim.api.nvim_set_keymap(mode, keys, mapping, { noremap = true })
  end
end

-- Templates
-- Go to line with %HERE% on it, thanks vim-template for idea
-- Waiting on https://github.com/neovim/neovim/pull/12378
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

-- Configuration for file browser
vim.g.nvim_tree_auto_close = true
vim.g.nvim_tree_show_icons = {
  git = 0,
  folders = 1,
  files = 1,
}
vim.g.nvim_tree_special_files = {
  Makefile = false,
  ['Cargo.toml'] = false,
  ['README.md'] = false,
  ['readme.md'] = false,
}

-- SQL has a massive slowdown for me
vim.g.omni_sql_no_default_maps = 1
