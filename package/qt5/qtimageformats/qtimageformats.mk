QTIMAGEFORMATS_VERSION = 5.1.1
QTIMAGEFORMATS_SITE = http://download.qt-project.org/official_releases/qt/5.1/$(QTIMAGEFORMATS_VERSION)/submodules/
QTIMAGEFORMATS_SOURCE = qtimageformats-opensource-src-$(QTIMAGEFORMATS_VERSION).tar.xz
QTIMAGEFORMATS_DEPENDENCIES = qtbase
QTIMAGEFORMATS_INSTALL_STAGING = YES

define QTIMAGEFORMATS_CONFIGURE_CMDS
	-[ -f $(@D)/Makefile ] && $(MAKE) -C $(@D) distclean
	#run qmake
	(cd $(@D) && $(HOST_DIR)/usr/bin/qmake )
endef

define QTIMAGEFORMATS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QTIMAGEFORMATS_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) install
endef

define QTIMAGEFORMATS_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/plugins/imageformats/*.so $(TARGET_DIR)/usr/plugins/imageformats/
endef

define QTIMAGEFORMATS_UNINSTALL_TARGET_CMDS
	-rm $(TARGET_DIR)/usr/plugins/imageformats/*
endef

$(eval $(generic-package))
