#!/bin/bash

usage() {
    scriptname=`echo $0 | xargs basename`
    echo "Usage: $scriptname diff 8:00pm [7:00pm]"
    echo "Usage: $scriptname add 3:00 [7:05pm] [+%H:%M]"
}

addTime() {
    if [[ $# -gt 1 ]]; then
        time=$2
    else
        time="now"
    fi
    numFields=$(echo $1 | sed -s 's/[^:]//g' | wc -c | bc)
    hours=`echo $1 | cut -d ':' -f 1`
    echo hours $hours
    minutes=0
    seconds=0
    if [[ $numFields -gt 1 ]]; then
        minutes=`echo $1 | cut -d ':' -f 2`
        echo minutes $minutes
    fi
    if [[ $numFields -gt 2 ]]; then
        seconds=`echo $1 | cut -d ':' -f 3`
        echo seconds $seconds
    fi
    date -d "$time + $hours hours $minutes minutes $seconds seconds" $3
}

diffTimes() {
    now=`date`
    nowUTC=`date -u -d "$now"`
    earlierTime=`date -u -d "$nowUTC"`
    if [[ $# -gt 1 ]]; then
        earlierTime=`date -d "$2"`
    fi
    earlierTimeUTC=`date -u -d "$earlierTime"`
    laterTime=`date -d "$1"`
    laterTimeUTC=`date -u -d "$laterTime"`

    earlierTimeUTCSeconds=`date -u -d "$earlierTimeUTC" +%s`
    laterTimeUTCSeconds=`date -u -d "$laterTimeUTC" +%s`

    if [[ $laterTimeUTCSeconds -lt $earlierTimeUTCSeconds ]]; then
        temp=$laterTimeUTCSeconds
        laterTimeUTCSeconds=$earlierTimeUTCSeconds
        earlierTimeUTCSeconds=$temp
    fi
    diff=$(( $laterTimeUTCSeconds - $earlierTimeUTCSeconds ))
    date -u -d "@$diff" +%H:%M
}

if   [[ $# -lt 2 ]]; then
    usage
    exit
fi
if   [[ $1 == "add" ]]; then
    addTime "$2 $3"
elif [[ $1 == "diff" ]]; then
    diffTimes $2 $3
else
    usage
    exit
fi
