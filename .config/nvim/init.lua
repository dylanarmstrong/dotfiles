local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out,                            'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Leader, needs to be before lazy load
vim.g.mapleader = ','

vim.g.cmptoggle = true

require('lazy').setup({
  -- Styling
  {
    'catppuccin/nvim',
    lazy = false,
    priority = 1000,
    opts = {
      flavour = 'mocha',
      integrations = {
        indent_blankline = {
          colored_indent_levels = false,
          enabled = true,
          scope_color = '',
        },
        gitsigns = true,
        lsp_trouble = true,
        lualine = true,
        markdown = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { 'italic' },
            hints = { 'italic' },
            warnings = { 'italic' },
            information = { 'italic' },
            ok = { 'italic' },
          },
          underlines = {
            errors = { 'underline' },
            hints = { 'underline' },
            warnings = { 'underline' },
            information = { 'underline' },
            ok = { 'underline' },
          },
          inlay_hints = {
            background = true,
          },
        },
        neotree = true,
        symbols_outline = true,
        telescope = true,
      },
    },
    config = function()
      vim.cmd([[ colorscheme catppuccin ]])
    end,
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    cond = not vim.g.vscode,
    main = 'ibl',
    opts = {},
  },

  {
    'brenoprata10/nvim-highlight-colors',
    cond = not vim.g.vscode,
    event = 'BufReadPre',
    opts = {
      render = 'virtual',
      virtual_symbol_position = 'eol',
      virtual_symbol_suffix = '',
      enable_tailwind = true,
    },
  },

  -- Git
  {
    'tpope/vim-fugitive',
    cond = not vim.g.vscode,
  },

  {
    'lewis6991/gitsigns.nvim',
    cond = not vim.g.vscode,
    opts = {},
  },

  -- Undo
  {
    'mbbill/undotree',
    cond = not vim.g.vscode,
  },

  -- Finder
  {
    'nvim-telescope/telescope.nvim',
    cond = not vim.g.vscode,
    dependencies = {
      'nvim-lua/plenary.nvim',
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

  {
    'nvim-telescope/telescope-fzf-native.nvim',
    cond = not vim.g.vscode,
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    build = 'make',
    config = function()
      require('telescope').load_extension('fzf')
    end,
  },

  -- LSP (with autocomplete)
  {
    'hrsh7th/nvim-cmp',
    cond = not vim.g.vscode,
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
    },
    main = 'cmp',
    opts = function(_, opts)
      opts.enabled = function()
        -- Don't enable autocomplete inside of comments
        local context = require('cmp.config.context')
        local buftype = vim.bo.buftype

        -- Don't enable on prompts either
        if buftype == 'prompt' then
          return false
        end

        -- Disabled globally
        if not vim.g.cmptoggle then
          return false
        end

        if vim.api.nvim_get_mode().mode == 'c' then
          return true
        else
          return not context.in_treesitter_capture('comment') and not context.in_syntax_group('Comment')
        end
      end
      opts.sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
      }
      local cmp = require('cmp')
      opts.mapping = cmp.mapping.preset.insert({
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
      })
    end,
  },

  {
    'neovim/nvim-lspconfig',
    cond = not vim.g.vscode,
    dependencies = {
      'hrsh7th/nvim-cmp',
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
        'ltex',
        'ocamlls',
        'pyright',
        'sourcekit',
        'svelte',
        'terraformls',
        'tinymist',
        'ts_ls',
        'vimls',
      }

      for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup({
          capabilities = capabilities,
        })
      end

      nvim_lsp.clangd.setup({
        capabilities = capabilities,
        cmd = { 'clangd', '--offset-encoding=utf-16' },
      })

      nvim_lsp.ltex.setup({
        settings = {
          ltex = {
            language = 'en-US',
          },
        },
      })

      nvim_lsp.tailwindcss.setup({
        capabilities = capabilities,
        root_dir = nvim_lsp.util.root_pattern('tailwind.config.ts', 'tailwind.config.js', '.git'),
      })

      nvim_lsp.emmet_ls.setup({
        capabilities = capabilities,
        filetypes = {
          'css',
          'html',
          'javascript',
          'javascriptreact',
          'less',
          'sass',
          'scss',
          'svelte',
          'pug',
          'typescriptreact',
          'vue',
        },
      })

      nvim_lsp.cssls.setup({
        capabilities = capabilities,
        settings = {
          css = {
            lint = {
              unknownAtRules = 'ignore',
            },
          },
        },
      })

      nvim_lsp.lua_ls.setup({
        capabilities = capabilities,
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
            return
          end
        end,
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              checkThirdParty = false,
              -- Using vim.api.nvim_get_runtime_file('', true) causes issues when working on nvim/init.lua
              library = {
                vim.env.VIMRUNTIME,
                '${3rd}/luv/library',
              },
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })

      nvim_lsp.elixirls.setup({
        capabilities = capabilities,
        cmd = { os.getenv('HOME') .. '/src/elixir-ls/dist/language_server.sh' },
      })

      nvim_lsp.eslint.setup({
        capabilities = capabilities,
        -- Fix issues on save
        on_attach = function(_, bufnr)
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = bufnr,
            command = 'EslintFixAll',
          })
        end,
        handlers = {
          ['eslint/noConfig'] = function()
            return {}
          end,
          ['eslint/noLibrary'] = function()
            return {}
          end,
        },
        root_dir = nvim_lsp.util.root_pattern('.git'),
      })

      nvim_lsp.oxlint.setup({
        capabilities = capabilities,
        -- Fix issues on save
        -- on_attach = function(_, bufnr)
        --   vim.api.nvim_create_autocmd('BufWritePre', {
        --     buffer = bufnr,
        --     command = 'OxcFixAll',
        --   })
        -- end,
        root_dir = nvim_lsp.util.root_pattern('.git'),
      })

      nvim_lsp.efm.setup({
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
      })

      nvim_lsp.groovyls.setup({
        capabilities = capabilities,
        cmd = {
          'java',
          '-jar',
          os.getenv('HOME') .. '/src/groovy-language-server/build/libs/groovy-language-server-all.jar',
        },
      })
    end,
  },

  -- Having issues with efm langserver on typescriptreact
  {
    'stevearc/conform.nvim',
    cond = not vim.g.vscode,
    opts = {
      formatters_by_ft = {
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        json = { 'prettier' },
        html = { 'prettier' },
        css = { 'prettier' },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },

  {
    'simrat39/rust-tools.nvim',
    cond = not vim.g.vscode,
    opts = {
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
        on_attach = function(_, _) end,
        settings = {
          ['rust-analyzer'] = {
            checkOnSave = {
              command = 'clippy',
            },
          },
        },
      },
    },
  },

  -- Debugger
  {
    'mfussenegger/nvim-dap',
    cond = not vim.g.vscode,
    dependencies = {
      'mxsdev/nvim-dap-vscode-js',
    },
    config = function()
      require('dap').adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'node',
          args = { os.getenv('HOME') .. '/src/js-debug/src/dapDebugServer.js', '${port}' },
        },
      }
      require('dap').configurations.javascript = {
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          cwd = '${workspaceFolder}',
        },
      }
    end,
  },

  -- Treesitter for fancy syntax
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = 'BufRead',
    opts = {
      auto_install = true,
      ensure_installed = 'all',
      highlight = {
        enable = true,
        use_languagetree = true,
      },
      ignore_install = {},
      indent = { enable = false },
      modules = {},
      sync_install = false,
    },
    main = 'nvim-treesitter.configs',
  },

  {
    'hedyhli/outline.nvim',
    cond = not vim.g.vscode,
    opts = {},
  },

  -- Jenkinsfiles (groovyls doesn't work for me)
  {
    'martinda/Jenkinsfile-vim-syntax',
    cond = not vim.g.vscode,
  },

  -- Typst support
  {
    'kaarmu/typst.vim',
    cond = not vim.g.vscode,
    ft = { 'typst' },
  },

  -- Pug support
  {
    'digitaltoad/vim-pug',
    cond = not vim.g.vscode,
  },

  -- Comments
  -- visual mode = gc = comment
  'tpope/vim-commentary',

  -- Status line
  {
    'hoob3rt/lualine.nvim',
    cond = not vim.g.vscode,
    opts = {
      options = {
        icons_enabled = false,
        component_separators = '|',
        section_separators = '',
        theme = 'catppuccin',
      },
      sections = {
        lualine_b = {
          'fugitive#head',
        },
        lualine_y = {
          {
            'diagnostics',
            sources = {
              'nvim_diagnostic',
            },
            symbols = {
              error = ' ',
              warn = ' ',
              info = ' ',
            },
          },
        },
      },
    },
  },

  -- Icons
  {
    'nvim-tree/nvim-web-devicons',
    cond = not vim.g.vscode,
    opts = {
      default = true,
      color_icons = true,
    },
  },

  -- File browser
  {
    'nvim-neo-tree/neo-tree.nvim',
    cond = not vim.g.vscode,
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      close_if_last_window = true,
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
        },
      },
    },
  },

  -- Diagnostics
  {
    'folke/trouble.nvim',
    cond = not vim.g.vscode,
    opts = {
      focus = true,
    },
  },

  -- Templates
  {
    'vigoux/templar.nvim',
    cond = not vim.g.vscode,
    config = function()
      local templar = require('templar')
      templar.register('*.html')
      templar.register('*.py')
      templar.register('*.sh')
    end,
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

  checker = { enabled = true },
})

