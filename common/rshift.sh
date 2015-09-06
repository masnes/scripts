#!/bin/bash

numargs=$#
args=("$@")

daybrightness=1.0
nightbrightness=0.4

daytemp=5700
nighttemp=2200

if [[ $1 =~ ^[0-1]\.[0-9]+$ ]]; then
   nightbrightness=$1
fi

if [[ $2 =~ ^[0-1]\.[0-9]+$ ]]; then
   daybrightness=$2
fi


pkill -x redshift
if [[ numargs -gt 0 ]]; then
   redshift -l 40\.0\:-105\.3 -t $daytemp\:$nighttemp -b $daybrightness:$nightbrightness &
else
   redshift -l 40\.0\:-105\.3 -t $daytemp\:$nighttemp &
fi
