#!/usr/bin/env bash

enter_devshell(){

  if [ -f "flake.nix" ]; then
		echo "found flake.nix, entering development shell..."
		nix develop "#dev" --command "$1"
	else
		echo "no flake.nix found, continue with normal shell..."
		$1
	fi
}

option=$(find ~/Dev/ ~/Dev/work/tool/ -mindepth 1 -maxdepth 1 -type d | fzf)
if find "$option" -maxdepth 1 -type f -name "flake.nix" | grep -q .; then
  if nix flake show "$option" | grep -q "dev"; then
    echo "found flake.nix, entering development shell..."
    tmux new-session -As "$(basename "$option")" -c "$option" nix develop "$option"#dev --command nvim
  else 
    echo "no shell name dev found, entering normal dev shell..."
    tmux new-session -As "$(basename "$option")" -c "$option" "nvim"
  fi
else
    echo "no flake.nix found, continue with normal shell..."
    tmux new-session -As "$(basename "$option")" -c "$option" "nvim"
fi
