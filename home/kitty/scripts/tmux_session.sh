#!/usr/bin/env bash

option=$(find ~/Dev/ -mindepth 1 -maxdepth 1 -type d | fzf)
if find "$option" -maxdepth 1 -type f -name "flake.nix" | grep -q .; then
    echo "found flake.nix, entering development shell..."
    nix develop "$option"#dev --command tmux new-session -As "$(basename "$option")" -c "$option" nvim
else
    echo "no flake.nix found, continue with normal shell..."
    tmux new-session -As "$(basename "$option")" -c "$option" "nvim"
fi
