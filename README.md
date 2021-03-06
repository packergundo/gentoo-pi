# Gentoo Pi

<!---
<script language="javascript">document.write("Just to let you know this site is active, this page was last updated on: " + document.lastModified +". I try to release images monthly. Current image is 06-09-2018");</script>
--->
_Updated image 01-01-2021, Perl, Python, and gcc changes_

There was an image update in July, but it appears I failed to upload it. I've been updating the binaries, though, including `nodejs`. I've been trying to work on an icedtea build for this distro to move away from OracleJDK, but that hasn't worked yet.

Okay...I now have a manual kernel update to download at the bottom of the page. Process to do this...download it. Move it to `/`. `sudo su -`...you _need_ to be root. `mount /boot` -- at this point I recommend making a backup of `/boot` just in case. Then `tar -xvzf <downloaded file>`. It will overwrite /boot, except for `cmdline.txt` and `config.txt` (you _did_ back it up, right?) and install the new modules files in `/lib/modules`. Reboot, and you should have the new kernel. You can delete the downloaded file, your backup, and then all the old kernel modules if you want.

<!---
The binaries are being maintained, just the base image is out of date. What this means is that an update will take longer at first. But everything _is_ being kept updated. The joy of Gentoo is that since it is versionless, all this means is that your initial upgrade will take a bit longer.
--->

I've played around with the Raspberry Pi for years, and use it in many different ways at home and at work. At home, I have a Pi as my GPS time server, as my music server, as an IRC server, a web server...I think you get the hint. But up until now, I've been running Raspbian as my OS. It was the recommended OS when I started, and I didn't want to deal with any growing pains.

