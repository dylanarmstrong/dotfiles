### Dotfiles

#### Neovim

Neovim > 0.7

For LSP support run the following:

```bash
pnpm add -g \
  bash-language-server \
  dockerfile-language-server-nodejs \
  graphql-language-service-cli \
  nxls \
  pyright \
  svelte-language-server \
  typescript-language-server \
  typescript \
  vim-language-server \
  vscode-langservers-extracted \
  yaml-language-server

brew install dhall-lsp-server lua-language-server
```

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
