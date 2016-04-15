#!/bin/sh
NUM=$1
shift
mplayer dvd://$NUM -softvol -softvol-max 350 -framedrop -cache 16384 -vfm ffmpeg -lavdopts skiploopfilter=all -autosync 30 -alang en $@
