#!/bin/bash
ALBUMS=$(mpc listall -f %artist%:::%album%|uniq|grep -v '^:::$')
COUNT=$(wc -l <<< $ALBUMS)
sed -n $((1 + $RANDOM % $COUNT))p <<< $ALBUMS

