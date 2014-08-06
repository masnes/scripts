#!/bin/bash

while :
do
  if [[ -z "$count" ]]; then
    count=10
    # starting count % 2 = 0
    # starting count % 5 = 0
  else
    #let "count=$count + 1"
    let "count += 1"
  fi
  starter="S"
  sep=" | "

  #volume
  if [ "$(pamixer --get-mute)" = "true" ] ; then
    mute="M!"
  else
    mute=""
  fi
  volume=$(echo "Vol" && pamixer --get-volume)
  volume="$volume $mute"

  let "x=$count % 10"
  # changes way too frequently, so don't set it that often
  if [ $x -eq 0 ]; then
  wifi=$(cat /proc/net/wireless | sed -n 3p | awk '{print "Wifi: " $3 "/70"}' | tr -d '.')
  fi

  #takes a while, so don't set it that often
  if [ $x -eq 0 ]; then
    cpu=$(mpstat 2 1 | tail -n 2 | head -n 1 | awk '{printf "%5.2f", 100.0 - $13}' && echo -n "%% CPU")
  fi

  disk=$(df -h | head -2 | tail -1 | awk '{print $4}')

  #also takes a bit
  let "z=$count % 2"
  if [ $z -eq 0 ]; then
    battery=$(acpi | sed s/Battery\ \0\:/Bat/ | sed s/Discharging,/D/ | sed s/Charging,/C/ | sed s/Unknown\ // | sed s/\:[0-9]*\ /\ /g | sed s/\ until\ charged// | sed s/\ remaining// | tr ',' '%')
  fi

  date=$(date +'%a %b %d %H:%M')

  echo -n $starter $volume $sep $wifi $sep $cpu $sep $disk $sep $battery $sep $date | tr -d '\n' && echo ""
  sleep 0.5
done
#ps aux | awk {'sum+=$3;print sum'} | tail -n 1 | tr -d '\n' && echo -n "% CPU | "
