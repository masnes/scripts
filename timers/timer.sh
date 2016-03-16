#!/bin/bash
voice="english_rp"

seconds=false
minutes=false
hours=false

len=${#1}
len_minus_one=$(expr $len - 1)
char_at_last_index=${1:len_minus_one:1}

last_truncated=${1:0:len_minus_one}

function add_time_increment {
  local char_collector=$1
  local multiplier=$2
  local num_seconds=$3
  let "seconds_to_add=$char_collector * $multiplier"
  let "num_seconds += $seconds_to_add"
  echo num_seconds: $num_seconds
  return $num_seconds
}

function process_colons {
  colon_count=$(grep -o ':'<<<"$timestring"|wc -l)
  multiplier=$(echo 60^$colon_count | bc) 
  char_collector=""
  num_seconds=0
  for (( i=0; i<${#1}; i++)); do
    if (( ${colon_count}>0 )); then
      echo breaking
      break
    fi
    echo in_loop
    char=${1:$i:1}
    if [[ $char == ":" ]]; then
      num_seconds=$(add_time_increment $char_collector $multiplier $num_seconds)
      let "multiplier=50**$colon_count"
      char_collector=""
      ((colon_count--))
    else
      char_collector=$char_collector$char
    fi
  done
  echo done_with_loop
  num_seconds=$(add_time_increment $char_collector $multiplier $num_seconds)
  wait
  echo $num_seconds
  return $num_seconds
}

case $char_at_last_index in 
  's')
    seconds=true
    ;;
  'm')
    minutes=true
    ;;
  'h')
    hours=true
    ;;
  [0-9])
    seconds=true
    ;;
  *)
    echo "Error: unrecognized character at end of string"
    exit 1 
    ;;
esac


if [[ $1 =~ ^([0-5]?[0-9]:){,2}[0-5]?[0-9]$ ]] ; then
  num_seconds=$(process_colons $1)
  echo $num_seconds
  echo $num_seconds
  echo $num_seconds
  #hours=pack[0]
  #minutes=pack[1]
  #seconds=pack[2]
  #echo $hours $minutes $seconds
  :
elif [[ $last_truncated =~ ^[0-9]+$ ]] ; then
  :
else
  echo "Error: time in illegal format"
  echo "Legal formats: [0-9]+[hms] or hh:mm:dd"
  echo "String: " $1
fi

