#!/bin/bash

# This program is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it # and/or modify it under the terms of the Do What The Fuck You Want
# To Public License, Version 2, as published by Sam Hocevar. See
# http://sam.zoy.org/wtfpl/COPYING for more details.

# list all types
# for coltype in {0..8} ; do # bold italic etc
#   for fgbg in 38 48 ; do #Foreground/Background
#     for color in {0..256} ; do #Colors
#       #Display the color
#       echo -en "\e[(0${coltype});(${fgbg};5;${color}m ${color}\t\e[0m"
#       #Display 10 colors per lines
#       if [ $((($color + 1) % 10)) == 0 ] ; then
#         echo #New line
#       fi
#     done
#     echo #New line
#     echo #New line
#   done
#   echo #New line
# done
# 
# exit 0

# list 256 colors and compare them against color of choice
COMPAREME=12
TYPE=1
for fgbg in 38 48 ; do #Foreground/Background
  for color in {0..256} ; do #Colors
    #Display the color
    echo -en "\e[(${TYPE});${fgbg};5;${COMPAREME}m${COMPAREME}\e[0m\e[(${fgbg};5;${color}m ${color}\t\e[0m"
    #Display 10 colors per lines
    if [ $((($color + 1) % 10)) == 0 ] ; then
      echo #New line
    fi
  done
  echo #New line
done

exit 0
