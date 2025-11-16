#!/bin/bash
# a script to fade the volue to a given volume
# -e: volum where the fade ends at, Defaults to 50
# -s: volum where the fade start at, Defaults to current volume
# -w: wait time, the time between each volume change

START_VOL=$((($(cmus-remote -Q | grep -e "vol_left" | cut -d ' ' -f3) + $(cmus-remote -Q | grep -e "vol_right" | cut -d ' ' -f3)) / 2))
END_VOL=50

SLEEP_TIME=0.01

function getOptions() {
  local flag
  while getopts "s:e:w:" flag; do
    case "$flag" in
    s) START_VOL=$OPTARG ;;
    e) END_VOL=$OPTARG ;;
    w) SLEEP_TIME=$OPTARG ;;
    *)
      echo "Unknown option: -$OPTARG" >&2
      exit
      ;;
    esac
  done
}

function main() {
  local item
  for item in $(seq "$START_VOL" "$END_VOL"); do
    cmus-remote -v "$item"
    sleep "$SLEEP_TIME"
  done
}
getOptions "$@"

main &
