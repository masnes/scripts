IN="eDP1"
EXT="DP1"
EXT2="DP2"

function add_output {
   output_name=$1
   xrandr --output $output_name --auto --right-of $IN --primary
 }

 function disable_output {
   to_disable=$1
   xrandr --output $to_disable --off --right-of $IN --primary
 }

if [ $(xrandr | grep -c "^$EXT connected") -gt 0 ] ; then
   echo "$EXT connected"
   add_output $EXT 
   disable_output $EXT2
elif [ $(xrandr | grep -c "^$EXT2 connected") -gt 0 ]; then
   echo "$EXT2 found"
   add_output $EXT2 
   disable_output $EXT
else
   echo "no external monitor found"
   disable_output $EXT
   disable_output $EXT2
 fi
