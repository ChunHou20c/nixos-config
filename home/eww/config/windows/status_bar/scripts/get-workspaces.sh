#!/usr/bin/env bash

spaces (){
  hyprctl workspaces -j | jq -Mc 'map({key: .id , value: .windows}) | sort_by(.key) | [.[] | select(.key > 0)] | map({id: .key| tostring, windows: .value})'
  # echo $WORKSPACE_WINDOWS
  # seq 1 10 | jq --argjson windows "${WORKSPACE_WINDOWS}" --slurp -Mc 'map(tostring) | map({id: ., windows: ($windows[.]//0)})'
}

spaces
socat -u UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line; do
  spaces
done
