#!/bin/bash
# a script to fade the volume to a given volume
# -e: volume where the fade ends at, Defaults to 50
# -s: volume where the fade start at, Defaults to current volume
# -w: wait time, the time between each volume change

# gets the average of left and right volume
START_VOL=$((($(cmus-remote -Q | grep -e "vol_left" | cut -d ' ' -f3) + $(cmus-remote -Q | grep -e "vol_right" | cut -d ' ' -f3)) / 2))
END_VOL=50

SLEEP_TIME=0.01

function getOptions() {
  local flag
  while getopts "s:e:w:h" flag; do
    case "$flag" in
    s) START_VOL=$OPTARG ;;
    e) END_VOL=$OPTARG ;;
    w) SLEEP_TIME=$OPTARG ;;
    h)
      echo "a script to fade the volume to a given volume"
      echo "-e: volume where the fade ends at, Defaults to 50"
      echo "-s: volume where the fade start at, Defaults to current volume"
      echo "-w: wait time, the time between each volume change"
      ;;
    *)
      echo "Unknown option: -$OPTARG" >&2
      exit
      ;;
    esac
  done
}

function main() {
  local vol
  for vol in $(seq "$START_VOL" "$END_VOL"); do
    cmus-remote -v "$vol" # set volume
    sleep "$SLEEP_TIME"   # wait volume
  done
}
getOptions "$@"

main & # in parallel so we can use the terminal while the volume is changing
