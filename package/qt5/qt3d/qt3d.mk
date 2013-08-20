QT3D_VERSION = 0158ce783a61bac3e4f4ff619b0601daf9174ce6
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
	cp -dpf $(@D)/lib/libQt53D*.so.* $(TARGET_DIR)/usr/lib
	cp -dpfr $(@D)/qml/Qt3D $(TARGET_DIR)/usr/qml
endef

define QT3D_UNINSTALL_TARGET_CMDS
	-rm $(TARGET_DIR)/usr/lib/libQt53D*.so.*
	-rm -r $(TARGET_DIR)/usr/qml/Qt3D
endef

$(eval $(generic-package))
