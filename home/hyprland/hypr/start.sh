#!/usr/bin/env bash

# initialize swww
swww-daemon &
swww img ~/.config/hypr/background/7.jpg

eww open status_bar

nm-applet --indicator &
blueman-applet &

copyq --start-server &
