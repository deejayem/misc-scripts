#!/bin/bash
HOME=/home/djm
MAIL=$HOME/Mail
#BEEP=/usr/bin/beep 2>/dev/null
#BEEP=echo -ne '\a'
while true ; do
COUNT=0
OLDNUM=0
MAILFILE=/tmp/newmail
for i in $MAIL/*/new/*
do
	[[ -e $i ]] && (( COUNT += 1 ))
done

#OLDNUM=$COUNT
##[[ $COUNT -eq 0 ]] && echo "No New Mail" >| $MAILFILE
##[[ $COUNT -eq 1 ]] && echo "1 New Mail" >| $MAILFILE
##[[ $COUNT -gt 1 ]] && echo "$COUNT New Mails" >| $MAILFILE
###[[ $COUNT -gt 0 ]] && [[ $OLDNUM = $COUNT ]] && $BEEP
#echo "Mail:$COUNT">|$MAILFILE
#echo "M:$COUNT">|$MAILFILE
echo "$COUNT">|$MAILFILE
sleep 10
done

