#!/bin/bash
# note: Configured for bspwm usage

IN="LVDS1"
EXT="VGA1"

if [ $(xrandr | grep -c "$EXT connected") ] ; then
   # add vga monitor
   xrandr --output $EXT --auto --right-of $IN --primary
   # add background for new monitor
   feh --bg-scale ~/pictures/yosemite_california.jpg
   # move desktops to new monitor
   bspc desktop V -m VGA1; \
      bspc desktop VI -m VGA1; \
      bspc desktop VII -m VGA1; \
      bspc desktop VIII -m VGA1; \
      bspc desktop IX -m VGA1
   # remove default "Desktop#" workspace(s)
   bspc desktop Desktop2 -r
   bspc desktop Desktop3 -r
   bspc desktop Desktop4 -r
   # restart panel
   pkill -USR1 -x sxhkd; pkill -USR1 -x panel; $HOME/.scripts/panel/panel &
else
   xrandr --output $EXT --off --right-of $IN --primary
   xrandr --output $IN ---primary
   feh --bg-scale ~/pictures/yosemite_california.jpg
fi
