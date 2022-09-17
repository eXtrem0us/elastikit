#!/bin/bash

for index in $(escurl /_cat/indices|awk '{print $3}'|egrep "$1"|sort|uniq)
do
    esdelete $index
done
