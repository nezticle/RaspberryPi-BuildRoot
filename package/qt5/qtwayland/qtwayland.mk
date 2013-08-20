QTWAYLAND_VERSION = 11b0a7db584d21eb7eb94849de79ad033249ae3c
QTWAYLAND_SITE = git://gitorious.org/qt/qtwayland.git
QTWAYLAND_SITE_METHOD = git
QTWAYLAND_DEPENDENCIES = qtbase qtxmlpatterns qtjsbackend qtdeclarative wayland xkbcommon xkeyboard-config xproto_kbproto xproto_xproto
QTWAYLAND_INSTALL_STAGING = YES

define QTWAYLAND_CONFIGURE_CMDS
	-[ -f $(@D)/Makefile ] && $(MAKE) -C $(@D) distclean
	#A dirty hack to appease qmake (so it will run syncqt)
	touch $(@D)/.git
	#run qmake
	(cd $(@D) && $(HOST_DIR)/usr/bin/qmake -r CONFIG+=wayland-compositor )
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
	cp -dpfr $(STAGING_DIR)/usr/plugins/waylandcompositors $(TARGET_DIR)/usr/plugins/
endef

define QTWAYLAND_UNINSTALL_TARGET_CMDS
	-rm $(TARGET_DIR)/usr/lib/libQt5Compositor*.so.*
	-rm $(TARGET_DIR)/usr/plugins/platforms/libqwayland-brcm-egl.so
	-rm -r $(TARGET_DIR)/usr/plugins/waylandcompositors
endef

$(eval $(generic-package))
