#!/bin/bash

# the mkstage4.sh script is a slight modification of
# https://github.com/TheChymera/mkstage4
# I *do* include the current Portage directory in my image. Why 
# waste the time doing a full sync? You're going to do it anyway

DATE=$(date +%F)

IMAGE=gentoo-pi-$DATE.img
STAGE4=stage4-gentoo-pi-$DATE
#BOOT=$11
#GENTOO=$13

dd if=$1 bs=1M count=3600 of=$IMAGE

losetup -P /dev/loop0 $IMAGE
mount /dev/loop0p3 /mnt/gentoo
mount /dev/loop0p1 /mnt/gentoo/boot
rm -rf /mnt/gentoo/home/gundo
rm -rf /mnt/gentoo/usr/portage/packages/*
cp /root/gentoopi_files/passwd /mnt/gentoo/etc/passwd
cp /root/gentoopi_files/shadow /mnt/gentoo/etc/shadow
cp /root/gentoopi_files/group /mnt/gentoo/etc/group
cp /root/gentoopi_files/gshadow /mnt/gentoo/etc/gshadow
cp /root/gentoopi_files/sudoers /mnt/gentoo/etc/sudoers
cp /root/gentoopi_files/resolv.conf /mnt/gentoo/etc/resolv.conf
cp /root/gentoopi_files/net /mnt/gentoo/etc/conf.d/net
rm /mnt/gentoo/etc/shadow-
rm /mnt/gentoo/etc/group-
rm /mnt/gentoo/etc/gshadow-
rm /mnt/gentoo/etc/passwd-

cd /mnt/gentoo
/root/mkstage4.sh -q -l -t . /root/$STAGE4
cd /root
umount /mnt/gentoo/boot
umount /mnt/gentoo
losetup -D
