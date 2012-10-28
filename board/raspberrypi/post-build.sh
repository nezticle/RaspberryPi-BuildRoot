TARGETDIR=$1
# Set root password to 'root'. Password generated with
# mkpasswd, from the 'whois' package in Debian/Ubuntu.
sed -i 's%^root::%root:8kfIfYHmcyQEE:%' $TARGETDIR/etc/shadow

# Point /bin/sh to /bin/bash
ln -T -s /bin/bash $TARGETDIR/bin/sh 

# Package the /boot partition
tar -czf $TARGETDIR/../images/boot.tar.gz --exclude=Image -C $TARGETDIR/boot/ .

# remove inittab
rm $TARGETDIR/etc/inittab

#remote rc.conf
rm $TARGETDIR/etc/init/rc.conf

#replace rc-sysinit.conf
cp board/raspberrypi/rc-sysinit.conf $TARGETDIR/etc/init/

#add task to start getty on tty1
cp board/raspberrypi/tty1.conf $TARGETDIR/etc/init/

# add eth0 dhcp entry into /etc/network/interfaces
cp board/raspberrypi/interfaces $TARGETDIR/etc/network/

# make sure that ntpdate is run before sshd is started
cp board/raspberrypi/S41ntpdate $TARGETDIR/etc/init.d/
chmod a+x $TARGETDIR/etc/init.d/S41ntpdate

# start bluetooth daemon
cp board/raspberrypi/S32bluetooth $TARGETDIR/etc/init.d/
chmod a+x $TARGETDIR/etc/init.d/S32bluetooth
