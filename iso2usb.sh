#!/bin/sh

# Dodgy code! (And untested)
# Don't blame me if it eats your dog and throws your PC out of the window
# Based on http://syslinux.zytor.com/wiki/index.php/FreeBSD_disk_image_creation
# Script for creating a bootable image on a usb stick, using an .iso file.
# Will fail if you have already created md0 and md1, but that's easy
# enough to fix...
# Creates a temporary image file then copies to stick - probably don't need
# to do this!

# Probably won't work if you aren't using a fbsd iso, unless you know how
# to do clever things that I don't...

# You much specify the following three parameters:

ISO=$1 # path to the iso file
DEV=$2 # path to the device (including /dev/)
SZ=$3 # size of the temporary image file - should be larger than the size of the iso (divided by 1000)

IMG=iso2usb_tmp.img
BS=1k

IMG_MNT=/tmp/img
ISO_MNT=/tmp/iso


dd if=/dev/zero of=$IMG bs=$BS count=$SZ
mdconfig -a -t vnode -f $IMG -u 0

bsdlabel -w -B md0 auto
newfs -m 0 md0a
mount /dev/md0a $IMG_MNT

mdconfig -a -t vnode -f $ISO -u 1
mount_cd9660 /dev/md1 $ISO_MNT

cd $IMG_MNT
cp -r $ISO_MNT/* .

cd $OLDPWD

umount $IMG_MNT $ISO_MNT
rmdir $IMG_MNT $ISO_MNT
mdconfig -d -u 0
mdconfig -d -u 1

dd if=$IMG of=$DEV bs=$BS

rm $IMG

