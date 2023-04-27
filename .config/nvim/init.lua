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
    'catppuccin/nvim',
    config = function()
      require('catppuccin').setup {
        flavour = 'mocha',
        integrations = {
          gitgutter = true,
          indent_blankline = {
            enabled = true,
            colored_indent_levels = false,
          },
          lsp_trouble = true,
          native_lsp = {
            enabled = true,
            underlines = {
              errors = { 'underline' },
              hints = { 'underline' },
              information = { 'underline' },
              warnings = { 'underline' },
            },
            virtual_text = {
              errors = { 'italic' },
              hints = { 'italic' },
              information = { 'italic' },
              warnings = { 'italic' },
            },
          },
          nvimtree = true,
          telescope = true,
        },
      }
      vim.cmd[[ colorscheme catppuccin ]]
    end
  }

  use 'lukas-reineke/indent-blankline.nvim'

  use {
    'norcalli/nvim-colorizer.lua',
    event = 'BufRead',
    config = function()
      require('colorizer').setup()
    end
  }

  -- Pug
  use 'digitaltoad/vim-pug'

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
        'svelte',
        'tsserver',
        'vimls',
        'rust_analyzer',
      }

      for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {}
      end

      nvim_lsp.eslint.setup {
        handlers = {
          ['window/showMessageRequest'] = function(_, result, params) return result end
        }
      }
    end
  }

  -- Treesitter for fancy syntax
  use {
    'nvim-treesitter/nvim-treesitter',
    event = 'BufRead',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = 'all',
        ignore_install = {},
        highlight = {
          enable = true,
          use_languagetree = true,
        },
      }
    end
  }

  -- Jenkinsfiles (groovyls doesn't work for me)
  use 'martinda/Jenkinsfile-vim-syntax'

  -- Comments
  -- visual mode = gc = comment
  use 'tpope/vim-commentary'

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
          theme = 'catppuccin',
        },
        sections = {
          lualine_b = {
            'fugitive#head'
          },
          lualine_y = {
            {
              'diagnostics',
              sources = {
                'nvim_diagnostic'
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
    'nvim-tree/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup {
        default = true,
        color_icons = true,
      }
    end
  }

  -- File browser
  use {
    'kyazdani42/nvim-tree.lua',
    config = function()
      require('nvim-tree').setup {
        renderer = {
          icons = {
            show = {
              file = true,
              folder_arrow = true,
              folder = true,
              git = false,
            },
          },
          special_files = {
            'Makefile',
            'Cargo.toml',
            'README.md',
            'readme.md',
          },
        },
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

  -- Templates
  use {
    'vigoux/templar.nvim',
    config = function()
      local templar = require('templar')
      templar.register('*.html')
      templar.register('*.py')
      templar.register('*.sh')
    end
  }
end, {
  display = {
    open_fn = require('packer.util').float,
  }
})

-- Spaces
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.numberwidth = 4

-- Completion
vim.opt.completeopt = 'menuone,noselect'

-- Just have a sign column ready
vim.opt.signcolumn = 'yes'

-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showmatch = true
vim.opt.incsearch = true

-- Annoying backup stuff
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.history = 10000
vim.opt.hidden = true

-- Line numbers
vim.opt.number = true

-- Undo
vim.opt.undofile = true
vim.opt.undodir = os.getenv('HOME') .. '/.local/share/nvim/undo'

-- Ignore
vim.opt.wildignore = '*/node_modules/*,*/elm-stuff/*'

-- Leader
vim.g.mapleader = ','

-- Cursor lines are nice
vim.opt.cursorline = true

-- Paste
vim.opt.pastetoggle = '<F2>'
vim.opt.clipboard = 'unnamed'

-- Regex
vim.opt.re = 0

-- Colors
vim.opt.termguicolors = true
vim.opt.background = 'dark'

-- SQL has a massive slowdown for me
vim.g.omni_sql_no_default_maps = true

local maps = {
  i = {
    ['<C-c>'] = '<Esc>',
  },
  n = {
    [':'] = ';',
    [';'] = ':',
    ['<C-n>'] = '<cmd>NvimTreeToggle<cr>',
    ['<C-p>'] = '<cmd>Telescope find_files<cr>',
    ['<leader>D'] = '<cmd>lua vim.lsp.buf.type_definition()<cr>',
    ['<leader>a'] = '<cmd>Telescope live_grep<cr>',
    ['<leader>b'] = '<cmd>Telescope buffers<cr>',
    ['<leader>e'] = '<cmd>TroubleToggle workspace_diagnostics<cr>',
    ['<leader>f'] = '<cmd>lua vim.lsp.buf.formatting()<cr>',
    ['<leader>gd'] = '<cmd>Gdiff<cr>',
    ['<leader>gs'] = '<cmd>Gstatus<cr>',
    ['<leader>rn'] = '<cmd>lua vim.lsp.buf.rename()<cr>',
    ['K'] = '<cmd>lua vim.lsp.buf.hover()<cr>',
    -- Uppercase Y will grab entire line
    ['Y'] = 'yy',
    ['[d'] = '<cmd>lua vim.lsp.buf.goto_prev()<cr>',
    [']d'] = '<cmd>lua vim.lsp.buf.goto_next()<cr>',
    ['gd'] = '<cmd>lua vim.lsp.buf.definition()<cr>',
    ['gr'] = '<cmd>lua vim.lsp.buf.references()<cr>',
    -- Natural movement over visual lines
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
