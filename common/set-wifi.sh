#!/bin/bash
#set -x
echo 

connman_output=`connmanctl services`
stripped_output=`printf "$connman_output" | cut -c 5-`
wifi_names=""
while IFS= read line; do
  if [ "${line:0:1}" != ' ' ]; then
    wifi_names+=`echo "$line" | awk '{ print $1 }'`
    wifi_names+="\n"
  fi
done <<< "$stripped_output"

echo "$wifi_names"
