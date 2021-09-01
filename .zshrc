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
export XDG_CONFIG_HOME=$HOME/.config

# Private environment variables
[ -r $HOME/.env ] && . $HOME/.env
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1

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
HISTFILE=$HOME/.zsh_history
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
fpath=($HOME/.zsh/site-functions $fpath)
autoload -U compinit
compinit

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

# Base16
BASE16_SHELL=$HOME/src/base16/base16-shell/
[ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

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

BASE16_FZF=$HOME/src/base16/base16-fzf
[ -e BASE16_FZF ] && source $BASE16_FZF/bash/base16-summerfruit-dark.config

[ -s "$HOME/src/zsh-better-npm-completion" ] && source $HOME/src/zsh-better-npm-completion/zsh-better-npm-completion.plugin.zsh

# Nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

export MAGICK_HOME=/usr/local/opt/imagemagick@6

# https://github.com/keybase/keybase-issues/issues/2798
export GPG_TTY=$(tty)

# Reset PATH
export PATH=/sbin:/usr/sbin:/usr/local/sbin:$JAVA_HOME/bin:$HOME/bin:$NVM_BIN:/usr/local/opt/imagemagick@6/bin:/usr/local/opt/python@3.8/bin:/usr/local/opt/java/bin:/usr/local/bin:/bin:/usr/bin:$HOME/.local/bin:/Applications/Wireshark.app/Contents/MacOS/:$HOME/.gem/ruby/2.6.0/bin:$HOME/.cargo/bin

# Used for work specific stuff that runs after everything else
[ -r $HOME/.post_env ] && . $HOME/.post_env
