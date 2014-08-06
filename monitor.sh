#!/bin/bash

IN="LVDS1"
EXT="VGA1"

if [ $(xrandr | grep -c "$EXT connected") ] ; then
  xrandr --output $EXT --auto --right-of $IN --primary
  feh --bg-scale ~/pictures/yosemite_california.jpg
else
  xrandr --output $EXT --off --right-of $IN --primary
  xrandr --output $IN ---primary
  feh --bg-scale ~/pictures/yosemite_california.jpg
fi
