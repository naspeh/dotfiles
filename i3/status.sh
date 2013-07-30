#!/bin/bash
# https://faq.i3wm.org/question/1537/show-title-of-focused-window-in-status-bar/
i3status --config=~/.i3/status | while :
do
    read line
    tider="[$(cat ~/.config/tider/i3bar.txt),"
    echo "${line/[/$tider}" || exit 1
done
