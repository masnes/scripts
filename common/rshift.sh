#!/bin/bash

numargs=$#
args=("$@")

nightbrightness=0.4

if [[ $1 =~ ^[0-1]\.[0-9]+$ ]]; then
   nightbrightness=$1
fi


pkill -x redshift
redshift -l 40\.0\:-105\.3 -t 5700\:3300 -b 1.0:$nightbrightness &
