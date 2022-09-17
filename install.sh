#!/bin/bash

prefixdir=/usr/local/bin/

for tool in es-*.sh
do
    targettoolname=$(echo $tool | sed -E 's/(-|\.sh)//g')
    sudo ln -fs "$(realpath $tool)" "$prefixdir$targettoolname"
    echo installed $tool in "$prefixdir$targettoolname"
done
