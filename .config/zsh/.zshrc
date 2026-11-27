# shellcheck disable=SC2034,SC1091
# zmodload zsh/zprof

# Environment variables and PATH are managed by home-manager and loaded from ~/.zshenv.
unset LC_ALL LC_CTYPE

HISTFILE="$XDG_STATE_HOME/zsh/history"
[[ -d ${HISTFILE:h} ]] || mkdir -p -m 700 "${HISTFILE:h}"

# https://github.com/keybase/keybase-issues/issues/2798
# shellcheck disable=SC2155
export GPG_TTY=$(tty)

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
bindkey "\eOB" history-beginning-search-forward
bindkey "\eOA" history-beginning-search-backward
bindkey -M emacs $'\e[1;3C' forward-word
bindkey -M emacs $'\e[1;3D' backward-word
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
zstyle ':completion:*' file-sort name
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '' '+m:{a-z}={A-Z}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' use-cache 1
zstyle ':completion:*' cache-path "$HOME"/.zsh/cache
zstyle ':completion:::::' completer _complete _approximate
zstyle ':completion:*:approximate:*' max-errors 2
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
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:ssh:*' hosts off
zstyle ':completion:*:scp:*' hosts off
zstyle ':completion:*:rsync:*' hosts off

# Aliases
alias 7zx='7z x'
alias bc='bc -l'
alias c='clear'
alias cp='nocorrect cp -v'
alias darwin-build='darwin-rebuild build --flake "$HOME/src/nix#Dylans-MacBook-Pro"'
alias darwin-switch='darwin-build && sudo darwin-rebuild switch --flake "$HOME/src/nix#Dylans-MacBook-Pro"'
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
alias nixos-switch='ssh -t nix "sudo systemctl start nixos-upgrade.service"'
alias rm='nocorrect rm -v'
alias scripts='jq '.scripts' package.json'
alias update-flake='nix flake update --flake "$HOME/src/nix" dotfiles secrets'
alias view='nvim -R'
alias vim='nvim'
alias wget='wget --hsts-file=$XDG_DATA_HOME/wget-hsts'

if [[ "$OSTYPE" = darwin* ]] && [ -x /Applications/Tailscale.app/Contents/MacOS/Tailscale ]; then
  alias tailscale=/Applications/Tailscale.app/Contents/MacOS/Tailscale
fi

# Prompt
setopt prompt_subst
autoload -Uz add-zsh-hook vcs_info

zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' formats '%F{2}%b%u%f '
zstyle ':vcs_info:*' unstagedstr '%F{1}*'

function prompt_precmd() {
  vcs_info

  # Override vcs_info if we're in a jj repo
  if command -v jj &>/dev/null && jj root 1>/dev/null 2>/dev/null; then
    local jj_raw shortest remainder full_short bookmark_info suffix

    jj_raw=$(jj log --no-graph -r @ -T '
      change_id.shortest()
      ++ "|"
      ++ change_id.short()
      ++ "|"
      ++ bookmarks.join(", ")
    ' 2>/dev/null)

    shortest="${jj_raw%%|*}"
    remainder="${jj_raw#*|}"
    full_short="${remainder%%|*}"
    bookmark_info="${remainder#*|}"
    suffix="${full_short:${#shortest}}"

    vcs_info_msg_0_="%B%F{5}${shortest}%b%F{8}${suffix}%f"

    if [[ -n "$bookmark_info" ]]; then
      vcs_info_msg_0_+=" %F{2}${bookmark_info}%f"
    fi

    vcs_info_msg_0_+=" "
  fi
}

function set_prompt {
  local host_prefix=''

  case "${HOST%%.*}" in
    nix-mbp) host_prefix='(nix) ' ;;
    dylan-is) host_prefix='(dylan.is) ' ;;
    macbook) host_prefix='' ;;
  esac

  # shellcheck disable=SC2154
  PROMPT="${host_prefix}%F{39}%1~ ${vcs_info_msg_0_}%F{1}>%f "
}

add-zsh-hook precmd prompt_precmd
add-zsh-hook precmd set_prompt

[ -n "${TTY:-}" ] && command -v fzf >/dev/null 2>&1 && eval "$(fzf --zsh)"
command -v uv >/dev/null 2>&1 && eval "$(uv generate-shell-completion zsh)"
command -v uvx >/dev/null 2>&1 && eval "$(uvx --generate-shell-completion zsh)"
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

# Opens a file in vim
function fv() {
  local file
  file="$(fzf --height 80% --reverse --preview 'bat --style=numbers --color=always {} 2>/dev/null || cat {}')"
  if [ -n "$file" ]; then
    vim "$file"
  fi
}

# Opens the directory a file is in
function fz() {
  local file
  file="$(fzf --height 80% --reverse --preview 'bat --style=numbers --color=always {} 2>/dev/null || cat {}')"
  if [ -n "$file" ]; then
    cd "$(dirname "$file")" || exit 1
  fi
}

# zprof
