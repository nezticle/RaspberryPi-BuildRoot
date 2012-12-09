QTGRAPHICALEFFECTS_VERSION = 5.0.0-rc1
QTGRAPHICALEFFECTS_SITE = http://releases.qt-project.org/qt5.0/rc1/submodules_tar
QTGRAPHICALEFFECTS_SOURCE = qtgraphicaleffects-opensource-src-$(QTGRAPHICALEFFECTS_VERSION).tar.gz
QTGRAPHICALEFFECTS_DEPENDENCIES = qtdeclarative
QTGRAPHICALEFFECTS_INSTALL_STAGING = YES

define QTGRAPHICALEFFECTS_CONFIGURE_CMDS
	-[ -f $(@D)/Makefile ] && $(MAKE) -C $(@D) distclean
	#run qmake
	(cd $(@D) && $(HOST_DIR)/usr/bin/qmake )
endef

define QTGRAPHICALEFFECTS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QTGRAPHICALEFFECTS_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) install
endef

define QTGRAPHICALEFFECTS_INSTALL_TARGET_CMDS
	cp -dpfr $(STAGING_DIR)/usr/qml/QtGraphicalEffects $(TARGET_DIR)/usr/qml
endef

define QTGRAPHICALEFFECTS_UNINSTALL_TARGET_CMDS
	-rm -r $(TARGET_DIR)/usr/qml/QtGraphicalEffects
endef

$(eval $(generic-package))
