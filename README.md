### Dotfiles

#### Neovim

Neovim > 0.11

For LSP support run the following:

```bash
npm install -g pnpm

pnpm add -g \
    @rescript/language-server \
    @tailwindcss/language-server \
    bash-language-server \
    dockerfile-language-server-nodejs \
    emmet-ls \
    graphql-language-service-cli \
    oxlint \
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
    git-delta \
    hashicorp/tap/terraform-ls \
    helm-ls \
    ltex-ls \
    lua-language-server \
    shellcheck \
    zoxide

opam install ocaml-lsp-server
```

Lazy manages the pinned plugins and writes its lockfile under Neovim's state
directory. Plugin downloads, Blink builds, and Tree-sitter parsers remain
writable runtime data; Nix generation rollback does not restore them.

#### Git

Deploy the pinned Delta theme as
`$XDG_CONFIG_HOME/git/catppuccin.gitconfig`, beside `git/config`.

#### tmux

With Home Manager, supply the `sensible` and `yank` plugins and incorporate
`.config/tmux/tmux.conf` as `programs.tmux.extraConfig`. Do not also deploy that
file directly to the generated tmux configuration's target.

#### Kitty (Generate Theme)

```bash
kitty +kitten themes --reload-in=all Catppuccin-Mocha
```

#### Hammerspoon

Deploy the configuration files and tracked `SpoonInstall.spoon` individually;
keep sibling Spoons writable for runtime installation. SpoonInstall's current
update source is `master`, and downloaded Spoons are not restored by Nix rollback.

Configure the XDG-based Hammerspoon entrypoint once on macOS:

```bash
defaults write org.hammerspoon.Hammerspoon MJConfigFile "$HOME/.config/hammerspoon/init.lua"
```

#### Terminfo (for kitty on macOS)

```bash
tic -x -o "$HOME/.local/share/terminfo" /Applications/kitty.app/Contents/Resources/kitty/terminfo/kitty.terminfo
```

Install the same terminal definition on a remote host before connecting with
`TERM=xterm-kitty`:

```bash
infocmp -x xterm-kitty | ssh gentoo 'tic -x -o "$HOME/.terminfo" /dev/stdin'
```

#### Rustup (for blink.cmp in Neovim)

```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
