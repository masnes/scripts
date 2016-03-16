#!/bin/bash

# quickly setup all keyboard options
# usefull when connecting a new keyboard
setxkbmap -option caps:none
xbindkeys -f ~/.xbindkeysrc
xmodmap ~/.xmodmap

# keycodes with problem
# l_alt 64
# l_start 133
