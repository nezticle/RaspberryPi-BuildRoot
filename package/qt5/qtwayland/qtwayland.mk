QTWAYLAND_VERSION = 87a7fb0ae767d178f63f1b433c9c10628edf28ee
QTWAYLAND_SITE = git://gitorious.org/qt/qtwayland.git
QTWAYLAND_SITE_METHOD = git
QTWAYLAND_DEPENDENCIES = qtbase qtxmlpatterns qtjsbackend qtdeclarative wayland xkbcommon xkeyboard-config xproto_kbproto xproto_xproto
QTWAYLAND_INSTALL_STAGING = YES

define QTWAYLAND_CONFIGURE_CMDS
	-[ -f $(@D)/Makefile ] && $(MAKE) -C $(@D) distclean
	#run qmake
	(cd $(@D) && $(TARGET_MAKE_ENV) $(HOST_DIR)/usr/bin/qmake -r CONFIG+=wayland-compositor )
endef

define QTWAYLAND_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QTWAYLAND_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) install
endef

define QTWAYLAND_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5Compositor*.so.* $(TARGET_DIR)/usr/lib
	cp -dpf $(STAGING_DIR)/usr/plugins/platforms/libqwayland-brcm-egl.so $(TARGET_DIR)/usr/plugins/platforms/
	cp -dpf $(STAGING_DIR)/usr/plugins/waylandcompositors/libbrcm-egl.so $(TARGET_DIR)/usr/plugins/waylandcompositors/
endef

define QTWAYLAND_UNINSTALL_TARGET_CMDS
	-rm $(TARGET_DIR)/usr/lib/libQt5Compositor*.so.*
	-rm $(TARGET_DIR)/usr/plugins/platforms/libqwayland-brcm-egl.so
	-rm $(TARGET_DIR)/usr/plugins/waylandcompositors/libbrcm-egl.so
endef

$(eval $(generic-package))