However, my distro of choice is [Gentoo](http://www.gentoo.org). All my servers at home run Gentoo, regardless of how new or old they are. The control over what is installed, and the ability to upgrade in a versionless fashion is prized. So I've been split...Gentoo on the Intel boxes, and Raspbian on the Arm architecture...until now.

The process for the Raspberry Pi has been...unhelpful, to say the least. There has been allusions to images, but they are unmaintained. The NOOBS image that is out there is non-functional...the compiler doesn't work, and it requires a keyboard and monitor to get started. One of the benefits of Raspbian, IMO, is that it works out of the box **headless**. I can flash the card, fire it up, do an nmap scan, and login. The time is already set, and the system is functional. Setting it up from a Stage 3, though, requires a keyboard and monitor. No DHCP, there are some games I have to play to get a login and a shell working...so yeah...not a good way to begin, and I wanted to change that.

In my opinion, a working Gentoo base system needed to function the same way. It needed to be able to be flashed from a Windows system (using [Win32DiskImager](http://sourceforge.net/projects/win32diskimager/)), it needed to pick up an IP addresses using DHCP, it needed to set the time, **and** the work for crossdev and distributed compilation needed to already be done on the Pi. Also, in my opinion, vi and some basic very useful Gentoo tools needed to be installed.

So...that is what I have set out to do. I have a working Gentoo Pi image, as **well** as a working Gentoo Pi Stage 4\. The stage 4 contains all the software that is on the image, but works if you don't want to copy the image over yourself, but would rather untar it to an already built card.

ntp, cronie, syslog-ng, dhcpcd, vim, and various gentoo utilities are all installed, as well as distcc. The system is up to date with portage and current build flags, which were inserted for a minimal headless system. A stage 3 install does **not** have ntp, cron, syslog, or dhcp installed, all of which I wanted for a headless image.

visudo, vipw, vigr....vim is now the preferred system editor. Use `eselect editor` if you want to revert back to nano.

If you want to see what I installed: cat /var/lib/portage/world . Note that both images do have what was current at the time in /usr/portage -- why take the time to redownload it, especially with the tie it can take for a Pi. Since the image works best when you use my binary repo, /usr/portage contains what was used for the build on the date of the image.

pi user is in wheel, wheel can sudo without password. dhcpd will run on boot, as it is designed to run headless.

There is no root password. Login is pi:raspberry (both the same as Raspbian)

If you are using the Stage 4 a FAT boot partition, a swap partition, and an ext4 3rd partition is mandatory unless you want to edit /etc/fstab and /boot/cmdline.txt in the stage 4.

`mkfs.vfat -F 16 /dev/mmcblk0p1`

`mkswap /dev/mmcblk0p2`

`mkfs.ext4 -N 400000 /dev/mmcblk0p3 # it needs ~300000 inodes to install`

`mkdir gentoo`

`mount /dev/mmcblk0p3 gentoo`

`mkdir gentoo/boot`

`mount /dev/mmcblk0p1 gentoo/boot`

`cd gentoo`

`tar -xvjpf DownloadStage4Image`

umount the SD card, insert, and boot. At this point the instructions for Stage 4 and the image are very similar.

If you copied the image onto an sd card, `sudo fdisk /dev/mmcblk0`, delete the 3rd partition, and build it again with the entire file system. Reboot the Pi, and then run `sudo resize2fs /dev/mmcblk0p3`. You will now have your entire SD card available.

The latest image points to my build server, and these are the binaries that are available and maintaned. If there is a binary that you need and don't want to build, let me know and I will be glad to compile and add it to my list.

I've recently added sound support to the base image, since I'm now replacing the Raspian MPD server that I used to run with a Gentoo Pi MPD server. This means that nfs-utils are also in the repo, as well as mpg123.

The next thing on my todo list is to build a desktop system, both a base system, and one that supports amateur radio. So in the end, yes, there will be at *least* three variant systems.

On the base system...

<pre>app-admin/logrotate
app-admin/sshguard
app-admin/sudo
app-admin/syslog-ng
app-editors/nano
app-editors/vim
app-misc/screen
app-portage/eix
app-portage/epm
app-portage/g-cpan
app-portage/gentoolkit
app-portage/portage-utils
dev-python/pip
dev-vcs/git
mail-mta/ssmtp
media-sound/alsa-utils
net-misc/dhcpcd
net-misc/ntp
sys-devel/distcc
sys-process/cronie
</pre>

g-cpan and pip are on the base system for for Perl and Python. Note that there are both Go and Ruby binaries now available

And in the repo...

<pre>app-admin/ansible
app-admin/lastpass-cli
app-admin/restart-services
app-admin/whowatch
app-crypt/gnupg
app-editors/emacs
app-editors/joe
app-metrics/node_exporter
app-misc/mmv
app-misc/screenie
app-portage/genlop
app-portage/layman
app-portage/pfl
app-portage/repoman
app-portage/ufed
app-shells/tcsh
app-shells/zsh
dev-java/oracle-jdk-bin
dev-lang/go
dev-lang/php:5.6
dev-lang/php
dev-lang/ruby
app-portage/portage-utils
dev-python/pyusb
games-engines/frotz
games-misc/bsd-games
games-misc/cowsay
games-misc/fortune-mod-all
games-roguelike/nethack
mail-client/mailx
mail-client/mutt
mail-client/roundcube
mail-mta/postfix
media-sound/mpd
media-sound/mpg123
net-analyzer/hping
net-analyzer/iftop
net-analyzer/netcat
net-analyzer/nmap
net-analyzer/speedtest-cli
net-analyzer/tcping
net-analyzer/tcptraceroute
net-analyzer/traceroute
net-dns/bind
net-dns/bind-tools
net-fs/nfs-utils
net-im/pidgin
net-irc/irssi
net-irc/weechat
net-libs/nodejs
net-mail/dovecot
net-misc/knock
net-misc/oidentd
net-misc/unison
net-misc/whois
net-wireless/wpa_supplicant
sci-geosciences/gpsd
sys-apps/inxi
sys-apps/lshw
sys-apps/mlocate
sys-apps/usbutils
sys-auth/google-authenticator
sys-devel/bc
sys-devel/crossdev
sys-kernel/raspberrypi-sources
sys-process/at
sys-process/atop
sys-process/htop
sys-process/lsof
www-apache/anyterm
www-servers/lighttpd
</pre>

#### DOWNLOADS

[Current Gentoo Pi Image](http://www.gundo.com/gentoo-pi/gentoo-pi-2021-01-01.img.bz2) 01-01-2021

[Gentoo Pi Stage 4](http://www.gundo.com/gentoo-pi/stage4-gentoo-pi-2021-01-01.tar.bz2) 01-01-2021

    current compiler upgraded to gcc-9.3.0-r2
    default Python changed to 3.7.x
    Perl updated to 5.30.3
    Portage overhauled 3.0.12, eix updated
    most other packages updated
    kernel upgrade to 4.19.80

[4.19.80 kernel tarball](https://drive.google.com/file/d/1Etn-oEKjhxy1S4yN1JVpRi5xVl6oUua4/view?usp=sharing)

The Portage files that I use for this system (make.conf, package.use, package.mask, etc...) can be found [here](https://github.com/packergundo/gentoo-pi/blob/master/files/portage). If you want to keep your system current with my changes, download from here. I may set up a script to download and move these files...thoughts? I use Ansible for my home setup, but a simple Bash script would do.

The point of this image, as I've said, is to get you running asap as if it were a Raspian image. One caveat: if you want to compile yourself you'll need to make changes to /etc/portage/make.conf -- these are included and documented in the current [make.conf](https://github.com/packergundo/gentoo-pi/blob/master/files/portage/make.conf).

[Older Gentoo Pi Images and Stage4 files](http://www.gundo.com/gentoo-pi/old_images/)

[7-Zip](http://www.7-zip.org/) Needed to uncompress the image on Windows.

<!---
#<a href"https:="" wiki.gentoo.org="" wiki="" raspberry_pi="" cross_building"="">How to set up Intel servers for distributed cross-compilation</a>
--->
