#!/bin/bash

while :
do
  if [[ -z "$count" ]]; then
    count=0
    # starting count % 2 = 0
    # starting count % 5 = 0
  elif [[ $count -eq 20 ]]; then
    count=0
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
  volume=$(echo $volume $mute | awk '{printf "%s %02d", $1, $2}')

  if [[ $count -eq 0 ]]; then
    # changes way too frequently, so don't set it that often
    if [[ $(cat /proc/net/wireless | wc -l) -eq 2 ]]; then
      wifi="Wifi: D"
    else
      wifi=$(cat /proc/net/wireless | sed -n 3p | awk '{strength = $3 * 100 / 70; printf "Wifi: %.0f%%%", strength}' | tr -d '.')
    fi

    #takes a while, so set it asynchronously
    if [[ -z $(ps -o pid= -p $last_mpstat 2>/dev/null) ]]; then
      if [[ -e /tmp/cpu_new ]]; then
        cp /tmp/cpu_new /tmp/cpu
        cpu=$(cat /tmp/cpu | tail -n 1 | awk '{printf "%05.2f", 100.0 - $12}' && echo -n "% CPU" &)
      fi
      mpstat 2 1 > /tmp/cpu_new &
      last_mpstat=$!
    fi

    disk=$(df -h | grep "/dev/sda3" | awk '{print $4}')

    #also takes a bit
    battery=$(acpi | sed "s|Battery \([0-9]\)|Bat|" | sed "s|:\d\d | |" | sed s/Discharging,/D/ | sed s/Charging,/C/ | sed s/Unknown,/U/ | sed s/Full,/F/ | tr "\n" ' ' | sed "s|^[^%]\+\?%|\0,|" | sed s/\:[0-9]*\ /\ /g | sed s/\ until\ charged// | sed s/\ remaining// | tr -d ',')

    date=$(date +'%a %b %d %H:%M')
  fi

  disk=$(df -h | grep "/dev/sda5" | awk '{print $4}')
  curr=$(echo -n $starter $volume $sep $wifi $sep $cpu $sep $disk $sep $battery $sep $date | tr -d '\n' && echo "")
  if [[ $curr != $prev ]]; then
    echo $curr
  fi
  prev=$curr
  sleep 0.1
done
#ps aux | awk {'sum+=$3;print sum'} | tail -n 1 | tr -d '\n' && echo -n "% CPU | "
