#!/usr/bin/env bash

calendar() {

  CALENDER_REV=$(eww get calendar_rev)
  if [ "$CALENDER_REV" = "false" ]; then 
    eww open calendar
    eww update calendar_rev=true
  else
    eww close calendar
    eww update calendar_rev=false
  fi
}

volume() {
  AUDIO_REV=$(eww get audioctl_reveal)
  if [ "$AUDIO_REV" = "false" ]; then 
    eww open audio_ctl
    eww update audioctl_reveal=true
  else
    eww close audio_ctl
    eww update audioctl_reveal=false
  fi
}

if [ "$1" = "calendar" ]; then
calendar
elif [ "$1" = "volume" ]; then
volume
fi

