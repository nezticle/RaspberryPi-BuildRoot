QT3D_VERSION = 6b8ee028ac0daae74f5521b9e5562f94b5e8e169
QT3D_SITE = git://gitorious.org/qt/qt3d.git
QT3D_SITE_METHOD = git
QT3D_DEPENDENCIES = qtbase qtxmlpatterns qtjsbackend qtdeclarative
QT3D_INSTALL_STAGING = YES

define QT3D_CONFIGURE_CMDS
	-[ -f $(@D)/Makefile ] && $(MAKE) -C $(@D) distclean
	#run qmake
	(cd $(@D) && $(HOST_DIR)/usr/bin/qmake )
endef

define QT3D_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT3D_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) install
endef

define QT3D_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt3D*.so.* $(TARGET_DIR)/usr/lib
	cp -dpfr $(STAGING_DIR)/usr/imports/Qt3D $(TARGET_DIR)/usr/imports
endef

define QT3D_UNINSTALL_TARGET_CMDS
	-rm $(TARGET_DIR)/usr/lib/libQt3D*.so.*
	-rm -r $(TARGET_DIR)/usr/imports/Qt3D
endef

$(eval $(generic-package))
