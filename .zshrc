export ZSH=$HOME/.oh-my-zsh

export ZSH_THEME="miloshadzic"
#export ZSH_THEME="darkblood"
#export ZSH_THEME="mein"

export EDITOR="vim"
export TERM="rxvt-256color"

export PATH=$PATH:$HOME/bin

plugins=(git github bundler)

source $ZSH/oh-my-zsh.sh
source $HOME/.zshrc.local
