#!/usr/bin/env bash
PID=$(pidof hypridle)

if [ -z "$PID" ]; then
    hypridle > /dev/null &
    echo "enable"
else
    kill "$PID"
    echo "disable"
fi
