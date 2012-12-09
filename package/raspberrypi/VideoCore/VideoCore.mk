VIDEOCORE_VERSION = 7beaaff
VIDEOCORE_SITE = http://bsquask.com/downloads/firmware
VIDEOCORE_SOURCE = raspberrypi-firmware-$(VIDEOCORE_VERSION).tar.gz
VIDEOCORE_INSTALL_STAGING = YES
VIDEOCORE_INSTALL_TARGET = YES

define VIDEOCORE_INSTALL_STAGING_CMDS
	cp -r $(@D)/hardfp/opt $(STAGING_DIR)/
endef

define VIDEOCORE_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/opt/vc
	cp -r $(@D)/hardfp/opt/vc/bin $(TARGET_DIR)/opt/vc
	cp -r $(@D)/hardfp/opt/vc/lib $(TARGET_DIR)/opt/vc
	cp -r $(@D)/hardfp/opt/vc/sbin $(TARGET_DIR)/opt/vc
	# add /opt/vc/lib to default library path
	echo /opt/vc/lib >> $(TARGET_DIR)/etc/ld.so.conf
	# add symlink for compatibility
	ln -T -s ld-linux.so.3 $(TARGET_DIR)/lib/ld-linux-armhf.so.3
endef

$(eval $(generic-package))
