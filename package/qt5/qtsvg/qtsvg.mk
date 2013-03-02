QTSVG_VERSION = 5.0.1
QTSVG_SITE = http://releases.qt-project.org/qt5/$(QTSVG_VERSION)/submodules_tar
QTSVG_SOURCE = qtsvg-opensource-src-$(QTSVG_VERSION).tar.xz
QTSVG_DEPENDENCIES = qtbase
QTSVG_INSTALL_STAGING = YES

define QTSVG_CONFIGURE_CMDS
	-[ -f $(@D)/Makefile ] && $(MAKE) -C $(@D) distclean
	#run qmake
	(cd $(@D) && $(HOST_DIR)/usr/bin/qmake )
endef

define QTSVG_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QTSVG_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) install
endef

define QTSVG_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5Svg*.so.* $(TARGET_DIR)/usr/lib
	cp -dpfr $(STAGING_DIR)/usr/plugins/iconengines $(TARGET_DIR)/usr/plugins
	cp -dpf $(STAGING_DIR)/usr/plugins/imageformats/libqsvg.so $(TARGET_DIR)/usr/plugins/imageformats/
endef

define QTSVG_UNINSTALL_TARGET_CMDS
	-rm $(TARGET_DIR)/usr/lib/libQt5Svg*.so.*
	-rm $(TARGET_DIR)/usr/plugins/iconengines/libqsvgicon.so
	-rm $(TARGET_DIR)/usr/plugins/imageformats/libqsvg.so
endef

$(eval $(generic-package))
