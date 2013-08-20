#VIDEOCORE_VERSION = 0e57896bbe98a0885506c3c09821d2c3c4465eef
VIDEOCORE_VERSION = ${BR2_PACKAGE_VIDEOCORE_VERSION}
VIDEOCORE_SITE = http://github.com/raspberrypi/userland/tarball/master
VIDEOCORE_DEPENDENCIES = udev
VIDEOCORE_INSTALL_STAGING = YES
VIDEOCORE_INSTALL_TARGET = YES
VIDEOCORE_CONF_OPT = -DCMAKE_BUILD_TYPE=Release
VIDEOCORE_POST_INSTALL_TARGET_HOOKS += VIDEOCORE_CLEANUP_TARGET_INSTALL

define VIDEOCORE_CLEANUP_TARGET_INSTALL
	# development files are installed to image which need to be removed
	rm -r $(TARGET_DIR)/opt/vc/include
	rm -r $(TARGET_DIR)/opt/vc/src
	rm $(TARGET_DIR)/opt/vc/lib/*.a
	# vcfile daemon needs to be renamed 
	#mv $(TARGET_DIR)/etc/init.d/vcfiled $(TARGET_DIR)/etc/init.d/S31vcfiled
	# remove vcfile daemon because it's not compatible (and not used)
	rm $(TARGET_DIR)/etc/init.d/vcfiled
	# add /opt/vc/lib to default library path
	if ! grep -q /opt/vc/lib $(TARGET_DIR)/etc/ld.so.conf; then \
		echo /opt/vc/lib >> $(TARGET_DIR)/etc/ld.so.conf ; \
		echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/opt/vc/lib" >> $(TARGET_DIR)/etc/profile ; \
	fi
endef

$(eval $(cmake-package))
