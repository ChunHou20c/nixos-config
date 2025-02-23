#!/usr/bin/env bash

# initialize swww
swww-daemon &
swww restore

eww open status_bar

nm-applet --indicator &
blueman-applet &
swaync &

copyq --start-server &
