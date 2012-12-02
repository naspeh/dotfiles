#!/bin/zsh

ZDOTDIR=~/.zsh

#eval `dircolors ~/.zsh/dircolors/dircolors.ansi-light`

export HISTTIMEFORMAT="%t%d.%m.%y %H:%M:%S%t"
export HISTIGNORE="&:ls:[bf]g:exit"

export PATH="$PATH:$HOME/bin"
export EDITOR="vim"
export BROWSER=chromium

#PAGER=less
#if [ -f /usr/bin/vimpager ]; then
#    export PAGER=vimpager
#fi
#alias less=$PAGER

export TERM='xterm-256color'
[ -n "$TMUX" ] && export TERM=screen-256color

HISTFILE=~/.zsh/.histfile
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
#autoload -U edit-command-line
#zle -N  edit-command-line
#bindkey -M vicmd v edit-command-line

#function zle-line-init zle-keymap-select {
#    RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
#    RPS2=$RPS1
#    zle reset-prompt
#}
#zle -N zle-line-init
#zle -N zle-keymap-select

#autoload -Uz compinit; compinit

#zstyle ':completion:*' completer _complete _match _ignored _files
##zstyle ':completion:*' completer _complete _match _ignored _approximate _files
#zstyle ':completion:*' group-name ''
#zstyle ':completion:*' list-colors ''
#zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
#zstyle ':completion:*' max-errors 1
#zstyle ':completion:*' menu select=long-list select=0
#zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
##zstyle ':completion:*' use-compctl false
#zstyle ':completion:*' verbose true
##zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

## tab completion for PID :D
#zstyle ':completion:*:*:kill:*' menu yes select
#zstyle ':completion:*:kill:*' force-list always

#zstyle ':completion:*:processes' command 'ps -xuf'
#zstyle ':completion:*:processes' sort false

#zstyle ':completion:*:processes-names' command 'ps xho command'

zmodload zsh/complist
autoload -Uz compinit; compinit
zstyle :compinstall filename '${HOME}/.zshrc'

#- buggy
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
#-/buggy

zstyle ':completion:*:pacman:*' force-list always
zstyle ':completion:*:*:pacman:*' menu yes select

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always

zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*'   force-list always


## Aliases ##
if [ -f /usr/bin/grc ]; then
    alias grc='grc --colour=auto'
    alias ping='grc ping'
    alias last='grc last'
    alias netstat='grc netstat'
    alias traceroute='grc traceroute'
    alias make='grc make'
    alias gcc='grc gcc'
    alias configure='grc ./configure'
    alias cat="grc cat"
    alias tail="grc tail"
    alias head="grc head"
fi

#alias cat='vimcat'
alias tmux='tmux -2'
alias mc='mc -b'

alias ls='ls --classify --color --human-readable --group-directories-first'
alias ll='ls -l'
alias la='ls -A'
alias l='l -lA'

alias pc='rsync -P'
alias cp='nocorrect cp --interactive --recursive --preserve=all'
alias mv='nocorrect mv --interactive'
alias rmi='nocorrect rm -Ir'

alias grep='grep --color=auto'

alias du='du --human-readable --total'
alias df='df --human-readable'

alias nohup='nohup > /dev/null $1'

alias x='startx'

alias -s {avi,mpeg,mpg,mov,m2v}=vlc
alias -s {odt,doc,sxw,rtf}=libreoffice
alias -s {pdf,djvu}=evince
alias -s {jpg,png,svg,xpm,bmp}=mirage

autoload -U pick-web-browser
alias -s {html,htm,xhtml}=pick-web-browser

alias killall="killall --interactive --verbose"
alias git="nocorrect git"
alias free="free -t -m"
[ -f "$(which pacman)" ] && alias pacclear='pacman -Rs "$(pacman -Qtdq)"'

alias myip="curl ip.appspot.com"
alias timesync='ntpdate ua.pool.ntp.org'

alias hdmi1="xrandr --output LVDS1 --auto --output HDMI1 --auto --right-of LVDS1"
alias dp1auto="xrandr --output LVDS-1 --auto --output DP-1 --auto --right-of LVDS-1"
alias dp1mode="xrandr --output LVDS-1 --auto --output DP-1 --right-of LVDS-1 --mode "
alias dp1mode1080p="xrandr --output LVDS-1 --auto --output DP-1 --right-of LVDS-1 --mode 1920x1080"
alias dp1mode720p="xrandr --output LVDS-1 --auto --output DP-1 --right-of LVDS-1 --mode 1280x720"

#export PYTHONSTARTUP=~/.pythonrc
if [ -f "$(which virtualenvwrapper.sh)" ]; then
    source $(which virtualenvwrapper.sh)
fi
export WORKON_HOME=$HOME/.virtualenvs
export PIP_VIRTUALENV_BASE=$WORKON_HOME
export PIP_RESPECT_VIRTUALENV=true

venv_has() {
    if [ -e .venv ]; then
        env_name=`cat .venv`
        activate="$env_name/bin/activate"
        if [ -e $activate ]; then
            env_path=env_name
        else
            env_path="$WORKON_HOME/$env_name"
            activate="$env_path/bin/activate"
        fi

        if [ -e "$activate" ] && [ "$VIRTUAL_ENV" != "$env_path" ]; then
            VIRTUAL_ENV_DISABLE_PROMPT=1
            source $activate
            which python
        fi
    fi
}
venv_cd() {
    cd "$@" && venv_has
}
venv_info() {
    if [ $VIRTUAL_ENV ]; then
        echo "%F{blue}[%F{cyan}env: %B`basename $VIRTUAL_ENV`%b%F{blue}] "
    fi
}
alias ve="virtualenv --no-site-packages --distribute"
alias mkve="mkvirtualenv --no-site-packages --distribute"
alias onve="venv_has"
alias cd="venv_cd"

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

battery_charge () {
  # Battery 0: Discharging, 94%, 03:46:34 remaining
  bat_percent=`acpi | awk -F ':' {'print $2;'} | awk -F ',' {'print $2;'} | sed -e "s/\s//" -e "s/%.*//"`

  if [ $bat_percent -lt 20 ]; then cl='%F{red}'
  elif [ $bat_percent -lt 50 ]; then cl='%F{yellow}'
  else cl='%F{green}'
  fi

  filled=${(l:`expr $bat_percent / 10`::▸:)}
  empty=${(l:`expr 10 - $bat_percent / 10`::▹:)}
  #echo $cl$filled$empty'
  echo '$cl$bat_percent'
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
p_user_host='%B%(!.%F{red}.%F{green})'`if [[ ! $HOME == */$USER ]] echo '%n@'`'%m%b:'
p_time='%F{magenta}[%T] '
p_pwd='%B%F{blue}%$(pwd_length)<...<%(!.%/.%~)%<< %b'
p_vcs_info='%f${vcs_info_msg_0_}'
p_venv_info='%f$(venv_info)'
p_exit_code='%F{red}%(0?..%? ↵)%f'
p_jobs='%F{cyan}%1(j.(%j) .)'
p_sigil='%B%F{green}%(!.%F{red}.)\$ '
p_end='%b%f'
p_battery='$(battery_charge)%F{default}'

# left
PS1="$p_time$p_user_host$p_pwd$p_venv_info$p_vcs_info$p_jobs$p_exit_code
$p_sigil$p_end"

# right
#RPS1="$p_battery"
