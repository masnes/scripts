#!/bin/bash

eval $(ssh-agent)

for key in `ls ~/.ssh`; do
    if [[ ${key:0:2} == "id" && ${key:(-3)} != "pub" ]]; then
        ssh-add ~/.ssh/$key
    fi
done
