#! /usr/bin/env bash
# shellcheck disable=SC2034,SC1091
# zmodload zsh/zprof

# XDG
export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export XDG_RUNTIME_DIR=$HOME/.local/run

# For the PATH
NODE_VERSION=v22.15.0

# For arm64 / i386
BREW_ROOT="/usr/local"
if [[ $(arch) == 'arm64' ]]; then
  BREW_ROOT="/opt/homebrew"
fi

# Exports
export EDITOR=nvim
export JAVA_HOME=$BREW_ROOT/opt/openjdk@17/
export LANG=en_US.UTF-8
export LC_ALL=$LANG
export LC_COLLATE=C
export LC_CTYPE=C
export THEOS=$HOME/src/theos
export THEOS_DEVICE_IP=localhost
export THEOS_DEVICE_PORT=2222

# xdg-ninja
HISTFILE="$XDG_CONFIG_HOME/zsh/history"

defaults write org.hammerspoon.Hammerspoon MJConfigFile "$XDG_CONFIG_HOME"/hammerspoon/init.lua

export ANSIBLE_HOME="$XDG_CONFIG_HOME/ansible"
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME"/aws/config
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME"/aws/credentials
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME"/bundle
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME"/bundle
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME"/bundle
export GEM_HOME="${XDG_DATA_HOME}"/gem
export GEM_SPEC_CACHE="${XDG_CACHE_HOME}"/gem
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export LESSHISTFILE="$XDG_STATE_HOME"/less/history
export MACHINE_STORAGE_PATH="$XDG_DATA_HOME"/docker-machine
export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc
export OPAMROOT="$XDG_DATA_HOME/opam"
export NVM_DIR="$BREW_ROOT/opt/nvm"
export PSQL_HISTORY="$XDG_DATA_HOME/psql_history"
export PYTHONSTARTUP="/etc/python/pythonrc"
export RANDFILE="$XDG_DATA_HOME/rnd"
export SQLITE_HISTORY="$XDG_CACHE_HOME"/sqlite_history
export TERMINFO="$XDG_DATA_HOME"/terminfo
export TERMINFO_DIRS="$XDG_DATA_HOME"/terminfo:/usr/share/terminfo
export XAUTHORITY="$XDG_RUNTIME_DIR"/Xauthority
export _Z_DATA="$XDG_DATA_HOME/z"

# Private environment variables
[ -r "$HOME"/.env ] && . "$HOME"/.env

# Telemetry
export APOLLO_TELEMETRY_DISABLED=1
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ENV_HINTS=1
export SHOPIFY_CLI_NO_ANALYTICS=1

# FZF
# Catppuccin Mocha
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi"
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"

# https://github.com/keybase/keybase-issues/issues/2798
# shellcheck disable=SC2155
export GPG_TTY=$(tty)

export PNPM_HOME="$HOME/Library/pnpm"

# Options
setopt always_to_end
setopt autocd
setopt complete_in_word
setopt correct
setopt extended_glob
setopt hash_cmds
setopt hash_dirs
setopt interactive_comments
setopt mark_dirs
setopt numeric_glob_sort
setopt sh_word_split

# History
HISTORY_IGNORE='(note [^-]*)'
HISTSIZE=1000000
SAVEHIST=1000000
setopt extended_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_verify
setopt share_history

# Keys
bindkey -e
bindkey "\e[B" history-beginning-search-forward
bindkey "\e[A" history-beginning-search-backward
bindkey "^L" forward-word
bindkey "^H" backward-word
bindkey " " magic-space

# Style
autoload -U colors
colors

# Completion
autoload -Uz compinit
compinit

zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' file-sort name
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '' '+m:{a-z}={A-Z}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' use-cache 1
zstyle ':completion:*' cache-path "$HOME"/.zsh/cache
zstyle ':completion:::::' completer _complete _approximate
zstyle ':completion:*:approximate:*' max-errors 2
zstyle ':completion:*' completer _complete _prefix
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:predict:*' completer _complete
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path "$HOME"/.zsh/cache/"$HOST"
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command 'ps -u $(whoami) -o pid,user,comm -w -w'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:ssh:*' hosts off
zstyle ':completion:*:scp:*' hosts off
zstyle ':completion:*:rsync:*' hosts off

# Aliases
alias 7zx='7z x'
alias bc='bc -l'
alias c='clear'
alias cd='z'
alias cp='nocorrect cp -v'
alias e='exit'
alias gc='git checkout'
alias gd='git diff'
alias grep='grep --color=auto'
alias jqp='jq '.' package.json'
alias l='ls --color=always -F'
alias ls='ls --color=always -F'
alias lsh='ls -Fth . | head -n 25'
alias mitmproxy='mitmproxy --set confdir=$XDG_CONFIG_HOME/mitmproxy'
alias mitmweb='mitmweb --set confdir=$XDG_CONFIG_HOME/mitmproxy'
alias mkdir='nocorrect mkdir -v'
alias mv='nocorrect mv -v'
alias rm='nocorrect rm -v'
alias scripts='jq '.scripts' package.json'
alias ssh='TERM=xterm-256color ssh'
alias view='nvim -R'
alias vim='nvim'
alias wget='wget --hsts-file=$XDG_DATA_HOME/wget-hsts'

# Prompt
setopt prompt_subst
autoload -Uz add-zsh-hook vcs_info

zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' formats '%F{2}%b%u%f '
zstyle ':vcs_info:*' unstagedstr '%F{1}*'

function prompt_precmd() {
  vcs_info
}
function set_prompt {
  # shellcheck disable=SC2154
  PROMPT="%F{39}%1~ ${vcs_info_msg_0_}%F{1}>%f "
}
add-zsh-hook precmd prompt_precmd
add-zsh-hook precmd set_prompt

# Lazy loaded Nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use

# Reset PATH
export PATH=/sbin:/usr/sbin:/usr/local/sbin:$JAVA_HOME/bin:$HOME/bin:$HOME/.local/bin:/usr/local/bin:$BREW_ROOT/bin:$PNPM_HOME:$NVM_DIR/versions/node/$NODE_VERSION/bin:$XDG_DATA_HOME/npm/bin:$HOME/.docker/bin:/Applications/kitty.app/Contents/MacOS/:/bin:/usr/bin:$HOME/.cargo/bin:$HOME/.docker/bin

[ -s "$BREW_ROOT/bin/fzf" ] && eval "$($BREW_ROOT/bin/fzf --zsh)"
eval "$(zoxide init zsh)"
. "$HOME/.cargo/env"

eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"

function fv() {
  local file
  file="$(fzf --height 80% --reverse --preview 'bat --style=numbers --color=always {} 2>/dev/null || cat {}')"
  if [ -n "$file" ]; then
    nvim "$file"
  fi
}

function fz() {
  local file
  file="$(fzf --height 80% --reverse --preview 'bat --style=numbers --color=always {} 2>/dev/null || cat {}')"
  if [ -n "$file" ]; then
    local dir
    dir="$(dirname "$file")"
    zoxide add "$dir"  # Add the directory to zoxide's database
    cd "$dir"
  fi
}

# Used for work specific stuff that runs after everything else
[ -r "$HOME"/.post_env ] && . "$HOME"/.post_env

# zprof
