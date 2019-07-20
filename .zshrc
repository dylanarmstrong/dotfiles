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
export JAVA_HOME=$HOME/Documents/jdk-11.0.2.jdk/Contents/Home

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

# aliases
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
alias vim='nvim'
alias mitmproxy='mitmproxy -p 8080 --mode socks5 --set console_mouse=false --set console_palette=light --anticomp --anticache'

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

# base16
BASE16_SHELL=$HOME/src/base16/base16-shell/
[ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

if [ -e /usr/local/opt/fzf/shell/completion.zsh ]; then
  source /usr/local/opt/fzf/shell/key-bindings.zsh
  source /usr/local/opt/fzf/shell/completion.zsh
fi

export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"

# base16-fzf
source $HOME/src/base16/base16-fzf/bash/base16-summerfruit-dark.config

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# yarn completion (must come after nvm)
source $HOME/src/yarn-completion/yarn-completion.plugin.zsh
# npm completion
source $HOME/src/zsh-better-npm-completion/zsh-better-npm-completion.plugin.zsh

# opam configuration
test -r $HOME/.opam/opam-init/init.zsh && . $HOME/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

# nvm modifies path, so this needs to come after
export PATH=/sbin:/usr/sbin:/usr/local/sbin:$HOME/bin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$HOME/.nvm/versions/node/v11.15.0/bin:/usr/local/bin:$HOME/Library/Python/3.7/bin:/usr/local/opt/sqlite/bin:/bin:/usr/bin:$HOME/.cabal/bin:$HOME/.cargo/bin:/usr/local/games:$HOME/.local/bin:/Library/TeX/texbin:/opt/X11/bin:/Library/Frameworks/Mono.framework/Versions/Current/Commands:/Applications/Wireshark.app/Contents/MacOS:/usr/local/opt/node@8/bin:/usr/local/lib/ruby/gems/2.6.0/bin
