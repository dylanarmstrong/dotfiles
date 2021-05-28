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
    'fnune/base16-vim',
    config = function()
      local home = os.getenv('HOME')
      vim.g.base16_shell_path = home .. '/src/base16/base16-shell/scripts'
      vim.g.base16colorspace = 256
      if io.open(home .. '/.vimrc_background', 'r') ~= nil then
        vim.cmd[[
          source ~/.vimrc_background
        ]]
      end
    end
  }

  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
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
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
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
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make',
    config = function()
      require('telescope').load_extension('fzf')
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

  -- Comments
  -- visual mode = gc = comment
  use 'tpope/vim-commentary'

  -- Workspace todo comments
  use {
    'folke/todo-comments.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require('todo-comments').setup {}
    end
  }

  -- Neovim plugin dev
  use 'folke/lua-dev.nvim'

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

      require('lualine').setup {
        options = {
          icons_enabled = false,
          component_separators = '|',
          section_separators = '',
          theme = 'dracula',
        },
        sections = {
          lualine_b = {
            'fugitive#head'
          },
          lualine_y = {
            {
              'diagnostics',
              sources = {
                'nvim_lsp'
              },
              symbols = {
                error = ' ',
                warn = ' ',
                info = ' '
              },
              color_error = '#ea51b2',
              color_warn = '#00f769',
              color_info = '#a1efe4',
            },
            get_hex,
          },
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

      vim.g.nvim_tree_auto_open = 1
      vim.g.nvim_tree_auto_close = 1
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
    end
  }

  -- Diagnostics
  use {
    'folke/trouble.nvim',
    config = function()
      require('trouble').setup {}
    end
  }
end, {
  display = {
    -- This isn't working as expected, need to look into
    open_fn = require('packer.util').float,
  }
})

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
vim.o.undodir = os.getenv('HOME') .. '/.local/share/nvim/undo'

-- Ignore
vim.o.wildignore = '*/node_modules/*,*/elm-stuff/*'

-- Leader
vim.g.mapleader = ','

-- Cursor lines are nice
vim.wo.cursorline = true

-- Paste
vim.o.pastetoggle = '<F2>'
vim.o.clipboard = 'unnamedplus'

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
    ['<leader>gs'] = '<cmd>Gstatus<cr>',
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

-- SQL has a massive slowdown for me
vim.g.omni_sql_no_default_maps = true
