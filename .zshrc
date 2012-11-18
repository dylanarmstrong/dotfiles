# the zshrc file

# important shiznit
LANG=en_US.UTF-8
LC_ALL=$LANG
LC_COLLATE=C

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
HISTSIZE=5000
SAVEHIST=1000
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt share_history
setopt extended_history
setopt hist_verify

# environment
export EDITOR=vim
export PATH=/sbin:/usr/sbin:/usr/local/games:$PATH:$HOME/bin
export VDPAU_NVIDIA_NO_OVERLAY=1
export MANPAGER=vimmanpager

# keys
bindkey -e
# bindkey -v
# bindkey -M vicmd "k" history-beginning-search-backward
# bindkey -M vicmd "j" history-beginning-search-forward
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
alias rm='nocorrect rm -v'
alias mkdir='nocorrect mkdir -v'
alias emerge='nocorrect emerge'
alias vim='vim -X'
alias ps='ps aux'
alias e='exit'
alias c='clear'
alias ls='ls --color'
alias grep='grep --color=auto'
alias eix-sync='eix-sync -H' 

# useful color function
function spectrum_ls() {
  for code in {000..255}; do
    print -P -- "$code: %F{$code}Test%f"
  done
}

# prompt
setopt prompt_subst
autoload -Uz add-zsh-hook vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' formats '%F{2}%b%u%f '
zstyle ':vcs_info:*' unstagedstr '%F{1}*'

function prompt_precmd() { vcs_info }
function set_prompt { PROMPT="%F{38}%1~%F{1}|${vcs_info_msg_0_}%F{38}>%f " }
add-zsh-hook precmd prompt_precmd
add-zsh-hook precmd set_prompt
