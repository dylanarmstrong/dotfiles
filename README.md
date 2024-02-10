### Dotfiles

#### Neovim

Neovim > 0.9

For LSP support run the following:

```bash
npm install -g pnpm

pnpm add -g \
    @tailwindcss/language-server \
    bash-language-server \
    dockerfile-language-server-nodejs \
    graphql-language-service-cli \
    nxls \
    pyright \
    svelte-language-server \
    typescript \
    typescript-language-server \
    vim-language-server \
    vscode-langservers-extracted \
    yaml-language-server

brew install \
    dhall-lsp-server \
    efm-langserver
    elixir \
    lua-language-server

# Groovy Support
pushd $HOME/src && \
    git clone https://github.com/GroovyLanguageServer/groovy-language-server || true && \
    pushd groovy-language-server && \
    ./gradlew build && \
    popd && \
    popd

# Elixir Support
pushd $HOME/src && \
    git clone https://github.com/elixir-lsp/elixir-ls || true && \
    pushd elixir-ls && \
    mix deps.get && \
    MIX_ENV=prod mix compile && \
    MIX_ENV=prod mix elixir_ls.release2 -o ./dist && \
    popd && \
    popd
```

The following must be manually installed with path adjusted accordingly in `.config/nvim/init.lua`:

- [elixir-ls](https://github.com/elixir-lsp/elixir-ls)

#### Kitty (Generate Theme)

```bash
kitty +kitten themes --reload-in=all Catppuccin-Mocha
```

#### Terminfo (for italics)

1. Install Terminfo files with commands below
2. Set iTerm to use xterm-256color-italic.
3. Alias ssh to pass in a valid term that the remote machine will understand

```bash
# General italic support in iTerm2
tic -x ./terminfo/xterm-256color-italic.terminfo
tic -x ./terminfo/tmux-256color.terminfo
```

#### Terminfo (for kitty)

```bash
# General support for Kitty
tic -x /Applications/kitty.app/Contents/Resources/kitty/terminfo/kitty.terminfo
```
