#!/bin/sh
sudo mdconfig -a -t vnode -f "${1}" -u 0
sudo mount -t cd9660 /dev/md0 /cdrom
