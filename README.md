# RaspberryPi-Buildroot (aka the Bsquask SDK) #

The objective of this project is to provide an SDK and root file system for the Raspberry Pi that is lightweight and takes full advantage of the hardware available.  The resulting image produced is small distro known as Bsquask (linux).

The Bsquask SDK provides a GCC 4.6.3 toolchain for building armv6 binaries with the hardfloat ABI, as well as bootloaders, kernel image, rootfs, and development sysroot for the Raspberry Pi.

## Getting and building the Bsquask SDK ##

Clone the RaspberryPi-BuildRoot project into your local code directory:  
`cd ~/Code/`  
`git clone git@github.com:nezticle/RaspberryPi-BuildRoot.git BuildRoot`

Create the directory where you want your SDK to be built:  
`export BSQUASK_DIR=/opt/bsquask`  
`mkdir -p $BSQUASK_DIR`  

Enter the BuildRoot directory and generate a Makefile for your SDK:  
`cd BuildRoot`  
`make raspberrypi_defconfig O=$BSQUASK_DIR`  
You may be missing some build dependancies (flex, bison, etc...) but you will be warned about what packages you need to install if this is the case.

Change to your SDK directory and and start the build (this can take a few hours the first time).  
`cd $BSQUASK_DIR`  
`make`  
*Do not use the -j option with this Makefile!  The number of make jobs is specified by the BuildRoot configuration, and overriding this with the -j flag here breaks the build system.  If you want to change the number of build jobs run:*  
`sed 's/BR2_JLEVEL=5/BR2_JLEVEL=N/' .config > .tmp_config; mv .tmp_config .config`  
*replacing the N with the number of build jobs, then run make as above*  

## Using Generated Image on the Raspberry Pi ##

First you need to obtain an SD card that has the correct partitions setup.  It needs to be setup as follows:  
- 75MB fat32 partition
- 500MB or greater ext4 partition (ideally using the remainder of the card)

If you need help with this, the Raspberry Pi wiki has a [guide](http://elinux.org/RPi_Advanced_Setup#Advanced_SD_card_setup) that's pretty close (make sure to use ext4 instead of ext3).

When you have this setup, mount the the two partitions (assuming /media/BOOT for the fat32 partiion, and /media/rootfs for the ext4).  The run the following commands to install the rootfs:  
`cd $BSQUASK_DIR/images`  
`tar -zxvf boot.tar.gz -C /media/BOOT`  
`sudo tar -zxvf rootfs.tar.gz -C /media/rootfs`  
*Make sure you are root(sudo) when extracting rootfs.tar.gz, or you will have problems on boot*

Now place the SD card in your Raspberry Pi and power on.  If everything went as planned, you should get a login prompt for Bsquask (linux).  
Easy right?

## Basics of Using the SDK ##
Lets set a few more environment variables to make things easier:  
`export BSQUASK_HOST_DIR=$BSQUASK_DIR/host`  
`export BSQUASK_STAGING_DIR=$BSQUASK_DIR/staging`  
`export BSQUASK_TARGET_DIR=$BSQUASK_DIR/target`  

`$BSQUASK_HOST_DIR` is the directory containing the native built tools for your machine like your cross compiler.  If you want to make use these tools then you will want to add these them to your path:  
`export PATH=$BSQUASK_HOST_DIR/usr/bin:$PATH`  

`$BSQUASK_STAGING_DIR` is the location of your sysroot.  This is where you install everything that you've built for your device, including development headers and debug symbols.

`$BSQUASK_TARGET_DIR` is the location you use to build images.  This is what you are deploying to your device, so only things you want to be in your images (like stripped binaries). 

## Note: ##
Right now the default setup downloads an external toolchain that only works with x86_64 systems.  It is also possible to change the configuration to build your own compatible toolchain, but for this you should consult the BuildRoot documentation.

### Login information:  
username: root   
password: root   

### The Bsquask SDK is based on BuildRoot 2012.05 ###
