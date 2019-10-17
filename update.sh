#!/bin/bash

BASEDIR=/home/pi/git
cd $BASEDIR
git pull

cp $BASEDIR/files/portage/make.conf /etc/portage/make.conf
cp $BASEDIR/files/portage/package.accept_keywords /etc/portage/package.accept_keywords/monolithic
cp $BASEDIR/files/portage/package.mask /etc/portage/package.mask/monolithic
cp $BASEDIR/files/portage/package.unmask /etc/portage/package.unmask/monolithic
cp $BASEDIR/files/portage/package.use /etc/portage/package.use/monolithic
