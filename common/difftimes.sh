#!/bin/bash

usage() {
    scriptname=`echo $0 | xargs basename`
    echo "Usage: $scriptname diff 8:00pm [7:00pm]"
    echo "Usage: $scriptname add 3:00 [7:05]"
    echo "Usage: $scriptname sub 3:00 [7:05:13]"
}


# given a number in the format \d\d:\d\d:\d\d
# splite int hours, minutes, seconds
# echo $hours $minutes $seconds
_hours_minutes_seconds() {
    numFields=$(echo $1 | sed -s 's/[^:]//g' | wc -c | bc)
    if [[ $numFields -eq 0 ]]; then
        usage 1>&2
        exit
    fi
    hours=`echo $1   | cut -d ':' -f 1`
    if [[ $numFields -gt 1 ]]; then
        minutes=`echo $1 | cut -d ':' -f 3`
    else
        minutes=0
    fi
    if [[ $numFields -gt 2 ]]; then
        seconds=`echo $1 | cut -d ':' -f 2`
    else
        seconds=0
    fi
    echo $hours $minutes $seconds
}

_time_add_subtract() {
    if [[ $# -gt 2 ]]; then
        new_time=$2
        base_time=$1
        operator=$3
    elif [[ $# -gt 1 ]]; then
        new_time=$1
        base_time=`date "-d" "now" +%H:%M:%S`
        operator=$2
    else
        usage
        exit
    fi
    read base_hours base_minutes base_seconds <<<$(_hours_minutes_seconds $base_time)
    read new_hours new_minutes new_seconds <<<$(_hours_minutes_seconds $new_time)

    base_time=`date -d "12am + $base_hours hours $base_seconds seconds $base_minutes minutes"`

    #hours=$(($hours + $locale_offset_hour))
    diff=`date -d "$base_time $operator $new_hours hours"`
    diff=`date -d "$diff $operator $new_minutes minutes"`
    diff=`date -d "$diff $operator $new_seconds seconds"`
    echo `date -d "$diff"` #+%H:%M`
}

addTime() {
    _time_add_subtract $@ "+"
}

subtractTime() {
    _time_add_subtract $@ "-"
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
if   [[ $1 == "add"* ]]; then
    addTime "$2 $3"
elif [[ $1 == "sub"* ]]; then
    subtractTime $2 $3
elif [[ $1 == "diff"* ]]; then
    diffTimes $2 $3
else
    usage
    exit
fi
