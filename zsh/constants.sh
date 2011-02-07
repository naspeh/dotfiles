#!/bin/zsh
# vim: set filetype=zsh

ZDOTDIR=~/.zsh

export HISTTIMEFORMAT="%t%d.%m.%y %H:%M:%S%t"
export HISTIGNORE="&:ls:[bf]g:exit"

export PATH="$PATH:$HOME/bin"
export EDITOR="vim"

# type a directory's name to cd to it
compctl -/ cd

# tab completion for PID :D
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

HISTFILE=~/.zsh/.histfile
HISTSIZE=1000
SAVEHIST=$HISTSIZE
setopt hist_ignore_space
setopt hist_ignore_all_dups


export LESS_TERMCAP_mb=$'\E[01;31m'       # начало мерцающего стиля
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # начало полужирного стиля
export LESS_TERMCAP_me=$'\E[0m'           # окончание мерцающего или
export LESS_TERMCAP_so=$'\E[38;5;246m'    # начало служебной информации
export LESS_TERMCAP_se=$'\E[0m'           # окончание служебной
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # начало подчеркивания
export LESS_TERMCAP_ue=$'\E[0m'           # окончание подчеркивания


export PYTHONSTARTUP=~/.pythonrc

export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh
export PIP_VIRTUALENV_BASE=$WORKON_HOME
export PIP_RESPECT_VIRTUALENV=true
