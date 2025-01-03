### Dotfiles

#### Neovim

Neovim > 0.10

For LSP support run the following:

```bash
npm install -g pnpm

pnpm add -g \
    @tailwindcss/language-server \
    bash-language-server \
    dockerfile-language-server-nodejs \
    emmet-ls \
    graphql-language-service-cli \
    pyright \
    svelte-language-server \
    typescript \
    typescript-language-server \
    vim-language-server \
    vscode-langservers-extracted \
    yaml-language-server

brew install \
    bat \
    dhall-lsp-server \
    difftastic \
    efm-langserver \
    elixir \
    git-delta \
    hashicorp/tap/terraform-ls \
    ltex-ls \
    lua-language-server \
    shellcheck

# Groovy Support
pushd $HOME/src && \
    git clone https://github.com/GroovyLanguageServer/groovy-language-server || true && \
    pushd groovy-language-server && \
    git pull && \
    ./gradlew build && \
    popd && \
    popd

# Elixir Support
pushd $HOME/src && \
    git clone https://github.com/elixir-lsp/elixir-ls || true && \
    pushd elixir-ls && \
    git pull && \
    mix deps.get && \
    MIX_ENV=prod mix compile && \
    MIX_ENV=prod mix elixir_ls.release2 -o ./dist && \
    popd && \
    popd
```

The following must have the path adjusted accordingly in `.config/nvim/init.lua`:

- [elixir-ls](https://github.com/elixir-lsp/elixir-ls)

```lua
  nvim_lsp.elixirls.setup {
    capabilities = capabilities,
    -- If you have a different `src` setup, adjust here:
    cmd = { os.getenv('HOME') .. '/src/elixir-ls/dist/language_server.sh' }
  }
```

#### Kitty (Generate Theme)

```bash
kitty +kitten themes --reload-in=all Catppuccin-Mocha
```

#### Terminfo (for kitty on macOS)

```bash
tic -x /Applications/kitty.app/Contents/Resources/kitty/terminfo/kitty.terminfo
```
