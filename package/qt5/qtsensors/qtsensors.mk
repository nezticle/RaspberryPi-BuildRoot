QTSENSORS_VERSION = 5.1.1
QTSENSORS_SITE = http://download.qt-project.org/official_releases/qt/5.1/$(QTSENSORS_VERSION)/submodules/
QTSENSORS_SOURCE = qtsensors-opensource-src-$(QTSENSORS_VERSION).tar.xz
QTSENSORS_DEPENDENCIES = qtbase qtdeclarative
QTSENSORS_INSTALL_STAGING = YES

define QTSENSORS_CONFIGURE_CMDS
	-[ -f $(@D)/Makefile ] && $(MAKE) -C $(@D) distclean
	#run qmake
	(cd $(@D) && $(TARGET_MAKE_ENV) qmake )
endef

define QTSENSORS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QTSENSORS_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) install
endef

define QTSENSORS_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5Sensors*.so.* $(TARGET_DIR)/usr/lib
	cp -dpfr $(STAGING_DIR)/usr/plugins/sensors $(TARGET_DIR)/usr/plugins
	cp -dpfr $(STAGING_DIR)/usr/plugins/sensorgestures $(TARGET_DIR)/usr/plugins
	cp -dpfr $(STAGING_DIR)/usr/qml/QtSensors $(TARGET_DIR)/usr/qml
endef

define QTSENSORS_UNINSTALL_TARGET_CMDS
	-rm $(TARGET_DIR)/usr/lib/libQt5Sensors*.so.*
	-rm -r $(TARGET_DIR)/usr/plugins/sensors
	-rm -r $(TARGET_DIR)/usr/plugins/sensorgestures
	-rm -r $(TARGET_DIR)/usr/qml/QtSensors
endef

$(eval $(generic-package))
