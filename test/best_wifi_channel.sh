#!/usr/bin/bash

connmanctl scan wifi
wifi_info=`iwlist wlp3s0 scan`

for i in `seq 1 11`; do 
    echo $wifi_info | grep -A 3 "Channel:$i" | grep Quality 
done

