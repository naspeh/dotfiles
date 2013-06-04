#!/bin/zsh

ZDOTDIR=~/.zsh

export PATH="$PATH:$HOME/bin"
export EDITOR=vim
export BROWSER=chromium

export TERM=xterm-256color
[ -n "$TMUX" ] && export TERM=screen-256color

REPORTTIME=2

export HISTTIMEFORMAT="%t%d.%m.%y %H:%M:%S%t"
export HISTIGNORE="&:ls:[bf]g:exit"
HISTFILE=~/.zsh/history.log
HISTSIZE=1000
SAVEHIST=$HISTSIZE
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt appendhistory
setopt sharehistory

setopt autocd
setopt beep
setopt extendedglob
setopt nomatch
setopt notify
unsetopt correct_all

# type a directory's name to cd to it
compctl -/ cd

bindkey -e

autoload -Uz compinit; compinit

zstyle ':completion:*' completer _complete _match _ignored _files
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' max-errors 1
zstyle ':completion:*' menu select=long-list select=0
#zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

# tab completion for PID :D
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

zstyle ':completion:*:processes' command 'ps -xuf'
zstyle ':completion:*:processes' sort false

zstyle ':completion:*:processes-names' command 'ps xho command'

monic() {
    mode='--auto'
    output='HDMI1'
    if [ $1 ]; then
        output=$1
    fi
    if [ $2 ]; then
        mode="--mode $2"
    fi
    cmd="xrandr --output LVDS1 --auto --output $output --right-of LVDS1 $mode"
    echo $cmd
    eval $cmd
}

export VENV_HOME=$HOME/v
export PIP_VIRTUALENV_BASE=$VENV_HOME
export PIP_RESPECT_VIRTUALENV=true
export VIRTUALENV_DISTRIBUTE=true

venv() {
    if [ -z "$1" ]; then
        echo "List of virtualenvs: `command ls -m $VENV_HOME`"
        return 1
    fi

    env_name=$1
    if [ $1 = '--auto' ]; then
        if [ -e .venv ]; then
            $env_name=`cat .venv`
        else
            echo "Make './.venv' file for autoload virtualenv"
            return 1
        fi
    fi

    activate="$env_name/bin/activate"
    if [ -e $activate ]; then
        env_path=env_name
    else
        env_path="$VENV_HOME/$env_name"
        activate="$env_path/bin/activate"
    fi

    if [ -e "$activate" ]; then
        if [ "$VIRTUAL_ENV" != "$env_path" ]; then
            VIRTUAL_ENV_DISABLE_PROMPT=1
            source $activate
            which python
            return 0
        fi
    else
        echo "Virtualenv is not found: '$env_name'"
        return 1
    fi
}
venv_cd() {
    if cd "$@"; then
        if [ -e .venv ]; then
            venv `cat .venv`
        fi
        return 0
    else
        return $?
    fi
}
venv_new() {
    env_name=$1
    if venv $env_name; then
        echo "Virtualenv already exist: '$env_name'"
        return 1
    else
        virtualenv ~/v/$env_name
        venv $env_name
    fi
}
venv_info() {
    if [ $VIRTUAL_ENV ]; then
        echo "%F{blue}[%F{cyan}env: %B`basename $VIRTUAL_ENV`%b%F{blue}] "
    fi
}
_venv_complete () {
    reply=( $(cd $WORKON_HOME && ls -d *) )
}
compctl -K _venv_complete venv

alias cd="venv_cd"
alias ve="venv_new"

alias ls='ls --classify --color --human-readable --group-directories-first'
alias ll='ls -l'
alias cp='nocorrect cp --interactive --recursive --preserve=all'
alias mv='nocorrect mv --interactive'

alias du='du --human-readable --total'
alias df='df --human-readable'
alias grep='grep --color=auto'
alias rsync='nocorrect rsync'
alias git="nocorrect git"
alias killall="killall --interactive --verbose"
alias tmux='tmux -2'
alias mc='mc -b'
alias nohup='nohup > /dev/null $1'
alias free="free -t -m"

alias -s {avi,mpeg,mpg,mov,m2v,m4v}=vlc
alias -s {pdf,djvu}=evince
alias -s {jpg,png,svg,xpm,bmp}=mirage
alias -s {html,htm,xhtml}=chromium

[ -f "$(which pacman)" ] && alias pacclear="pacman -Rs \`pacman -Qtdq\`"

alias myip="curl ip.appspot.com"
alias timesync='ntpdate ua.pool.ntp.org'

alias pip="nocorrect pip"
alias pipi="pip install"
alias pipf="pip install --src=/arch/naspeh/libs"

alias pyclean="find . -name \"*.pyc\" -exec rm -rf {} \;"
alias pysmtpd="python -m smtpd -n -c DebuggingServer localhost:1025"

## Prompt ##
autoload colors; colors
setopt prompt_subst

# Decide if we need to set titlebar text.
case $TERM in
    (xterm*|rxvt)
        titlebar_precmd () { print -Pn "\e]0;%n@%m: %~\a" }
        titlebar_preexec () { print -Pn "\e]0;$1 %n@%m: %~\a" }
        ;;
    (screen*)
        titlebar_precmd () { echo -ne "\ek${1%% *}\e\\" }
        titlebar_preexec () { echo -ne "\ek${1%% *}\e\\" }
        ;;
    (*)
        titlebar_precmd () {}
        titlebar_preexec () {}
        ;;
esac
precmd () {
    titlebar_precmd
}
preexec () {
    titlebar_preexec
}

# VCS info
autoload -Uz vcs_info

zstyle ':vcs_info:*' stagedstr '%F{28} ●'
zstyle ':vcs_info:*' unstagedstr '%F{11} ●'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{11}%r'
zstyle ':vcs_info:*' enable git hg svn
precmd () {
    if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
        zstyle ':vcs_info:*' formats '%F{blue}[%F{green}%b%c%u%F{blue}] '
    } else {
        zstyle ':vcs_info:*' formats '%F{blue}[%F{green}%b%c%u%F{red} ●%F{blue}] '
    }

    vcs_info
    titlebar_precmd
}

pwd_length() {
  local length
  (( length = $COLUMNS / 2 - 25 ))
  echo $(($length < 20 ? 20 : $length))
}

# red, green, yellow, blue, magenta, cyan, white, black
# B(bold), K(background color), F(foreground color)
# %F{yellow} - make the foreground color yellow
# %f - reset the foreground color to the default
p_user_host='%f%B%(!.%F{red}.%F{green})'`if [[ ! $HOME == */$USER ]] echo '%n@'`'%m%b:'
p_time='%f%F{magenta}[%T] '
p_pwd='%f%B%F{blue}%$(pwd_length)<...<%(!.%/.%~)%<< %b'
p_vcs_info='%f${vcs_info_msg_0_}'
p_venv_info='%f$(venv_info)'
p_exit_code='%f%F{red}%(0?..%? ↵)'
p_jobs='%f%F{cyan}%1(j.(%j) .)'
p_sigil='%f%B%F{green}%(!.%F{red}.)\$ '
p_end='%f%b'

# left
PS1="$p_time$p_user_host$p_pwd$p_venv_info$p_vcs_info$p_jobs$p_exit_code
$p_sigil$p_end%f"
