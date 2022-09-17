#!/bin/bash

baseaddr="$(realpath $0)"
basepath="$(dirname $baseaddr)"
confdir="$basepath/conf"
source "$confdir/es.env"

curl "$eshost""$@" -sku "$esauth"
