#!/usr/bin/env bash

# initialize swww
swww init &
swww img ~/.config/hypr/background/7.jpg

nm-applet --indicator &
blueman-applet &

waybar &
copyq --start-server &
