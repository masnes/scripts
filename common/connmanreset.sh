#!/usr/bin/bash

connected_wifi=$(connmanctl services | egrep '^[*A]*[RO]\b')
wifi_id=$(echo $connected_wifi | egrep -o 'wifi_.*')

if [[ -z $connected_wifi ]]; then
  echo "No wifi connected, exiting"
  exit
fi

echo "Connected to:"
echo "$connected_wifi"

echo
echo "Resetting wifi connection"

connmanctl disconnect $wifi_id
connmanctl connect $wifi_id
echo "Done."
