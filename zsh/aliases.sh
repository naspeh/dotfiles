#!/bin/zsh
# vim: set filetype=zsh

alias ls='ls --classify --color --human-readable --group-directories-first'
alias ll='ls -l'
alias la='ls -A'
alias l='l -lA'

alias cp='nocorrect cp --interactive --recursive --preserve=all'
alias mv='nocorrect mv --interactive'
alias pc="rsync -P"

alias rmi='nocorrect rm -Ir'

alias grep='grep --color=auto'

alias du='du --human-readable --total'
alias df='df --human-readable'

alias nohup='nohup > /dev/null $1'

alias x=startx

alias -s {avi,mpeg,mpg,mov,m2v}=vlc
alias -s {odt,doc,sxw,rtf}=openoffice.org
alias -s {pdf,djvu}=evince
alias -s {jpg,png,svg,xpm,bmp}=gpicview

[[ -z $DISPLAY ]] && {
 #alias -s {odt,doc,sxw,xls,doc,rtf}=
 alias -s {png,gif,jpg,jpeg}=fbv
 alias -s {pdf}=apvlv
}

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

alias free="free -t -m"

alias myip="curl ip.appspot.com"

alias git="nocorrect git"

alias ve="virtualenv --no-site-packages --distribute"
alias mkve="mkvirtualenv --no-site-packages --distribute"
alias pipi="pip install"
alias pipf="pip install --src=/arch/naspeh/libs"

venv_has() {
    if [ -e .venv ]; then
        ENV_NAME=`cat .venv`
        ACTIVATE="$ENV_NAME/bin/activate"
        if [ -e $ACTIVATE ]; then
            source $ACTIVATE
            which python
        else
            if [ -e "$WORKON_HOME/$ENV_NAME/bin/activate" ]; then
                workon $ENV_NAME
                which python
            fi
        fi
    fi
}
venv_cd () {
    cd "$@" && venv_has
}
alias cd="venv_cd"
