#!/bin/bash

BASEDIR=/home/pi/git/gentoo-pi

echo "updating Portage repo"
sudo /usr/bin/eix-sync

echo "updating git repo"
cd $BASEDIR
cd /home/pi/git/gentoo-pi
git pull

echo "Moving files over to /etc/portage"
cd /home/pi/git/gentoo-pi/files/portage
sudo cp $BASEDIR/files/portage/make.conf /etc/portage/make.conf
sudo cp $BASEDIR/files/portage/package.accept_keywords /etc/portage/package.accept_keywords/monolithic
sudo cp $BASEDIR/files/portage/package.mask /etc/portage/package.mask/monolithic
sudo cp $BASEDIR/files/portage/package.unmask /etc/portage/package.unmask/monolithic
sudo cp $BASEDIR/files/portage/package.use /etc/portage/package.use/monolithic

echo "updating the system"
sudo emerge -auDN world
