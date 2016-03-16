#!/bin/bash

IN="LVDS1"
EXT="VGA1"
#PICTURE="$HOME/pictures/sol.jpg"
PICTURE="$HOME/pictures/sol.jpg"

if [ $(xrandr | grep -c "$EXT connected") ] ; then
  xrandr --output $EXT --auto --right-of $IN --primary
  feh --bg-scale $PICTURE
else
  xrandr --output $EXT --off --right-of $IN --primary
  xrandr --output $IN ---primary
  feh --bg-scale $PICTURE
fi
