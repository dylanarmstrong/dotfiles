# dylan's zshrc

# important shiznit
LANG=en_US.UTF-8
LC_ALL=$LANG
LC_COLLATE=C
export VDPAU_NVIDIA_NO_OVERLAY=1
export MANPAGER=vimmanpager

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

# keys
bindkey -e
bindkey "\e[B" history-beginning-search-forward
bindkey "\e[A" history-beginning-search-backward
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

# prompt


# get the name of the branch we are on
function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
echo "$GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$GIT_PROMPT_SUFFIX"
}


# Checks if working tree is dirty
parse_git_dirty() {
  local SUBMODULE_SYNTAX=''
  if [[ $POST_1_7_2_GIT -gt 0 ]]; then
SUBMODULE_SYNTAX="--ignore-submodules=dirty"
  fi
if [[ -n $(git status -s ${SUBMODULE_SYNTAX} 2> /dev/null) ]]; then
echo "$GIT_PROMPT_DIRTY"
  else
echo "$GIT_PROMPT_CLEAN"
  fi
}


# Checks if there are commits ahead from remote
function git_prompt_ahead() {
  if $(echo "$(git log origin/$(current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
echo "$GIT_PROMPT_AHEAD"
  fi
}

# Formats prompt string for current git commit short SHA
function git_prompt_short_sha() {
  SHA=$(git rev-parse --short HEAD 2> /dev/null) && echo "$GIT_PROMPT_SHA_BEFORE$SHA$GIT_PROMPT_SHA_AFTER"
}

# Formats prompt string for current git commit long SHA
function git_prompt_long_sha() {
  SHA=$(git rev-parse HEAD 2> /dev/null) && echo "$GIT_PROMPT_SHA_BEFORE$SHA$GIT_PROMPT_SHA_AFTER"
}

# Get the status of the working tree
git_prompt_status() {
  INDEX=$(git status --porcelain 2> /dev/null)
  STATUS=""
  if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
STATUS="$GIT_PROMPT_UNTRACKED$STATUS"
  fi
if $(echo "$INDEX" | grep '^A ' &> /dev/null); then
STATUS="$GIT_PROMPT_ADDED$STATUS"
  elif $(echo "$INDEX" | grep '^M ' &> /dev/null); then
STATUS="$GIT_PROMPT_ADDED$STATUS"
  fi
if $(echo "$INDEX" | grep '^ M ' &> /dev/null); then
STATUS="$GIT_PROMPT_MODIFIED$STATUS"
  elif $(echo "$INDEX" | grep '^AM ' &> /dev/null); then
STATUS="$GIT_PROMPT_MODIFIED$STATUS"
  elif $(echo "$INDEX" | grep '^ T ' &> /dev/null); then
STATUS="$GIT_PROMPT_MODIFIED$STATUS"
  fi
if $(echo "$INDEX" | grep '^R ' &> /dev/null); then
STATUS="$GIT_PROMPT_RENAMED$STATUS"
  fi
if $(echo "$INDEX" | grep '^ D ' &> /dev/null); then
STATUS="$GIT_PROMPT_DELETED$STATUS"
  elif $(echo "$INDEX" | grep '^AD ' &> /dev/null); then
STATUS="$GIT_PROMPT_DELETED$STATUS"
  fi
if $(echo "$INDEX" | grep '^UU ' &> /dev/null); then
STATUS="$GIT_PROMPT_UNMERGED$STATUS"
  fi
echo $STATUS
}

GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}"
GIT_PROMPT_SUFFIX="%{$reset_color%} "
GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$reset_color%}"
GIT_PROMPT_CLEAN=""

PROMPT="%{$fg[cyan]%}%1~%{$fg[red]%}|$(git_prompt_info)%{$fg[cyan]%}>%{$fg_no_bold[default]%} "
