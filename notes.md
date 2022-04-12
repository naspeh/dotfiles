# Dotfiles
- https://github.com/twpayne/chezmoi Manage your dotfiles across multiple diverse machines, securely.

# i3
- https://github.com/polybar/polybar A fast and easy-to-use status bar


# https://wiki.archlinux.org/index.php/Power_management#ACPI_events
# /etc/acpi/events/lock
```sh
event=button/lid.*
action=/bin/su naspeh -c 'echo %e | grep ".*close" && (DISPLAY=:0 xrandr | grep -c "HDMI. connected" || DISPLAY=:0 ~/bin/my lock)'
```

- https://github.com/cdown/clipmenu
- https://github.com/ms-jpq/isomorphic_copy
