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

export PYTHONSTARTUP=~/.pythonrc

export WORKON_HOME=$HOME/.virtualenvs
source $(which virtualenvwrapper.sh)
export PIP_VIRTUALENV_BASE=$WORKON_HOME
export PIP_RESPECT_VIRTUALENV=true
