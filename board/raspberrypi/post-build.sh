TARGETDIR=$1
# Set root password to 'root'. Password generated with
# mkpasswd, from the 'whois' package in Debian/Ubuntu.
sed -i 's%^root::%root:8kfIfYHmcyQEE:%' $TARGETDIR/etc/shadow

# Generate boot config files
echo "dwc_otg.lpm_enable=0 console=ttyAMA0,115200 kgdboc=ttyAMA0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 rootwait" > $TARGETDIR/boot/cmdline.txt
echo "disable_overscan=1" > $TARGETDIR/boot/config.txt
echo "arm_freq=800" >> $TARGETDIR/boot/config.txt
echo "gpu_mem=128" >> $TARGETDIR/boot/config.txt

# Point /bin/sh to /bin/bash
ln -T -s /bin/bash $TARGETDIR/bin/sh 

# Package the /boot partition
tar -czf $TARGETDIR/../images/boot.tar.gz --exclude=Image -C $TARGETDIR/boot/ .

# add a corrected, and lightweight inittab
cp board/raspberrypi/inittab $TARGETDIR/etc/inittab

# add eth0 dhcp entry into /etc/network/interfaces
cp board/raspberrypi/interfaces $TARGETDIR/etc/network/

# make sure that ntpdate is run before sshd is started
cp board/raspberrypi/S41ntpdate $TARGETDIR/etc/init.d/
chmod a+x $TARGETDIR/etc/init.d/S41ntpdate
