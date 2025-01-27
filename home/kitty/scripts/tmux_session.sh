#!/usr/bin/env bash

option=$(find ~/Dev/ -mindepth 1 -maxdepth 1 -type d | fzf)
tmux new-session -As "$(basename "$option")" -c "$option" "nvim"
