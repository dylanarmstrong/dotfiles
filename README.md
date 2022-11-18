### Dotfiles

```
git submodule update --init --recursive
```

#### Neovim requires the following:

Neovim > 0.7

For LSP support run the following:

```bash
npm i -g \
  bash-language-server \
  dockerfile-language-server-nodejs \
  ocaml-language-server \
  pyright \
  svelte-language-server \
  typescript \
  typescript-language-server \
  vim-language-server \
  vscode-langservers-extracted
```

#### Terminfo (for italics)

1. Install Terminfo files with commands below
2. Set iTerm to use xterm-256color-italic.
3. Alias ssh to pass in a valid term that the remote machine will understand

```bash
tic -x xterm-256color-italic.terminfo
tic -x tmux-256color.terminfo
```
