### Dotfiles

#### Neovim

Neovim > 0.7

For LSP support run the following:

```bash
pnpm add -g \
  bash-language-server@latest \
  dockerfile-language-server-nodejs@latest \
  graphql-language-service-cli@latest \
  nxls@latest \
  pyright@latest \
  svelte-language-server@latest \
  typescript-language-server@latest \
  typescript@latest \
  vim-language-server@latest \
  vscode-langservers-extracted@latest \
  yaml-language-server@latest

brew install dhall-lsp-server
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
cd ./terminfo/
# General italic support in iTerm2
tic -x xterm-256color-italic.terminfo
tic -x tmux-256color.terminfo
```

#### Terminfo (for kitty)

```bash
# General support for Kitty
tic -x kitty.terminfo
```
