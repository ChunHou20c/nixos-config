#!/usr/bin/env bash

swayidle -w \
	timeout 300 'swaylock -f' \
	timeout 10 'if pgrep -x swaylock; then hyprctl dispatch dpms off; fi' resume 'hyprctl dispatch dpms on'  \
	timeout 600 'systemctl suspend' \
	resume 'hyprctl dispatch dpms on' \
	before-sleep 'swaylock -f'
