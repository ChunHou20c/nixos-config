#!/usr/bin/env bash

# initialize swww
swww-daemon &
swww img ~/.config/hypr/background/7.jpg

eww daemon &

nm-applet --indicator &
blueman-applet &

waybar &
copyq --start-server &
