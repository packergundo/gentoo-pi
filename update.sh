#!/bin/bash

BASEDIR=/home/pi/git/gentoo-pi
cd $BASEDIR
git pull

sudo cp $BASEDIR/files/portage/make.conf /etc/portage/make.conf
sudo cp $BASEDIR/files/portage/package.accept_keywords /etc/portage/package.accept_keywords/monolithic
sudo cp $BASEDIR/files/portage/package.mask /etc/portage/package.mask/monolithic
sudo cp $BASEDIR/files/portage/package.unmask /etc/portage/package.unmask/monolithic
sudo cp $BASEDIR/files/portage/package.use /etc/portage/package.use/monolithic
