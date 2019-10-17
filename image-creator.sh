#!/bin/bash

# the mkstage4.sh script is a slight modification of
# https://github.com/TheChymera/mkstage4
# I *do* include the current Portage directory in my image. Why 
# waste the time doing a full sync? You're going to do it anyway

# to use -- image-creator.sh <path to SD card>

DATE=$(date +%F)

IMAGE=gentoo-pi-$DATE.img
STAGE4=stage4-gentoo-pi-$DATE
BASEDIR=/home/gentoo-pi
#BOOT=$11
#GENTOO=$13

dd if=$1 bs=1M count=3600 of=$IMAGE

losetup -P /dev/loop0 $IMAGE
mount /dev/loop0p3 /mnt/gentoo
mount /dev/loop0p1 /mnt/gentoo/boot
rm -rf /mnt/gentoo/home/gundo
rm -rf /mnt/gentoo/usr/portage/packages/*
cp $BASEDIR/files/passwd /mnt/gentoo/etc/passwd
cp $BASEDIR/files/shadow /mnt/gentoo/etc/shadow
cp $BASEDIR/files/group /mnt/gentoo/etc/group
cp $BASEDIR/files/gshadow /mnt/gentoo/etc/gshadow
cp $BASEDIR/files/sudoers /mnt/gentoo/etc/sudoers
cp $BASEDIR/files/resolv.conf /mnt/gentoo/etc/resolv.conf
cp $BASEDIR/files/net /mnt/gentoo/etc/conf.d/net
rm /mnt/gentoo/etc/shadow-
rm /mnt/gentoo/etc/group-
rm /mnt/gentoo/etc/gshadow-
rm /mnt/gentoo/etc/passwd-

cd /mnt/gentoo
$BASEDIR/mkstage4.sh -q -l -t . $BASEDIR/$STAGE4
cd $BASEDIR
umount /mnt/gentoo/boot
umount /mnt/gentoo
losetup -D
