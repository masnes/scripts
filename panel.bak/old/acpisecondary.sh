#!/bin/bash

while :
do
  (echo -n "S%{S+}" && ps aux | awk {'sum+=$3;print sum'} | tail -n 1 | tr -d '\n' && echo -n "% CPU | " && acpi | tr -d ',' | sed s/Battery/Bat/ | sed s/Discharging/D/ | sed s/Charging/C/ | sed s/Unknown\ // | sed s/\ until\ charged// | sed s/\ remaining// && echo -n " | " && clock 'S%a %H:%M' ) | tr -d '\n' && echo "%{S}"
  sleep 5
done
