#!/bin/bash

while :
do
  # horribly complicated, but gets the job done
  (echo -n "S" && cat /proc/net/wireless | sed -n 3p | awk '{print "Wifi: " $3 "/70 | "}' | tr -d '.' && mpstat 2 1 | tail -n 2 | head -n 1 | awk '{printf "%5.2f", 100.0 - $13}' && echo -n "%% CPU | " && df -h | head -2 | tail -1 | awk '{print $4 " | "}' && acpi | sed s/Battery\ \0\:/Bat/ | sed s/Discharging,/D/ | sed s/Charging,/C/ | sed s/Unknown\ // | sed s/\ until\ charged// | sed s/\ remaining// | tr ',' '%' && echo -n " | " && date +'%a %b %d %H:%M' ) | tr -d '\n' && echo
  sleep 3
done
#ps aux | awk {'sum+=$3;print sum'} | tail -n 1 | tr -d '\n' && echo -n "% CPU | "
