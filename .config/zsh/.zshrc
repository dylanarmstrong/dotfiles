# zmodload zsh/zprof

# Need system for osx vs gentoo
platform='unknown'
uname=`uname`
if [[ "$uname" == 'Linux' ]]; then
  platform='linux'
else
  platform='osx'
fi

# Exports
export LANG=en_US.UTF-8

export EDITOR=nvim
export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
export LC_ALL=$LANG
export LC_COLLATE=C
export LC_CTYPE=C
export THEOS=$HOME/src/theos
export THEOS_DEVICE_IP=localhost
export THEOS_DEVICE_PORT=2222

# XDG
export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export XDG_RUNTIME_DIR=$HOME/.local/run

# xdg-ninja
HISTFILE="$XDG_CONFIG_HOME/zsh/history"

alias mitmproxy="mitmproxy --set confdir=$XDG_CONFIG_HOME/mitmproxy"
alias mitmweb="mitmweb --set confdir=$XDG_CONFIG_HOME/mitmproxy"
alias wget="wget --hsts-file=""$XDG_DATA_HOME/wget-hsts"""

defaults write org.hammerspoon.Hammerspoon MJConfigFile "$XDG_CONFIG_HOME"/hammerspoon/init.lua

export ANSIBLE_HOME="$XDG_CONFIG_HOME/ansible"
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME"/aws/config
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME"/aws/credentials
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export GEM_HOME="${XDG_DATA_HOME}"/gem
export GEM_SPEC_CACHE="${XDG_CACHE_HOME}"/gem
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export LESSHISTFILE="$XDG_STATE_HOME"/less/history
export MACHINE_STORAGE_PATH="$XDG_DATA_HOME"/docker-machine
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc
export NVM_DIR="$XDG_DATA_HOME"/nvm
export OPAMROOT="$XDG_DATA_HOME/opam"
export PSQL_HISTORY="$XDG_DATA_HOME/psql_history"
export PYTHONSTARTUP="/etc/python/pythonrc"
export RANDFILE="$XDG_DATA_HOME/rnd"
export SQLITE_HISTORY="$XDG_CACHE_HOME"/sqlite_history
export TERMINFO="$XDG_DATA_HOME"/terminfo
export TERMINFO_DIRS="$XDG_DATA_HOME"/terminfo:/usr/share/terminfo
export XAUTHORITY="$XDG_RUNTIME_DIR"/Xauthority
export _Z_DATA="$XDG_DATA_HOME/z"

# Private environment variables
[ -r $HOME/.env ] && . $HOME/.env
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ENV_HINTS=1
export APOLLO_TELEMETRY_DISABLED=1

# MacOS Sierra Tmux Fix
export EVENT_NOKQUEUE=1

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
if [[ $platform == 'osx' ]]; then
  bindkey "\e[B" history-beginning-search-forward
  bindkey "\e[A" history-beginning-search-backward
else
  bindkey "${terminfo[kcud1]}" history-beginning-search-forward
  bindkey "${terminfo[kcuu1]}" history-beginning-search-backward
fi
bindkey "^L" forward-word
bindkey "^H" backward-word
bindkey " " magic-space

# Style
autoload -U colors
colors

# Completion
autoload -U compinit
compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"

zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' file-sort name
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '' '+m:{a-z}={A-Z}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' use-cache 1
zstyle ':completion:*' cache-path $HOME/.zsh/cache
zstyle ':completion:::::' completer _complete _approximate
zstyle ':completion:*:approximate:*' max-errors 2
zstyle ':completion:*' completer _complete _prefix
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:predict:*' completer _complete
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $HOME/.zsh/cache/$HOST
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"
zstyle ':completion:*' menu select
zstyle ":completion:*" list-colors ""
zstyle ':completion:*:ssh:*' hosts off
zstyle ':completion:*:scp:*' hosts off
zstyle ':completion:*:rsync:*' hosts off

# Aliases
alias 7zx='7z x'
alias bc='bc -l'
alias c='clear'
alias cp='nocorrect cp -v'
alias e='exit'
alias gc='git checkout'
alias gd='git diff'
alias grep='grep --color=auto'
alias jqp="jq '.' package.json"
alias l='ls -GF'
alias ls='ls -GF'
alias lsh='ls -Fth . | head -n 25'
alias mkdir='nocorrect mkdir -v'
alias mv='nocorrect mv -v'
alias rm='nocorrect rm -v'
alias scripts="jq '.scripts' package.json"
alias ssh='TERM=xterm-256color ssh'
alias tam='tmux -u -2 attach'
alias tmux='tmux -u -2'
alias view='nvim -R'
alias vim='nvim'

# Prompt
setopt prompt_subst
autoload -Uz add-zsh-hook vcs_info

zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' formats '%F{2}%b%u%f '
zstyle ':vcs_info:*' unstagedstr '%F{1}*'

function prompt_precmd() { vcs_info }
function set_prompt {
  if [[ $platform == 'osx' ]]; then
    PROMPT="%F{39}%1~ ${vcs_info_msg_0_}%F{1}>%f "
  else
    PROMPT="%F{5}[%F{1}%n%F{5}@%F{1}%m%F{5}] %F{39}%1~ ${vcs_info_msg_0_}%F{1}>%f "
  fi
}
add-zsh-hook precmd prompt_precmd
add-zsh-hook precmd set_prompt

# FZF
if [ -e /usr/local/opt/fzf/shell/completion.zsh ]; then
  source /usr/local/opt/fzf/shell/key-bindings.zsh
  source /usr/local/opt/fzf/shell/completion.zsh
fi

export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"

# Z (https://github.com/rupa/z)
[ -e /usr/local/etc/profile.d/z.sh ] && . /usr/local/etc/profile.d/z.sh
[ -e $HOME/bin/z.sh ] && . $HOME/bin/z.sh

[ -s "$HOME/src/zsh-better-npm-completion" ] && source $HOME/src/zsh-better-npm-completion/zsh-better-npm-completion.plugin.zsh

# Lazy loaded Nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use # This loads nvm

export MAGICK_HOME=/usr/local/opt/imagemagick@6

# https://github.com/keybase/keybase-issues/issues/2798
export GPG_TTY=$(tty)

# pnpm
export PNPM_HOME="/Users/dylan/Library/pnpm"
# pnpm end

# Reset PATH
export PATH=/sbin:/usr/sbin:/usr/local/sbin:$JAVA_HOME/bin:$HOME/bin:/usr/local/opt/imagemagick@6/bin:/usr/local/opt/python@3.8/bin:/usr/local/opt/java/bin:$PNPM_HOME:$XDG_DATA_HOME/npm/bin:$NVM_DIR/versions/node/v16.19.1/bin:/usr/local/bin:/bin:/usr/bin:$HOME/.local/bin:/Applications/Wireshark.app/Contents/MacOS/:$HOME/.gem/ruby/2.6.0/bin

# Used for work specific stuff that runs after everything else
[ -r $HOME/.post_env ] && . $HOME/.post_env

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# zprof
