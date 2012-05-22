export ZSH=$HOME/.oh-my-zsh

export ZSH_THEME="miloshadzic"

export EDITOR="vim"
export TERM="rxvt-256color"

export PATH=/sbin:/usr/sbin:/usr/local/games:$PATH:$HOME/bin

plugins=(git github bundler)

source $ZSH/oh-my-zsh.sh
source $HOME/.zshrc.local
