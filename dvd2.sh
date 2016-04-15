#!/bin/sh
NUM=$1
shift
/home/djm/bin/dvd.sh $NUM -slang en -osdlevel 3 $@
