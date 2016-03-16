#!/bin/bash

cat /usr/share/dict/cracklib-small | grep -e "^.\{3,7\}" | shuf --random-source=/dev/urandom | head -n 4 
