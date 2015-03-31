#!/bin/bash
# note: Configured for bspwm usage

IN="LVDS1"
EXT="VGA1"
EXT2="HDMI1"

# bspwm automatically adds a new desktop, Desktop#, each time
# a monitor is recognized by it (that way there's a desktop for
# that monitor no matter what). However, we're re-shuffling
# desktops, and the name Desktop# is ugly
function remove_autogened_desktops {
   for desktop_name in $(bspc query -D | grep Desktop); do
      bspc desktop $desktop_name -r
   done
}

function setup_new_monitor {
   output_name=$1
   # add vga monitor
   xrandr --output $output_name --auto --right-of $IN --primary
   # add background for new monitor
   feh --bg-scale ~/pictures/yosemite_california.jpg
   # move desktops to new monitor
   bspc desktop V -m $output_name; \
      bspc desktop VI -m $output_name; \
      bspc desktop VII -m $output_name; \
      bspc desktop VIII -m $output_name; \
      bspc desktop IX -m $output_name
}

if [ $(xrandr | grep -c "$EXT connected") -gt 0 ] ; then
   echo "$EXT connected"
   echo $(xrandr | grep -c "$EXT connected")
   setup_new_monitor $EXT
   # remove default "Desktop#" workspace(s)
   remove_autogened_desktops
   # restart panel
   pkill -USR1 -x sxhkd; pkill -USR1 -x panel; $HOME/.scripts/panel/panel &
elif [ $(xrandr | grep -c "$EXT2 connected") -gt 0 ]; then
   echo "$EXT2 found"
   setup_new_monitor $EXT2
   # remove default "Desktop#" workspace(s)
   remove_autogened_desktops
   # restart panel
   pkill -USR1 -x sxhkd; pkill -USR1 -x panel; $HOME/.scripts/panel/panel &
else
   echo "no external monitor found"
   xrandr --output $EXT --off --right-of $IN --primary
   xrandr --output $IN --primary
   feh --bg-scale ~/pictures/yosemite_california.jpg
fi


