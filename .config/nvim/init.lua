local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
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

vim.g.cmptoggle = true
vim.g.disable_autoformat = false

-- Yes.. I know, not my plugins though
---@diagnostic disable-next-line
vim.deprecate = function() end

-- Spaces (these should be adjusted by nmac427/guess-indent.nvim)
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.numberwidth = 4

require('lazy').setup({
  -- Styling
  {
    'catppuccin/nvim',
    lazy = false,
    priority = 1000,
    opts = {
      flavour = 'mocha',
      integrations = {
        blink_cmp = true,
        flash = true,
        gitsigns = true,
        indent_blankline = {
          colored_indent_levels = false,
          enabled = true,
          scope_color = '',
        },
        lsp_trouble = true,
        lualine = true,
        markdown = true,
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
        noice = true,
        symbols_outline = true,
        telescope = true,
        treesitter = true,
      },
    },
    config = function()
      vim.cmd([[ colorscheme catppuccin ]])
    end,
  },

  -- Fancy UI
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      cmdline = {
        view = 'cmdline',
      },
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    },
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
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

  -- Adjust spaces on file
  -- Works more consistently than vim-sleuth I've found
  {
    'nmac427/guess-indent.nvim',
    cond = not vim.g.vscode,
    opts = {},
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

  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  {
    'saghen/blink.cmp',
    dependencies = {
      'rafamadriz/friendly-snippets',
    },
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
        accept = { auto_brackets = { enabled = true } },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 250,
          update_delay_ms = 50,
          window = { border = 'rounded' },
        },
        list = {
          selection = {
            preselect = false,
            auto_insert = false,
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
        default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
          lazydev = {
            module = 'lazydev.integrations.blink',
            name = 'LazyDev',
            score_offset = 100,
          },
        },
      },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    opts_extend = { 'sources.default' },
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'saghen/blink.cmp',
    },
    opts = {
      servers = {
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
        -- eslint = {},
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
        ltex = {
          settings = {
            ltex = {
              language = 'en-US',
            },
          },
        },
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
        ocamlls = {},
        -- oxlint = {},
        pyright = {
          settings = {
            pyright = {
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'workspace',
              },
              pythonPath = vim.fn.filereadable(vim.fn.getcwd() .. '/.venv/bin/python')
                  and vim.fn.getcwd() .. '/.venv/bin/python'
                or vim.fn.exepath('python3'),
            },
          },
        },
        ruff = {},
        sourcekit = {},
        svelte = {},
        terraformls = {},
        tailwindcss = {},
        tinymist = {},
        ts_ls = {},
        vimls = {},
      },
    },
    config = function(_, opts)
      local lspconfig = require('lspconfig')
      for server, config in pairs(opts.servers) do
        config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end

      local capabilities = require('blink.cmp').get_lsp_capabilities()

      lspconfig.eslint.setup({
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
      })

      lspconfig.oxlint.setup({
        capabilities = capabilities,
        on_attach = function(_, bufnr)
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = bufnr,
            command = 'OxcFixAll',
          })
        end,
      })
    end,
  },

  -- This seems less problematic than efm-langserver
  -- For formatting on save
  {
    'stevearc/conform.nvim',
    cond = not vim.g.vscode,
    opts = {
      formatters = {
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
        ['markdown.mdx'] = { 'prettier' },
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

  {
    'mrcjkb/rustaceanvim',
    version = '^5',
    lazy = false,
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
  },

  -- Typst support
  {
    'kaarmu/typst.vim',
    ft = { 'typst' },
  },

  -- Pug support
  {
    'digitaltoad/vim-pug',
    ft = { 'pug' },
  },

  -- Helm support
  {
    'towolf/vim-helm',
    ft = { 'helm' },
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
        lualine_c = {
          { 'filename', path = 1 },
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

-- Sorta like rounded on floating windows
vim.o.winborder = 'rounded'

-- In-line diagnostic messages
local has_virtual_lines = false

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

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end
    if client.name == 'ruff' then
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end
  end,
  desc = 'LSP: Disable hover capability from Ruff',
})

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
  ['<leader>y'] = '<cmd>lua vim.g.disable_autoformat = not vim.g.disable_autoformat<cr>',
  ['<leader>z'] = '<cmd>lua vim.g.cmptoggle = not vim.g.cmptoggle<cr>',
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
    ['<leader>s'] = ":'<,'>sort<cr>",
  },
  [''] = {
    ['<space>'] = '@q',
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
