local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.cmptoggle = true

require('lazy').setup({
    -- Styling
  {
    'catppuccin/nvim',
    lazy = false,
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
  },

  'lukas-reineke/indent-blankline.nvim',

  {
    'norcalli/nvim-colorizer.lua',
    event = 'BufRead',
    config = function()
      require('colorizer').setup()
    end
  },

  -- Git
  'tpope/vim-fugitive',
  'airblade/vim-gitgutter',

  -- Undo
  'mbbill/undotree',

  -- Finder
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      config = function()
        require('telescope').load_extension('fzf')
      end,
    },
    opts = {
      defaults = {
        file_ignore_patterns = {
          '.git',
          'node_modules',
        },
      },
    },
  },

  -- LSP (with autocomplete)
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/nvim-cmp',
      'hrsh7th/vim-vsnip',
    },
    config = function()
      local nvim_lsp = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local servers = {
        'bashls',
        'dhall_lsp_server',
        'dockerls',
        'graphql',
        'html',
        'jsonls',
        'nxls',
        'ocamlls',
        'pyright',
        'svelte',
        'tailwindcss',
        'tsserver',
        'typst_lsp',
        'vimls',
      }

      for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {
          capabilities = capabilities,
        }
      end

      nvim_lsp.cssls.setup {
        capabilities = capabilities,
        settings = {
          css = {
            lint = {
              unknownAtRules = 'ignore',
            },
          },
        },
      }


      nvim_lsp.lua_ls.setup {
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { 'vim' },
            },
            workspace = {
              -- Stop annoying popup on lua files
              checkThirdParty = false,
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file('', true),
            },
            -- Do not send telemetry
            telemetry = {
              enable = false,
            },
          },
        },
      }

      nvim_lsp.elixirls.setup {
        capabilities = capabilities,
        cmd = { os.getenv('HOME') .. '/src/elixir-ls/dist/language_server.sh' }
      }

      nvim_lsp.eslint.setup {
        capabilities = capabilities,
        -- Fix issues on save
        on_attach = function(_, bufnr)
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = bufnr,
            command = 'EslintFixAll',
          })
        end,
      }

      nvim_lsp.efm.setup {
        init_options = { documentFormatting = true },
        settings = {
          rootMarkers = { '.git/' },
          languages = {
            javascript = {
              {
                formatCommand = 'prettier',
                formatStdin = true,
              },
            },
          },
        },
      }

      nvim_lsp.groovyls.setup {
        capabilities = capabilities,
        cmd = { 'java', '-jar', os.getenv('HOME') .. '/src/groovy-language-server/build/libs/groovy-language-server-all.jar' }
      }

      local cmp = require('cmp')

      cmp.setup {
        enabled = function()
          -- Don't enable autocomplete inside of comments
          if require'cmp.config.context'.in_treesitter_capture('comment')==true or require'cmp.config.context'.in_syntax_group('Comment') then
            return false
          else
            return vim.g.cmptoggle
          end
        end,
        snippet = {
          expand = function(args)
            vim.fn['vsnip#anonymous'](args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        }),
      }

    end
  },

  {
    'simrat39/rust-tools.nvim',
    config = function()
      local rt = require('rust-tools')
      rt.setup({
        tools = {
          runnables = {
            use_telescope = true,
          },
          inlay_hints = {
            auto = true,
            show_parameter_hints = false,
            parameter_hints_prefix = '',
            other_hints_prefix = '',
          },
        },
        server = {
          on_attach = function(_, _)
          end,
          settings = {
            ['rust-analyzer'] = {
              checkOnSave = {
                command = 'clippy',
              },
            },
          },
        },
      })
    end,
  },

  -- Debugger
  -- {
  --   'mfussenegger/nvim-dap',
  --   dependencies = {
  --     'mxsdev/nvim-dap-vscode-js',
  --   },
  --   config = function()
  --     require('dap').adapters['pwa-node'] = {
  --       type = 'server',
  --       host = 'localhost',
  --       port = '${port}',
  --       executable = {
  --         command = 'node',
  --         args = {'/Users/dylan/Downloads/js-debug/src/dapDebugServer.js', '${port}'},
  --       }
  --     }
  --     require('dap').configurations.javascript = {
  --       {
  --         type = 'pwa-node',
  --         request = 'launch',
  --         name = 'Launch file',
  --         program = '${file}',
  --         cwd = '${workspaceFolder}',
  --       },
  --     }
  --   end,
  -- },

  -- Treesitter for fancy syntax
  {
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
  },

  {
    'simrat39/symbols-outline.nvim',
    config = function()
      require('symbols-outline').setup()
    end
  },

  -- Jenkinsfiles (groovyls doesn't work for me)
  'martinda/Jenkinsfile-vim-syntax',

  -- Typst support
  {
    'kaarmu/typst.vim',
    ft = { 'typst' }
  },

  -- Pug support
  'digitaltoad/vim-pug',

  -- Comments
  -- visual mode = gc = comment
  'tpope/vim-commentary',

  -- Status line
  {
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
  },

  -- Icons
  {
    'nvim-tree/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup {
        default = true,
        color_icons = true,
      }
    end
  },

  -- File browser
  {
    'nvim-tree/nvim-tree.lua',
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
  },

  -- Diagnostics
  {
    'folke/trouble.nvim',
    config = function()
      require('trouble').setup {}
    end
  },

  -- Templates
  {
    'vigoux/templar.nvim',
    config = function()
      local templar = require('templar')
      templar.register('*.html')
      templar.register('*.py')
      templar.register('*.sh')
    end
  },

  -- Movement
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    keys = {
      {
        's',
        mode = { 'n', 'x', 'o' },
        function()
          -- default options: exact mode, multi window, all directions, with a backdrop
          require('flash').jump()
        end,
      },
    },
  },
})

-- Per recommendation on nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Folding
vim.opt.foldmethod = 'marker'

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
    ['<C-s>'] = '<cmd>SymbolsOutline<cr>',
    ['<leader>D'] = '<cmd>lua vim.lsp.buf.type_definition()<cr>',
    ['<leader>a'] = '<cmd>Telescope live_grep<cr>',
    ['<leader>b'] = '<cmd>Telescope buffers<cr>',
    ['<leader>e'] = '<cmd>TroubleToggle workspace_diagnostics<cr>',
    ['<leader>f'] = '<cmd>lua vim.lsp.buf.format { async = true }<cr>',
    ['<leader>gd'] = '<cmd>Gdiff<cr>',
    ['<leader>gs'] = '<cmd>Gstatus<cr>',
    ['<leader>rn'] = '<cmd>lua vim.lsp.buf.rename()<cr>',
    ['<leader>z'] = '<cmd>lua vim.g.cmptoggle = not vim.g.cmptoggle<cr>',
    ['K'] = '<cmd>lua vim.lsp.buf.hover()<cr>',
    -- Uppercase Y will grab entire line
    ['Y'] = 'yy',
    ['[d'] = '<cmd>lua vim.lsp.buf.goto_prev()<cr>',
    [']d'] = '<cmd>lua vim.lsp.buf.goto_next()<cr>',
    ['gD'] = '<cmd>lua vim.lsp.buf.declaration()<cr>',
    ['gd'] = '<cmd>lua vim.lsp.buf.definition()<cr>',
    ['gi'] = '<cmd>lua vim.lsp.buf.implementation()<cr>',
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
