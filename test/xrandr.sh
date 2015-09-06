#!/bin/bash
EXT="VGA1"
EXT2="HDMI1"
if [ $(xrandr | grep -c "$EXT connected") -gt 0 ] ; then
    echo $(xrandr | grep -c "$EXT connected")
    echo $(xrandr | grep "$EXT connected")
elif [ $(xrandr | grep -c "$EXT2 connected") -gt 0 ] ; then
    echo $(xrandr | grep -c "$EXT2 connected")
    echo $(xrandr | grep "$EXT2 connected")
fi