-- Per recommendation on nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3

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
vim.opt.wildignore = '*/node_modules/*'

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

local common_maps = {
  [':'] = ';',
  [';'] = ':',
  -- Uppercase Y will grab entire line
  ['Y'] = 'yy',
  -- Natural movement over visual lines
  ['j'] = 'gj',
  ['k'] = 'gk',
}

local nvim_only_maps = {
  ['<C-n>'] = '<cmd>Neotree toggle<cr>',
  ['<C-p>'] = '<cmd>Telescope find_files<cr>',
  ['<leader>D'] = '<cmd>lua vim.lsp.buf.type_definition()<cr>',
  ['<leader>a'] = '<cmd>Telescope live_grep<cr>',
  ['<leader>b'] = '<cmd>Telescope buffers<cr>',
  ['<leader>e'] = '<cmd>Trouble diagnostics toggle<cr>',
  ['<leader>f'] = '<cmd>lua vim.lsp.buf.format { async = true }<cr>',
  ['<leader>o'] = '<cmd>Outline<cr>',
  ['<leader>u'] = '<cmd>UndotreeToggle<cr>',
  ['<leader>gd'] = '<cmd>Gdiff<cr>',
  ['<leader>gs'] = '<cmd>Gstatus<cr>',
  ['<leader>rn'] = '<cmd>lua vim.lsp.buf.rename()<cr>',
  ['<leader>z'] = '<cmd>lua vim.g.cmptoggle = not vim.g.cmptoggle<cr>',
  ['K'] = '<cmd>lua vim.lsp.buf.hover()<cr>',
  ['[d'] = '<cmd>lua vim.lsp.buf.goto_prev()<cr>',
  [']d'] = '<cmd>lua vim.lsp.buf.goto_next()<cr>',
  ['gD'] = '<cmd>lua vim.lsp.buf.declaration()<cr>',
  ['gd'] = '<cmd>lua vim.lsp.buf.definition()<cr>',
  ['gi'] = '<cmd>lua vim.lsp.buf.implementation()<cr>',
  ['gr'] = '<cmd>lua vim.lsp.buf.references()<cr>',
}

-- If we're on Cursor, only load keybindings available
local maps_n = vim.g.vscode and common_maps or vim.tbl_extend('force', common_maps, nvim_only_maps)

local maps = {
  i = {
    ['<C-c>'] = '<Esc>',
  },
  n = maps_n,
  v = {
    ['<leader>s'] = ':\'<,\'>sort<cr>',
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

-- vim: shiftwidth=2:
