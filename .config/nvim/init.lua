local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

local plugin_commits = {
  ['brenoprata10/nvim-highlight-colors'] = 'e2cb22089cc2358b2b995c09578224f142de6039',
  ['catppuccin/nvim'] = '426dbebe06b5c69fd846ceb17b42e12f890aedf1',
  ['digitaltoad/vim-pug'] = 'ea39cd942cf3194230cf72bfb838901a5344d3b3',
  ['dmmulroy/ts-error-translator.nvim'] = '558abff11b9e8f4cefc0de09df780c56841c7a4b',
  ['echasnovski/mini.nvim'] = '5849ef04c32a6a8e55957b946c0a275801d87530',
  ['folke/flash.nvim'] = 'fcea7ff883235d9024dc41e638f164a450c14ca2',
  ['folke/lazy.nvim'] = '306a05526ada86a7b30af95c5cc81ffba93fef97',
  ['folke/lazydev.nvim'] = 'ff2cbcba459b637ec3fd165a2be59b7bbaeedf0d',
  ['folke/trouble.nvim'] = 'bd67efe408d4816e25e8491cc5ad4088e708a69a',
  ['hedyhli/outline.nvim'] = 'c293eb56db880a0539bf9d85b4a27816960b863e',
  ['ibhagwan/fzf-lua'] = 'ffa44ee9470743a7697d28df3a1a216fdfe2b09d',
  ['jmbuhr/otter.nvim'] = 'a455e68a99d395889ab30a25ac3846a135e93c46',
  ['julienvincent/hunk.nvim'] = 'a73c34934e87af4f2e615fea3a57ee28b2dceec8',
  ['kaarmu/typst.vim'] = '1d5436c0f55490893892441c0eca55e6cdf4916c',
  ['lewis6991/gitsigns.nvim'] = '6d808f99bd63303646794406e270bd553ad7792e',
  ['lukas-reineke/indent-blankline.nvim'] = 'd28a3f70721c79e3c5f6693057ae929f3d9c0a03',
  ['mfussenegger/nvim-lint'] = 'eab58b48eb11d7745c11c505e0f3057165902461',
  ['mrcjkb/rustaceanvim'] = 'c9eeb10fc3ca48cc1c75b79b420de67433629ba5',
  ['MunifTanjim/nui.nvim'] = 'de740991c12411b663994b2860f1a4fd0937c130',
  ['neovim/nvim-lspconfig'] = '81878de76c0de4ce289513734ad80c31ec7871b8',
  ['nmac427/guess-indent.nvim'] = '84a4987ff36798c2fc1169cbaff67960aed9776f',
  ['nvim-lua/plenary.nvim'] = '74b06c6c75e4eeb3108ec01852001636d85a932b',
  ['nvim-lualine/lualine.nvim'] = 'a905eeebc4e63fdc48b5135d3bf8aea5618fb21c',
  ['nvim-neo-tree/neo-tree.nvim'] = '4d0828d95adaf4250c1373d2cd9318d3509712b7',
  ['nvim-treesitter/nvim-treesitter'] = '4916d6592ede8c07973490d9322f187e07dfefac',
  ['nvim-treesitter/nvim-treesitter-context'] = 'b0c45cefe2c8f7b55fc46f34e563bc428ef99636',
  ['saghen/blink.cmp'] = '78336bc89ee5365633bcf754d93df01678b5c08f',
  ['stevearc/conform.nvim'] = 'dca1a190aa85f9065979ef35802fb77131911106',
  ['stevearc/oil.nvim'] = '0fcc83805ad11cf714a949c98c605ed717e0b83e',
  ['towolf/vim-helm'] = '2c8525fd98e57472769d137317bca83e477858ce',
  ['tpope/vim-fugitive'] = '3b753cf8c6a4dcde6edee8827d464ba9b8c4a6f0',
  ['tpope/vim-repeat'] = '65846025c15494983dafe5e3b46c8f88ab2e9635',
  ['tpope/vim-speeddating'] = 'c17eb01ebf5aaf766c53bab1f6592710e5ffb796',
  ['vigoux/templar.nvim'] = '58e5bf01e7badedeff0f25d00f8cbbc537934f28',
}

local function pin(plugin)
  local commit = plugin_commits[plugin]
  if not commit then
    error('Missing pinned commit for ' .. plugin)
  end
  return commit
end

local lazycommit = pin('folke/lazy.nvim')

if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end

  out = vim.fn.system({ 'git', '-C', lazypath, 'checkout', lazycommit })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to checkout lazy.nvim commit:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Leader, needs to be before lazy load
vim.g.mapleader = ','

-- Should conform run fixers on save
vim.g.disable_autoformat = false

-- Yes.. I know, not my plugins though
---@diagnostic disable-next-line
-- vim.deprecate = function() end

-- Spaces (these should be adjusted by nmac427/guess-indent.nvim)
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.numberwidth = 4

---@alias Flavor 'latte' | 'frappe' | 'macchiato' | 'mocha'
---@type Flavor
local flavor = 'mocha'

require('lazy').setup({
  {
    'folke/lazy.nvim',
    commit = lazycommit,
  },

  -- Styling
  {
    'catppuccin/nvim',
    commit = pin('catppuccin/nvim'),
    lazy = false,
    priority = 1000,
    opts = {
      flavour = flavor,
      integrations = {
        blink_cmp = true,
        flash = true,
        fzf = true,
        gitsigns = true,
        indent_blankline = {
          colored_indent_levels = false,
          enabled = true,
          scope_color = '',
        },
        lsp_trouble = true,
        lualine = true,
        markdown = true,
        mini = {
          enabled = true,
          indentscope_color = '',
        },
        native_lsp = {
          enabled = true,
          inlay_hints = { background = true },
          underlines = {
            errors = { 'underline' },
            hints = { 'underline' },
            information = { 'underline' },
            ok = { 'underline' },
            warnings = { 'underline' },
          },
          virtual_text = {
            errors = { 'italic' },
            hints = { 'italic' },
            information = { 'italic' },
            ok = { 'italic' },
            warnings = { 'italic' },
          },
        },
        neotree = true,
        symbols_outline = true,
        treesitter = true,
      },
    },
    config = function()
      vim.cmd.colorscheme('catppuccin-' .. flavor)
    end,
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    commit = pin('lukas-reineke/indent-blankline.nvim'),
    main = 'ibl',
    opts = {},
  },

  {
    'brenoprata10/nvim-highlight-colors',
    commit = pin('brenoprata10/nvim-highlight-colors'),
    event = 'BufReadPre',
    opts = {
      render = 'virtual',
      virtual_symbol_position = 'eol',
      virtual_symbol_suffix = '',
      enable_tailwind = true,
    },
  },

  -- Adjust spaces on file
  -- Works more consistently than vim-sleuth I've found
  {
    'nmac427/guess-indent.nvim',
    commit = pin('nmac427/guess-indent.nvim'),
    opts = {},
  },

  -- Mini
  {
    'echasnovski/mini.nvim',
    commit = pin('echasnovski/mini.nvim'),
    config = function()
      -- Comments with gc
      require('mini.comment').setup()

      -- Icons
      require('mini.icons').setup()
    end,
  },

  -- Git
  {
    'tpope/vim-fugitive',
    commit = pin('tpope/vim-fugitive'),
    keys = {
      { '<leader>gd', '<cmd>Gdiff<cr>' },
    },
  },

  {
    'lewis6991/gitsigns.nvim',
    commit = pin('lewis6991/gitsigns.nvim'),
    opts = {},
  },

  -- Finder
  {
    'ibhagwan/fzf-lua',
    commit = pin('ibhagwan/fzf-lua'),
    dependencies = {
      { 'echasnovski/mini.nvim', commit = pin('echasnovski/mini.nvim') },
    },
    keys = {
      { '<C-p>', '<cmd>FzfLua files<cr>' },
      { '<leader>a', '<cmd>FzfLua live_grep<cr>' },
      { '<leader>b', '<cmd>FzfLua buffers<cr>' },
      { '<leader>l', '<cmd>FzfLua<cr>' },
      { '<leader>s', '<cmd>FzfLua lsp_document_symbols<cr>' },
      { 'gd', '<cmd>FzfLua lsp_definitions<cr>' },
      { 'gi', '<cmd>FzfLua lsp_implementations<cr>' },
      { 'gr', '<cmd>FzfLua lsp_references<cr>' },
    },
    opts = {
      { 'border-fused' },
      defaults = {
        file_icons = 'mini',
        formatter = 'path.filename_first',
      },
      winopts = {
        height = '0.95',
        preview = {
          layout = 'vertical',
          vertical = 'down:65%',
        },
      },
    },
  },

  -- Completion
  {
    'saghen/blink.cmp',
    commit = pin('saghen/blink.cmp'),
    dependencies = {},
    build = 'cargo build --release',
    opts = {
      keymap = {
        preset = 'default',
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
      },
      appearance = {
        nerd_font_variant = 'normal',
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = false,
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 250,
          update_delay_ms = 50,
          window = { border = 'rounded' },
        },
        list = {
          selection = {
            auto_insert = false,
            preselect = false,
          },
        },
        menu = {
          border = 'rounded',
          draw = {
            columns = {
              { 'label', 'label_description', gap = 1 },
              { 'kind_icon', 'kind' },
            },
            treesitter = { 'lsp' },
          },
        },
      },
      signature = {
        enabled = true,
        window = { border = 'rounded' },
      },
      sources = {
        default = { 'lazydev', 'lsp', 'path', 'buffer' },
        providers = {
          lazydev = {
            module = 'lazydev.integrations.blink',
            name = 'LazyDev',
            score_offset = 100,
          },
        },
      },
      fuzzy = {
        frecency = { path = vim.fn.stdpath('data') .. '/blink/cmp/fuzzy.db' },
        implementation = 'prefer_rust_with_warning',
      },
    },
    opts_extend = { 'sources.default' },
  },

  {
    'neovim/nvim-lspconfig',
    commit = pin('neovim/nvim-lspconfig'),
    config = function(_, opts)
      for server, config in pairs(opts.servers) do
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local bufnr = args.buf
          if not client then
            return
          end
          if client.name == 'oxlint' then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = bufnr,
              command = 'OxcFixAll',
            })
          end
        end,
        desc = 'LSP: per-client attach handlers (oxlint)',
        group = vim.api.nvim_create_augroup('lsp_attach_auto_lint', { clear = true }),
      })
    end,
    opts = {
      servers = {
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                ignore = { '*' },
              },
              disableOrganizeImports = true,
            },
            python = {
              pythonPath = vim.fn.filereadable(vim.fn.getcwd() .. '/.venv/bin/python')
                  and vim.fn.getcwd() .. '/.venv/bin/python'
                or vim.fn.exepath('python3'),
            },
          },
        },
        bashls = {},
        clangd = {},
        cssls = {
          settings = {
            css = {
              lint = {
                unknownAtRules = 'ignore',
              },
            },
          },
        },
        dhall_lsp_server = {},
        dockerls = {},
        elixirls = {
          cmd = { os.getenv('HOME') .. '/src/elixir-ls/dist/language_server.sh' },
        },
        emmet_ls = {},
        gopls = {},
        glsl_analyzer = {},
        graphql = {},
        groovyls = {
          cmd = {
            'java',
            '-jar',
            os.getenv('HOME') .. '/src/groovy-language-server/build/libs/groovy-language-server-all.jar',
          },
        },
        helm_ls = {},
        html = {},
        jsonls = {},
        lua_ls = {
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
        },
        ocamllsp = {},
        oxlint = {},
        rescriptls = {
          capabilities = {
            workspace = {
              didChangeWatchedFiles = {
                dynamicRegistration = true,
              },
            },
          },
        },
        ruff = {},
        sourcekit = {
          cmd = {
            'sourcekit-lsp',
            '-Xswiftc',
            '-sdk',
            '-Xswiftc',
            vim.fn.trim(vim.fn.system('xcrun --sdk iphoneos --show-sdk-path')),
            '-Xswiftc',
            '-target',
            '-Xswiftc',
            'arm64-apple-ios' .. vim.fn.trim(vim.fn.system('xcrun --sdk iphoneos --show-sdk-version')),
          },
        },
        svelte = {},
        -- terraformls = {},
        tailwindcss = {},
        tinymist = {},
        ts_ls = {},
        vimls = {},
      },
    },
  },

  -- Translate TS Errors to English
  { 'dmmulroy/ts-error-translator.nvim', commit = pin('dmmulroy/ts-error-translator.nvim') },

  -- This seems less problematic than efm-langserver
  -- For formatting on save
  {
    'stevearc/conform.nvim',
    commit = pin('stevearc/conform.nvim'),
    opts = {
      formatters = {
        blank_prettier = {
          command = 'prettier',
        },
        stylua = {
          args = {
            '--search-parent-directories',
            '--respect-ignores',
            '--quote-style',
            'AutoPreferSingle',
            '--indent-type',
            'spaces',
            '--indent-width',
            '2',
            '--stdin-filepath',
            '$FILENAME',
            '-',
          },
        },
      },
      formatters_by_ft = {
        ['markdown.mdx'] = {},
        css = { 'prettier' },
        graphql = { 'prettier' },
        handlebars = { 'prettier' },
        html = { 'prettier' },
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        json = { 'prettier' },
        jsonc = { 'prettier' },
        less = { 'prettier' },
        lua = { 'stylua' },
        markdown = { 'prettier' },
        python = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' },
        scss = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        vue = { 'prettier' },
        yaml = { 'prettier' },
      },
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          print('Format on save disabled')
          return
        end
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:match('/node_modules/') then
          return
        end
        return {
          timeout_ms = 1000,
          lsp_format = 'fallback',
        }
      end,
    },
  },

  -- Linting
  {
    'mfussenegger/nvim-lint',
    commit = pin('mfussenegger/nvim-lint'),
    config = function()
      local lint = require('lint')
      lint.linters_by_ft = {
        javascript = { 'eslint' },
        javascriptreact = { 'eslint' },
        typescript = { 'eslint' },
        typescriptreact = { 'eslint' },
      }
      vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
        callback = function()
          local bufname = vim.api.nvim_buf_get_name(0)
          if not bufname:match('/node_modules/') then
            lint.try_lint(nil, { ignore_errors = true })
          end
        end,
      })
    end,
  },

  -- Treesitter for fancy syntax
  {
    'nvim-treesitter/nvim-treesitter',
    commit = pin('nvim-treesitter/nvim-treesitter'),
    build = ':TSUpdate',
    dependencies = {},
    lazy = false,
    opts = {
      auto_install = true,
      ensure_installed = 'all',
      highlight = {
        enable = true,
        use_languagetree = true,
      },
      ignore_install = {
        'ipkg',
        'latex',
        'mlir',
        'ocamllex',
        'scfg',
        'swift',
        'teal',
        'unison',
      },
      indent = { enable = false },
      modules = {},
      sync_install = false,
    },
  },

  {
    'nvim-treesitter/nvim-treesitter-context',
    commit = pin('nvim-treesitter/nvim-treesitter-context'),
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter', commit = pin('nvim-treesitter/nvim-treesitter') },
    },
    name = 'treesitter-context',
    opts = {
      max_lines = 3,
    },
  },

  -- Embedded treesitter
  {
    'jmbuhr/otter.nvim',
    commit = pin('jmbuhr/otter.nvim'),
    init = function()
      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = 'markdown',
        callback = function()
          require('otter').activate()
        end,
      })
    end,
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter', commit = pin('nvim-treesitter/nvim-treesitter') },
    },
    ft = 'markdown',
    opts = {},
  },

  {
    'hedyhli/outline.nvim',
    commit = pin('hedyhli/outline.nvim'),
    opts = {},
    keys = {
      { '<leader>o', '<cmd>Outline<cr>' },
    },
  },

  -- Typst support
  {
    'kaarmu/typst.vim',
    commit = pin('kaarmu/typst.vim'),
    ft = { 'typst' },
  },

  -- Pug support
  {
    'digitaltoad/vim-pug',
    commit = pin('digitaltoad/vim-pug'),
    ft = { 'pug' },
  },

  -- Helm support
  {
    'towolf/vim-helm',
    commit = pin('towolf/vim-helm'),
    ft = { 'helm' },
  },

  -- Lua
  {
    'folke/lazydev.nvim',
    commit = pin('folke/lazydev.nvim'),
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  -- Rust support
  {
    'mrcjkb/rustaceanvim',
    commit = pin('mrcjkb/rustaceanvim'),
    ft = 'rust',
    lazy = false,
  },

  {
    'julienvincent/hunk.nvim',
    commit = pin('julienvincent/hunk.nvim'),
    cmd = { 'DiffEditor' },
  },

  -- Better repeating
  {
    'tpope/vim-repeat',
    commit = pin('tpope/vim-repeat'),
  },

  -- Better c-a / c-x
  {
    'tpope/vim-speeddating',
    commit = pin('tpope/vim-speeddating'),
  },

  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    commit = pin('nvim-lualine/lualine.nvim'),
    dependencies = {
      { 'catppuccin/nvim', commit = pin('catppuccin/nvim') },
    },
    opts = function(_, opts)
      local colors = require('catppuccin.palettes').get_palette(flavor)

      local function modified()
        if vim.bo.modified then
          return '+'
        elseif vim.bo.modifiable == false or vim.bo.readonly == true then
          return '-'
        end
        return ''
      end

      opts.extensions = {
        'fzf',
        'neo-tree',
        'symbols-outline',
        'trouble',
      }

      opts.options = {
        icons_enabled = false,
        component_separators = '|',
        section_separators = { left = '', right = '' },
        theme = 'catppuccin-' .. flavor,
      }

      opts.sections = {
        lualine_a = { 'mode' },
        lualine_b = {
          {
            modified,
            color = {
              fg = colors.red,
            },
          },
        },
        lualine_c = {
          { 'filename', file_status = false, path = 1 },
          {
            '%r',
            cond = function()
              return vim.bo.readonly
            end,
          },
        },
        lualine_x = {
          'filetype',
          {
            'lsp_status',
            ignore_lsp = {
              'emmet_ls',
              'eslint',
              'oxlint',
            },
          },
        },
        lualine_y = {
          {
            'diagnostics',
            source = { 'nvim' },
            sections = { 'error', 'warn' },
            diagnostics_color = {
              error = {
                bg = colors.red,
                fg = colors.crust,
              },
              warn = {
                bg = colors.peach,
                fg = colors.crust,
              },
            },
            symbols = {
              error = ' ',
              warn = ' ',
            },
          },
        },
      }
    end,
  },

  -- File browser
  {
    'nvim-neo-tree/neo-tree.nvim',
    commit = pin('nvim-neo-tree/neo-tree.nvim'),
    dependencies = {
      { 'MunifTanjim/nui.nvim', commit = pin('MunifTanjim/nui.nvim') },
      { 'echasnovski/mini.nvim', commit = pin('echasnovski/mini.nvim') },
      { 'nvim-lua/plenary.nvim', commit = pin('nvim-lua/plenary.nvim') },
    },
    keys = {
      { '<C-n>', '<cmd>Neotree toggle<cr>' },
    },
    opts = {
      close_if_last_window = true,
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
        },
      },
      default_component_configs = {
        -- Pulled from here to swap out for mini.icons:
        -- https://github.com/nvim-neo-tree/neo-tree.nvim/pull/1527#issuecomment-2233186777
        kind_icon = {
          provider = function(icon, node)
            local mini_icons = require('mini.icons')
            icon.text, icon.highlight = mini_icons.get('lsp', node.extra.kind.name)
          end,
        },
        icon = {
          provider = function(icon, node) -- setup a custom icon provider
            local text, hl
            local mini_icons = require('mini.icons')
            if node.type == 'file' then -- if it's a file, set the text/hl
              text, hl = mini_icons.get('file', node.name)
            elseif node.type == 'directory' then -- get directory icons
              text, hl = mini_icons.get('directory', node.name)
              -- only set the icon text if it is not expanded
              if node:is_expanded() then
                text = nil
              end
            end

            -- set the icon text/highlight only if it exists
            if text then
              icon.text = text
            end
            if hl then
              icon.highlight = hl
            end
          end,
        },
      },
    },
  },

  -- File Creation
  {
    'stevearc/oil.nvim',
    commit = pin('stevearc/oil.nvim'),
    dependencies = {
      { 'echasnovski/mini.nvim', commit = pin('echasnovski/mini.nvim') },
    },
    keys = {
      { '<leader>n', '<cmd>Oil<cr>' },
    },
    lazy = false,
    opts = {},
  },

  -- Diagnostics
  {
    'folke/trouble.nvim',
    commit = pin('folke/trouble.nvim'),
    keys = {
      { '<leader>e', '<cmd>Trouble diagnostics toggle<cr>' },
    },
    opts = {
      focus = true,
    },
  },

  -- Templates
  {
    'vigoux/templar.nvim',
    commit = pin('vigoux/templar.nvim'),
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
    commit = pin('folke/flash.nvim'),
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

vim.cmd('packadd nvim.undotree')

-- Per recommendation on nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3

-- Folding
vim.opt.foldmethod = 'marker'

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
vim.opt.undodir = vim.fn.stdpath('data') .. '/undo'

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

-- Text replacement
vim.opt.conceallevel = 0

-- SQL has a massive slowdown for me
vim.g.omni_sql_no_default_maps = true

-- Sorta like rounded on floating windows
vim.o.winborder = 'rounded'

-- In-line diagnostic messages
local has_virtual_lines = true

local diag_config_vertical = {
  virtual_text = {
    severity = {
      max = vim.diagnostic.severity.WARN,
    },
  },
  virtual_lines = {
    severity = {
      min = vim.diagnostic.severity.ERROR,
    },
  },
}

local diag_config_horizontal = {
  virtual_text = true,
  virtual_lines = false,
}

local toggle_diagnostics = function()
  if has_virtual_lines then
    vim.diagnostic.config(diag_config_vertical)
    has_virtual_lines = false
  else
    vim.diagnostic.config(diag_config_horizontal)
    has_virtual_lines = true
  end
end

-- Default to horizontal lines only
vim.diagnostic.config(diag_config_horizontal)

local yank_file_name = function()
  local relative = vim.fn.expand('%')
  local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  if vim.v.shell_error == 0 and git_root and git_root ~= '' then
    local absolute = vim.fn.fnamemodify(vim.fn.expand('%:p'), ':p'):gsub('/+$', '')
    git_root = vim.fn.fnamemodify(git_root, ':p'):gsub('/+$', '')
    local prefix = git_root .. '/'
    relative = absolute:sub(#prefix + 1)
  end
  vim.fn.setreg('+', relative)
  print('Copied: ' .. relative)
end

local yank_github_url = function()
  local filepath = vim.fn.expand('%:p')
  local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 or not git_root or git_root == '' then
    print('Not inside a Git repository.')
    return
  end

  git_root = vim.fn.fnamemodify(git_root, ':p'):gsub('/+$', '')
  filepath = vim.fn.fnamemodify(filepath, ':p'):gsub('/+$', '')
  local relpath = filepath:sub(#git_root + 2)

  local remote_url = vim.fn.systemlist('git config --get remote.origin.url')[1]
  if not remote_url or remote_url == '' then
    print('No Git remote found.')
    return
  end

  remote_url = remote_url:gsub('^git@([^:]+):', 'https://%1/'):gsub('%.git$', ''):gsub('^git://', 'https://')

  local commit = vim.fn.systemlist('git rev-parse HEAD')[1]
  local line = vim.fn.line('.')

  local url = string.format('%s/blob/%s/%s#L%d', remote_url, commit, relpath, line)

  vim.fn.setreg('+', url)
  print('Copied: ' .. url)
end

vim.filetype.add({
  pattern = {
    ['.*/templates/.*%.tpl'] = 'helm',
    ['.*/templates/.*%.ya?ml'] = 'helm',
    ['helmfile.*%.ya?ml'] = 'helm',
  },
})

local maps_n = {
  [':'] = ';',
  [';'] = ':',
  -- Uppercase Y will grab entire line
  ['Y'] = 'yy',
  -- Natural movement over visual lines
  ['j'] = 'gj',
  ['k'] = 'gk',
  -- Replay macro q with space
  ['<space>'] = '@q',
  ['<leader>D'] = '<cmd>lua vim.lsp.buf.type_definition()<cr>',
  ['<leader>d'] = '<cmd>lua vim.g.disable_autoformat = not vim.g.disable_autoformat<cr>',
  ['<leader>f'] = '<cmd>lua vim.lsp.buf.format { async = true }<cr>',
  ['<leader>rn'] = '<cmd>lua vim.lsp.buf.rename()<cr>',
  ['<leader>u'] = '<cmd>Undotree<cr>',
}

local maps = {
  i = {
    ['<C-c>'] = '<Esc>',
  },
  n = maps_n,
  v = {
    ['<leader>s'] = ":'<,'>sort<cr>",
  },
}

local keymap_opts = { noremap = true }

vim.keymap.set('n', '<leader>v', toggle_diagnostics, keymap_opts)
vim.keymap.set('n', '<leader>yf', yank_file_name, keymap_opts)
vim.keymap.set('n', '<leader>yg', yank_github_url, keymap_opts)

for mode, mappings in pairs(maps) do
  for keys, mapping in pairs(mappings) do
    vim.api.nvim_set_keymap(mode, keys, mapping, keymap_opts)
  end
end

-- vim: shiftwidth=2:
