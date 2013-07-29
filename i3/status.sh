#!/bin/bash
# https://faq.i3wm.org/question/1537/show-title-of-focused-window-in-status-bar/
i3status --config=~/.i3/status | while :
do
    read line
    id=$(xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}')
    name=$(xprop -id $id | awk '/_NET_WM_NAME/{$1=$2="";print}' | cut -d'"' -f2)
    echo "$name | $line" || exit 1
done
