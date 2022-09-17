#!/bin/bash

prefixdir=/usr/local/bin/

for tool in es-*.sh
do
    targettoolname=$(echo $tool | sed -E 's/(-|\.sh)//g')
    sudo rm "$prefixdir$targettoolname"
    echo removing $tool from "$prefixdir$targettoolname"
done
