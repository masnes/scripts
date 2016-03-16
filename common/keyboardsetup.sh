#!/bin/bash

# quickly setup all keyboard options
# usefull when connecting a new keyboard
setxkbmap -option caps:none
xbindkeys -f ~/.xbindkeysrc
xmodmap ~/.xmodmap
