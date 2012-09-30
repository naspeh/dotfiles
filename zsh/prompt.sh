#!/bin/zsh
# vim: set filetype=zsh

### COLORS ###
fg_green=$'%{\e[0;32m%}'
fg_blue=$'%{\e[0;34m%}'
fg_cyan=$'%{\e[0;36m%}'
fg_red=$'%{\e[0;31m%}'
fg_brown=$'%{\e[0;33m%}'
fg_purple=$'%{\e[0;35m%}'

fg_light_gray=$'%{\e[0;37m%}'
fg_dark_gray=$'%{\e[1;30m%}'
fg_light_blue=$'%{\e[1;34m%}'
fg_light_green=$'%{\e[1;32m%}'
fg_light_cyan=$'%{\e[1;36m%}'
fg_light_red=$'%{\e[1;31m%}'
fg_light_purple=$'%{\e[1;35m%}'

fg_no_color=$'%{\e[0m%}'
fg_white=$'%{\e[1;37m%}'
fg_black=$'%{\e[0;30m%}'


# Decide if we need to set titlebar text.
case $TERM in
  (xterm*|rxvt)
    titlebar_precmd () { print -Pn "\e]0;%n@%m: %~\a" }
    titlebar_preexec () { print -Pn "\e]0;%n@%m: $1\a" }
    ;;
    (screen)
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

battery_charge () {
  # Battery 0: Discharging, 94%, 03:46:34 remaining
  bat_percent=`acpi | awk -F ':' {'print $2;'} | awk -F ',' {'print $2;'} | sed -e "s/\s//" -e "s/%.*//"`

  if [ $bat_percent -lt 20 ]; then cl='%F{red}'
  elif [ $bat_percent -lt 50 ]; then cl='%F{yellow}'
  else cl='%F{green}'
  fi

  filled=${(l:`expr $bat_percent / 10`::▸:)}
  empty=${(l:`expr 10 - $bat_percent / 10`::▹:)}
  echo $cl$filled$empty'%F{default}'
}

# prompt helpers
autoload -Uz vcs_info

zstyle ':vcs_info:*' stagedstr '%F{28} ●'
zstyle ':vcs_info:*' unstagedstr '%F{11} ●'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{11}%r'
zstyle ':vcs_info:*' enable git hg svn
precmd () {
    if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
        zstyle ':vcs_info:*' formats '%F{blue}[%F{green}%b%c%u%F{blue}]'
    } else {
        zstyle ':vcs_info:*' formats '%F{blue}[%F{green}%b%c%u%F{red} ●%F{blue}]'
    }

    vcs_info
}

setopt prompt_subst

pwd_length() {
  local length
  (( length = $COLUMNS / 2 - 25 ))
  echo $(($length < 20 ? 20 : $length))
}

prompt_user_host='%(!.${fg_red}.${fg_green})'`if [[ ! $HOME == */$USER ]] echo '%n@'`'%m%b:'
prompt_jobs='${fg_cyan}%1(j.(%j) .)'
prompt_time='${fg_brown}[%T] '
prompt_pwd='${fg_light_blue}%$(pwd_length)<...<%(!.%/.%~)%<< '
prompt_vcs_info='${fg_no_color}${vcs_info_msg_0_}'
prompt_exit_code='${fg_red}%(0?..%? ↵)${fg_no_color}'
prompt_battery='[%*] $(battery_charge)'
prompt_sigil='${fg_brown}%(!.${fg_red}.)\$ '
prompt_end='%f'

# left
#PROMPT=$'%B%{\e[0;36m%}┌─[%{\e[0;33m%}%n%{\e[0;36m%}@%{\e[0;33m%}%m%{\e[0;36m%}]──(%{\e[0;33m%}%~%{\e[0;36m%})\n└─[%{\e[0;39m%}%# %{\e[0;36m%}>%b'
#PROMPT='%F{blue}%n@%m %c${vcs_info_msg_0_}%F{blue} %(?/%F{blue}/%F{red})%% %{$reset_color%}'
#PS1="$prompt_time$prompt_user_host$prompt_pwd$prompt_git_branch$prompt_jobs$prompt_sigil$prompt_end"
#PS1="${fg_cyan}┌─${fg_cyan}──$prompt_time$prompt_user_host$prompt_pwd$prompt_git_branch$prompt_jobs
PS1="$prompt_time$prompt_user_host$prompt_pwd$prompt_vcs_info$prompt_jobs$prompt_exit_code
$prompt_sigil$prompt_end"

# right
#RPS1="$prompt_battery"
