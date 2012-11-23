QTWAYLAND_VERSION = 2246c0150c0f28a6ca9803ca2c454b2492030b8b
QTWAYLAND_SITE = git://gitorious.org/qt/qtwayland.git
QTWAYLAND_SITE_METHOD = git
QTWAYLAND_DEPENDENCIES = qtbase qtxmlpatterns qtjsbackend qtdeclarative wayland
QTWAYLAND_INSTALL_STAGING = YES

define QTWAYLAND_CONFIGURE_CMDS
	-[ -f $(@D)/Makefile ] && $(MAKE) -C $(@D) distclean
	#run qmake
	(cd $(@D) && $(HOST_DIR)/usr/bin/qmake )
endef

define QTWAYLAND_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QTWAYLAND_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) install
endef

define QTWAYLAND_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5Compositor*.so.* $(TARGET_DIR)/usr/lib
	cp -dpf $(STAGING_DIR)/usr/plugins/platforms/libqwayland.so $(TARGET_DIR)/usr/plugins/platforms/
endef

define QTWAYLAND_UNINSTALL_TARGET_CMDS
	-rm $(TARGET_DIR)/usr/lib/libQt5Compositor*.so.*
	-rm $(TARGET_DIR)/usr/plugins/platforms/libqwayland.so
endef

$(eval $(generic-package))
