VIDEOCORE_VERSION = 2004eea0fc296634128482daf3de00f105d0c58b
VIDEOCORE_SITE = git://github.com/raspberrypi/userland.git
VIDEOCORE_SITE_METHOD = git
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
	echo /opt/vc/lib >> $(TARGET_DIR)/etc/ld.so.conf
endef

$(eval $(cmake-package))
