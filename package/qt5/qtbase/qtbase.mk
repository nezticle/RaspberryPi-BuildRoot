QTBASE_VERSION = master
QTBASE_SITE = git://gitorious.org/qt/qtbase.git
QTBASE_SITE_METHOD = git
QTBASE_DEPENDENCIES = host-pkg-config libglib2 zlib jpeg libpng tiff freetype dbus openssl sqlite alsa-lib
QTBASE_INSTALL_STAGING = YES

define QTBASE_CONFIGURE_CMDS

	-[ -f $(@D)/Makefile ] && $(MAKE) -C $(@D) confclean
	(cd $(@D) && MAKEFLAGS="$(MAKEFLAGS) -j$(PARALLEL_JOBS)" ./configure \
		-prefix /usr \
		-hostprefix $(HOST_DIR)/usr \
		-release \
		-device pi \
		-make libs \
		-device-option CROSS_COMPILE=$(HOST_DIR)/usr/bin/arm-raspberrypi-linux-gnueabi- \
		-device-option DISTRO=bsquask \
		-sysroot $(STAGING_DIR) \
		-no-neon \
		-opensource \
		-confirm-license \
	)
endef

define QTBASE_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QTBASE_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) install
endef

define QTBASE_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt*.so.* $(TARGET_DIR)/usr/lib
	cp -dpfr $(STAGING_DIR)/usr/plugins $(TARGET_DIR)/usr
endef

define QTBASE_UNINSTALL_TARGET_CMDS
	-rm $(TARGET_DIR)/usr/lib/libQt*.so.*
endef

$(eval $(call GENTARGETS))