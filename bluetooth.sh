#!/bin/sh
# Tells irssi if you're away or not, based on being able to talk to a bluetooth
# device.
# You need http://labs.f0rked.com/irssi/socket-interface.pl to have been loaded
# by irssi, and you need http://labs.f0rked.com/rfd/irssi-cmd.pl to be in
# whatever you set BIN to be.
# The variables that you need to change should be obvious

AWAY_STRING=" not around"
AWAY="${AWAY_STRING}"
LAST=x
NAME="Magic Dave"
INTERVAL=200
BIN=/home/djm/bin/
IRSSI_CMD="${BIN}"irssi-cmd.pl
HCI_DEV=hci0
MAC="00:12:37:97:1C:7A"
HCI_CMD="/usr/bin/hcitool -i ${HCI_DEV} name ${MAC}"

while (true)
do
    if ${HCI_CMD} | grep "${NAME}" ; then
        AWAY=""; else AWAY="${AWAY_STRING}"
    fi

    if [[ ${AWAY} != ${LAST} ]] ; then
        ${IRSSI_CMD} "/away${AWAY}"
	LAST=${AWAY}
    fi

    sleep ${INTERVAL}
done

