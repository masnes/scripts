#!/bin/bash

numargs=$#
args=("$@")

daybrightness=1.0
nightbrightness=0.4

if [[ $1 =~ ^[0-1]\.[0-9]+$ ]]; then
   nightbrightness=$1
fi

if [[ $2 =~ ^[0-1]\.[0-9]+$ ]]; then
   daybrightness=$2
fi


pkill -x redshift
redshift -l 40\.0\:-105\.3 -t 5700\:3300 -b $daybrightness:$nightbrightness &
