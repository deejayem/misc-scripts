#!/bin/sh

#MODE_LINE=`cvt 1440 900|sed 1d|cut -d' ' -f2-`
#xrandr --newmode ${MODE_LINE}

#xrandr --addmode VGA-0 1280x900_60.00

#xrandr --output VGA-0 --mode 1280x900_60.00

OUTPUT_NAME=$(xrandr|sed -n 2p|cut -f1 -d' ')
MODE_LINE=$(cvt 1616 929|sed 1d|cut -d' ' -f2-)
MODE_NAME=$(echo $MODE_LINE|sed 's/"\(.*\)".*/\1/')

xrandr --newmode "1616x929_60.00"  123.75  1616 1712 1880 2144  929 932 942 964 -hsync +vsync
#xrandr --newmode $MODE_LINE
xrandr --addmode VGA-0 1616x929_60.00
#xrandr --addmode $OUTPUT_NAME $MODE_NAME
xrandr --output VGA-0 --mode 1616x929_60.00
#xrandr --output $OUTPUT_NAME --mode $MODE_NAME

