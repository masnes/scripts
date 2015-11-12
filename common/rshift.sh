#!/bin/bash

numargs=$#
args=("$@")


getopt --test > /dev/null
if [[ $? != 4 ]]; then
  echo "I’m sorry, `getopt --test` failed in this environment."
  exit 1
fi

daybrightness=1.0
nightbrightness=0.9

daytemp=5700
nighttemp=2200

while true; do
  case "$1" in
    -B|--day-brightness)
      daybrightness=$2
      shift
      ;;
    -b|--night-brightness)
      nightbrightness=$2
      shift
      ;;
    -T|--day-temp)
      daytemp=$2
      echo $daytemp
      shift
      ;;
    -t|--night-temp)
      nighttemp=$2
      shift
      ;;
    -h|--help)
      echo "Usage: (-B|--day-brightness) (-b|--night-brightness) (-T|--day-temp) (-t|--night-temp)"
      exit 0
      ;;
    '')
      break
      ;;
    *)
      echo "option not recognized: '${1}'";
      exit 1
      ;;
  esac
  shift
done

if [[ $1 =~ ^[0-1]\.[0-9]+$ ]]; then
   nightbrightness=$1
fi

if [[ $2 =~ ^[0-1]\.[0-9]+$ ]]; then
   daybrightness=$2
fi


pkill -x redshift
if [[ numargs -gt 0 ]]; then
  set -x
  redshift -l 40\.0\:-105\.3 -t $daytemp\:$nighttemp -b $daybrightness:$nightbrightness &
else
  set -x
   redshift -l 40\.0\:-105\.3 -t $daytemp\:$nighttemp &
fi
