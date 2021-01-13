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
export LC_ALL=$LANG
export LC_COLLATE=C
export LC_CTYPE=C
export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-14.jdk/Contents/Home
export EDITOR=nvim
export XDG_CONFIG_HOME=$HOME/.config
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export THEOS=$HOME/src/theos
export THEOS_DEVICE_IP=localhost
export THEOS_DEVICE_PORT=2222

# Private environment variables
[ -r $HOME/.env ] && . $HOME/.env
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1

# MacOS Sierra Tmux Fix
export EVENT_NOKQUEUE=1

# Options
setopt autocd
setopt sh_word_split
setopt extended_glob
setopt complete_in_word
setopt always_to_end
setopt interactive_comments
setopt correct
setopt hash_cmds
setopt hash_dirs
setopt numeric_glob_sort
setopt mark_dirs

# History
HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt share_history
setopt extended_history
setopt hist_verify

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
alias mv='nocorrect mv -v'
alias cp='nocorrect cp -v'
alias rm='nocorrect rm -v'
alias mkdir='nocorrect mkdir -v'
alias bc='bc -l'
alias 7zx='7z x'
alias e='exit'
alias c='clear'
alias grep='grep --color=auto'
alias gd='git diff'
alias gc='git checkout'
alias tmux='tmux -u -2'
alias tam='tmux -u -2 attach'
alias lsh='ls -Fth . | head -n 25'
#alias mitmproxy='mitmproxy -p 8080 --mode socks5 --set console_mouse=false --set console_palette=light --anticomp --anticache'
alias vim='nvim'
alias jqp="jq '.' package.json"
alias scripts="jq '.scripts' package.json"
alias view='nvim -R'
alias execs="echo \"$PATH\" | gsed 's/:/\n/g' | xargs -I {} gfind '{}' -type f -executable | fzf --multi --preview 'cat {}'"

if [[ $platform == 'linux' ]]; then
  alias ls='ls -F --color=auto'
  alias l='ls -F --color=auto'
  alias emerge='nocorrect emerge'
  alias eix-sync='eix-sync -H'
  alias es='emerge --search'
  alias eav='sudo emerge --ask --verbose'
  alias ev='sudo emerge --verbose'
  alias epv='emerge --pretend --verbose'
  alias alsamixer="alsamixer -c 1"
  alias spotify='spotify --force-device-scale-factor=1.7'
  alias virtualbox='for m in vbox{drv,netadp,netflt}; do sudo modprobe $m; done && VirtualBox'
  alias dwarftherapist="QT_AUTO_SCREEN_SCALE_FACTOR=1 dwarftherapist"
else
  alias ls='ls -GF'
  alias l='ls -GF'
fi

# Useful color function
function spectrum_ls() {
  for code in {000..255}; do
    print -P -- "$code: %F{$code}Test%f"
  done
}

# Read markdown files
function rmd() {
  pandoc $1 | lynx -stdin
}

# Prompt
setopt prompt_subst
autoload -Uz add-zsh-hook vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
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

export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"

BASE16_FZF=$HOME/src/base16/base16-fzf
[ -e BASE16_FZF ] && source $BASE16_FZF/bash/base16-summerfruit-dark.config

# Opam configuration
test -r $HOME/.opam/opam-init/init.zsh && . $HOME/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

[ -s "$HOME/src/zsh-better-npm-completion" ] && source $HOME/src/zsh-better-npm-completion/zsh-better-npm-completion.plugin.zsh

# Nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

export MAGICK_HOME=/usr/local/opt/imagemagick@6

# Reset PATH
export PATH=/sbin:/usr/sbin:/usr/local/sbin:$HOME/bin:$NVM_BIN:/usr/local/opt/imagemagick@6/bin:/usr/local/opt/python@3.8/bin:/usr/local/opt/java/bin:/usr/local/bin:/bin:/usr/bin:$HOME/.local/bin:

# Used for work specific stuff that runs after everything else
[ -r $HOME/.post_env ] && . $HOME/.post_env
