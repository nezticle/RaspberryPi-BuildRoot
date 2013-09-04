QTQUICKCONTROLS_VERSION = 5.1.1
QTQUICKCONTROLS_SITE = http://download.qt-project.org/official_releases/qt/5.1/$(QTQUICKCONTROLS_VERSION)/submodules/
QTQUICKCONTROLS_SOURCE = qtquickcontrols-opensource-src-$(QTQUICKCONTROLS_VERSION).tar.xz
QTQUICKCONTROLS_DEPENDENCIES = qtdeclarative
QTQUICKCONTROLS_INSTALL_STAGING = YES

define QTQUICKCONTROLS_CONFIGURE_CMDS
	-[ -f $(@D)/Makefile ] && $(MAKE) -C $(@D) distclean
	#run qmake
	(cd $(@D) && $(TARGET_MAKE_ENV) qmake )
endef

define QTQUICKCONTROLS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QTQUICKCONTROLS_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) install
endef

define QTQUICKCONTROLS_INSTALL_TARGET_CMDS
	cp -dpfr $(STAGING_DIR)/usr/qml/QtQuick/Controls $(TARGET_DIR)/usr/qml/QtQuick
endef

define QTQUICKCONTROLS_UNINSTALL_TARGET_CMDS
	-rm -r $(TARGET_DIR)/usr/qml/QtQuick/Controls
endef

$(eval $(generic-package))
