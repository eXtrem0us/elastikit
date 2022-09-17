#!/bin/bash

echo -n "$1:::"
escurl "/$1" -XDELETE
echo
