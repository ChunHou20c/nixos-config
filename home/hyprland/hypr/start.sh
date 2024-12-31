#!/usr/bin/env bash

# initialize swww
swww init &
swww img /home/chunhou/Pictures/Background/7.jpg

nm-applet --indicator &
blueman-applet &

waybar &
copyq --start-server &
