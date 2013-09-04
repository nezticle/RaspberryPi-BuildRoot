QTQUICK1_VERSION = 5.1.1
QTQUICK1_SITE = http://download.qt-project.org/official_releases/qt/5.1/$(QTQUICK1_VERSION)/submodules/
QTQUICK1_SOURCE = qtquick1-opensource-src-$(QTQUICK1_VERSION).tar.xz
QTQUICK1_DEPENDENCIES = qtbase qtxmlpatterns qtscript
QTQUICK1_INSTALL_STAGING = YES

define QTQUICK1_CONFIGURE_CMDS
	-[ -f $(@D)/Makefile ] && $(MAKE) -C $(@D) distclean
	#run qmake
	(cd $(@D) && $(HOST_DIR)/usr/bin/qmake )
endef

define QTQUICK1_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QTQUICK1_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) install
endef

define QTQUICK1_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5Declarative.so.* $(TARGET_DIR)/usr/lib
	cp -dpf $(STAGING_DIR)/usr/bin/qmlviewer $(TARGET_DIR)/usr/bin
	cp -dpf $(STAGING_DIR)/usr/bin/qml1plugindump $(TARGET_DIR)/usr/bin
	cp -dpfr $(STAGING_DIR)/usr/plugins/qml1tooling $(TARGET_DIR)/usr/plugins
	cp -dpfr $(STAGING_DIR)/usr/imports $(TARGET_DIR)/usr
endef

define QTQUICK1_UNINSTALL_TARGET_CMDS
	-rm $(TARGET_DIR)/usr/lib/libQt5Declarative.so.*
	-rm $(TARGET_DIR)/usr/plugins/qml1tooling/libqmldbg_inspector.so
	-rm $(TARGET_DIR)/usr/plugins/qml1tooling/libqmldbg_tcp_qtdeclarative.so
	-rm $(TARGET_DIR)/usr/bin/qmlviewer
	-rm $(TARGET_DIR)/usr/bin/qml1plugindump
	-rm -r $(TARGET_DIR)/usr/imports
endef

$(eval $(generic-package))
