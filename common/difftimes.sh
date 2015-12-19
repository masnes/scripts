#!/bin/bash

usage() {
    scriptname=`echo $0 | xargs basename`
    echo "Usage: $scriptname diff 8:00pm [7:00pm]"
    echo "Usage: $scriptname add 3:00 [7:05pm] [+%H:%M]"
}

addTime() {
    if [[ $# -gt 1 ]]; then
        oldUTC=`date -u -d $2 +%H:%M`
    else
        oldUTC=`date -u +%H:%M`
    fi
    newUTC=`date -u -d "$oldUTC - $1" +%H:%M`
    date -d "$newUTC UTC" $3
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
