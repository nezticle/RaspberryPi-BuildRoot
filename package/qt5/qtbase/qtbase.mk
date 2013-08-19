QTBASE_VERSION = 5.1.0
QTBASE_SITE = http://download.qt-project.org/official_releases/qt/5.1/$(QTBASE_VERSION)/submodules/
QTBASE_SOURCE = qtbase-opensource-src-$(QTBASE_VERSION).tar.xz
QTBASE_DEPENDENCIES = host-pkgconf udev libglib2 zlib jpeg libpng tiff freetype dbus VideoCore openssl sqlite alsa-lib 
QTBASE_INSTALL_STAGING = YES

define QTBASE_CONFIGURE_CMDS

	-[ -f $(@D)/Makefile ] && $(MAKE) -C $(@D) confclean
	(cd $(@D) && MAKEFLAGS="$(MAKEFLAGS) -j$(PARALLEL_JOBS)" ./configure \
		-prefix /usr \
		-hostprefix $(HOST_DIR)/usr \
		-release \
		-device pi \
		-make libs \
		-make tools \
		-device-option CROSS_COMPILE=$(TARGET_CROSS) \
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
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5*.so.* $(TARGET_DIR)/usr/lib
	cp -dpfr $(STAGING_DIR)/usr/plugins $(TARGET_DIR)/usr
endef

define QTBASE_UNINSTALL_TARGET_CMDS
	-rm $(TARGET_DIR)/usr/lib/libQt*.so.*
endef

$(eval $(generic-package))
