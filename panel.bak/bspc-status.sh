#!/bin/bash

while : 
do
  echo -n "w%{S+}"
  bspc control --get-status | tr -d '\n'
  echo "w%{S}"
  sleep 0.5
done
