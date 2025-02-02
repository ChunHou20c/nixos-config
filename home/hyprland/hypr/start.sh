#!/usr/bin/env bash

# initialize swww
swww-daemon &
swww img ~/.config/hypr/background/9.jpg

eww open status_bar

nm-applet --indicator &
blueman-applet &
swaync &

copyq --start-server &
