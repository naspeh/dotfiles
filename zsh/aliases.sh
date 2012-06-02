#!/bin/zsh
# vim: set filetype=zsh

alias ls='ls --classify --color --human-readable --group-directories-first'
alias ll='ls -l'
alias la='ls -A'
alias l='l -lA'

alias cp='nocorrect cp --interactive --recursive --preserve=all'
alias mv='nocorrect mv --interactive'
alias pc='rsync -P'

alias rmi='nocorrect rm -Ir'

alias grep='grep --color=auto'

alias du='du --human-readable --total'
alias df='df --human-readable'

alias nohup='nohup > /dev/null $1'

alias x='startx'

alias -s {avi,mpeg,mpg,mov,m2v}=vlc
alias -s {odt,doc,sxw,rtf}=libreoffice
alias -s {pdf,djvu}=evince
alias -s {jpg,png,svg,xpm,bmp}=gthumb

autoload -U pick-web-browser
alias -s {html,htm,xhtml}=pick-web-browser

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


alias killall="killall --interactive --verbose"
alias git="nocorrect git"
alias free="free -t -m"

alias myip="curl ip.appspot.com"
alias timesync='ntpdate ua.pool.ntp.org'

alias pipi="pip install"
alias pipf="pip install --src=/arch/naspeh/libs"

alias pyclean="find . -name \"*.pyc\" -exec rm -rf {} \;"
alias pysmtpd="python -m smtpd -n -c DebuggingServer localhost:1025"

alias hdmi1="xrandr --output LVDS1 --auto --output HDMI1 --auto --right-of LVDS1"
alias dp1auto="xrandr --output LVDS-1 --auto --output DP-1 --auto --right-of LVDS-1"
alias dp1mode="xrandr --output LVDS-1 --auto --output DP-1 --right-of LVDS-1 --mode "
alias dp1mode1080p="xrandr --output LVDS-1 --auto --output DP-1 --right-of LVDS-1 --mode 1920x1080"
alias dp1mode720p="xrandr --output LVDS-1 --auto --output DP-1 --right-of LVDS-1 --mode 1280x720"

venv_has() {
    if [ -e .venv ]; then
        ENV_NAME=`cat .venv`
        ACTIVATE="$ENV_NAME/bin/activate"
        if [ -e $ACTIVATE ] && [ "$VIRTUAL_ENV" != "$ENV_NAME" ]; then
            source $ACTIVATE
            which python
        else
            ENV_PATH="$WORKON_HOME/$ENV_NAME"
            if [ -e "$ENV_PATH/bin/activate" ] && [ "$VIRTUAL_ENV" != "$ENV_PATH" ]; then
                workon $ENV_NAME
                which python
            fi
        fi
    fi
}
venv_cd () {
    cd "$@" && venv_has
}
alias ve="virtualenv --no-site-packages --distribute"
alias mkve="mkvirtualenv --no-site-packages --distribute"
alias onve="venv_has"
alias cd="venv_cd"
