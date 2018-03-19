# the zshrc file

# need system for osx vs gentoo
platform='unknown'
uname=`uname`
if [[ "$uname" == 'Linux' ]]; then
  platform='linux'
else
  platform='osx'
fi

# important shiznit
export LANG=en_US.UTF-8
export LC_ALL=$LANG
export LC_COLLATE=C
export LC_CTYPE=C

# options
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

# history
HISTFILE=$HOME/.zsh_history
HISTSIZE=250000
SAVEHIST=200000
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt share_history
setopt extended_history
setopt hist_verify

# environment
export EDITOR=vim
export PATH=/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin:$HOME/.cabal/bin:$HOME/.cargo/bin:/usr/local/games:$HOME/bin:$HOME/.local/bin:$HOME/Library/Python/2.7/bin:$PATH
export XDG_CONFIG_HOME=$HOME/.config
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export THEOS=$HOME/src/theos
export THEOS_DEVICE_IP=192.168.1.46

# Private environment variables
if [[ $platform == 'osx' ]]; then
  [ -r $HOME/.env ] && . $HOME/.env
  export HOMEBREW_GITHUB_API_TOKEN=$HOMEBREW_GITHUB_API_TOKEN
  export HOMEBREW_NO_ANALYTICS=1

  # macos sierra tmux fix
  export EVENT_NOKQUEUE=1
fi

# keys
bindkey -e
bindkey "\e[B" history-beginning-search-forward
bindkey "\e[A" history-beginning-search-backward
bindkey "^L" forward-word
bindkey "^H" backward-word
bindkey " " magic-space

#style
autoload -U colors
colors

# completion
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

# aliases
alias mv='nocorrect mv -v'
alias cp='nocorrect cp -v'
alias rm='nocorrect rm -v'
alias mkdir='nocorrect mkdir -v'
alias bc='bc -l'
alias e='exit'
alias c='clear'
alias grep='grep --color=auto'
alias gd='git diff'
alias gc='git checkout'
alias check-movies="rsstool -u 'rsstool/1.0.1rc2 (cmdline tool for rss)' --shtml --slf --template2=$HOME/documents/rss/ptp-template -i=$HOME/documents/rss/all-rss | sed -e 's/IMDb//g'"
alias tmux='tmux -u -2'
alias tam='tmux -u -2 attach'

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

#alias mitmproxy="mitmproxy -p 8080 --socks --palette light --no-mouse -z --anticache"

# useful color function
function spectrum_ls() {
  for code in {000..255}; do
    print -P -- "$code: %F{$code}Test%f"
  done
}

function rmd() {
  pandoc $1 | lynx -stdin
}

# prompt
setopt prompt_subst
autoload -Uz add-zsh-hook vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' formats '%F{2}%b%u%f '
zstyle ':vcs_info:*' unstagedstr '%F{1}*'

function prompt_precmd() { vcs_info }
function set_prompt { PROMPT="%F{39}%1~ ${vcs_info_msg_0_}%F{1}>%f " }
add-zsh-hook precmd prompt_precmd
add-zsh-hook precmd set_prompt

# ntfs colors
#eval $(dircolors -b $HOME/.dir_colors)

# base16
BASE16_SHELL=$HOME/src/base16/base16-shell/
[ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

###-begin-npm-completion-###
#
# npm command completion script
#
# Installation: npm completion >> ~/.bashrc  (or ~/.zshrc)
# Or, maybe: npm completion > /usr/local/etc/bash_completion.d/npm
#

COMP_WORDBREAKS=${COMP_WORDBREAKS/=/}
COMP_WORDBREAKS=${COMP_WORDBREAKS/@/}
export COMP_WORDBREAKS

if type complete &>/dev/null; then
  _npm_completion () {
    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$COMP_CWORD" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           npm completion -- "${COMP_WORDS[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
  }
  complete -F _npm_completion npm
elif type compdef &>/dev/null; then
  _npm_completion() {
    si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
elif type compctl &>/dev/null; then
  _npm_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       npm completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _npm_completion npm
fi
###-end-npm-completion-###

if [ -e /usr/local/opt/fzf/shell/completion.zsh ]; then
  source /usr/local/opt/fzf/shell/key-bindings.zsh
  source /usr/local/opt/fzf/shell/completion.zsh
fi

export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--color fg:242,bg:236,hl:65,fg+:15,bg+:239,hl+:108 --color info:108,prompt:109,spinner:108,pointer:168,marker:168'

