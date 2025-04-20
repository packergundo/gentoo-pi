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

echo "dding .img file from SD card..."
#dd if=$1 bs=1M count=4000 of=$IMAGE
dd if=$1 bs=1M count=8000 iflag=fullblock of=$IMAGE status=progress

echo "Mounting image..."
losetup -P /dev/loop0 $IMAGE
mount /dev/loop0p3 /mnt/gentoo
mount /dev/loop0p1 /mnt/gentoo/boot
echo "Removing unnecessary stuff..."
rm -rf /mnt/gentoo/home/gundo
rm -rf /mnt/gentoo/root/*
rm -rf /mnt/gentoo/home/pi/.bash_history
rm -rf /mnt/gentoo/home/pi/.lesshst
rm -rf /mnt/gentoo/home/pi/.viminfo
rm -rf /mnt/gentoo/usr/portage/packages/*
rm -rf /mnt/gentoo/var/log/*.gz
rm -rf /mnt/gentoo/var/log/portage/*
rm /mnt/gentoo/etc/ssh/ssh_host_*
echo "Overwriting stuff..."
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

echo "Creating stage4..."
cd /mnt/gentoo
$BASEDIR/mkstage4.sh -q -l -t . $BASEDIR/$STAGE4
cd $BASEDIR
echo "Unmounting image..."
umount /mnt/gentoo/boot
umount /mnt/gentoo
losetup -D
echo "Done!!!"

