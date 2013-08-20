#############################################################
#
# wiringPi
#
#############################################################

WIRINGPI_VERSION = 2.0
WIRINGPI_SOURCE = wiringPi-02a3bd8.tar.gz
#WIRINGPI_SOURCE = wiringPi-$(WIRINGPI_VERSION).tar.gz
WIRINGPI_SITE = https://git.drogon.net/?p=wiringPi;a=snapshot;h=02a3bd8d8f2ae5c873e63875a8faef5b627f9db6;sf=tgz
WIRINGPI_LICENSE = LGPLv3
WIRINGPI_LICENSE_FILES = COPYING
WIRINGPI_INSTALL_STAGING = YES
WIRINGPI_SITE_METHOD = wget
#WIRINGPI_CONFIG_SCRIPTS = wiringpi-config
#WIRINGPI_DEPENDENCIES = host-libaaa libbbb
TMP_BUILD = Build

# what steps should be performed to build the package
define WIRINGPI_BUILD_CMDS
	@echo "---------- Building libwiringPi ----------"
	$(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" -C $(@D)/wiringPi all
	mkdir -p $(@D)/$(TMP_BUILD)
	$(MAKE) DESTDIR="$(@D)/$(TMP_BUILD)" PREFIX="" -C $(@D)/wiringPi install
	@echo "---------- Building libwiringPiDev ----------"
	$(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" INCLUDE="-I$(@D)/$(TMP_BUILD)/include" -C $(@D)/devLib all
	$(MAKE) DESTDIR="$(@D)/$(TMP_BUILD)" PREFIX="" -C $(@D)/devLib install
	@echo "---------- Building wiringPi gpio utility ----------"
	$(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" INCLUDE="-I$(@D)/$(TMP_BUILD)/include" LDFLAGS="-L$(@D)/$(TMP_BUILD)/lib" $(LIBS) -C $(@D)/gpio all
	$(MAKE) DESTDIR="$(@D)/$(TMP_BUILD)" PREFIX="" -C $(@D)/gpio install
endef

# what steps should be performed to install the package in the staging space
define WIRINGPI_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0755 $(@D)/$(TMP_BUILD)/lib/libwiringPi*.so.* $(STAGING_DIR)/usr/lib
	$(INSTALL) -D -m 0644 $(@D)/$(TMP_BUILD)/include/*.h $(STAGING_DIR)/usr/include
	$(INSTALL) -D -m 0755 $(@D)/$(TMP_BUILD)/bin/gpio $(STAGING_DIR)/usr/bin
endef

# what steps should be performed to install the package in the target space
define WIRINGPI_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/$(TMP_BUILD)/lib/libwiringPi*.so.* $(TARGET_DIR)/usr/lib
	$(INSTALL) -D -m 0755 $(@D)/$(TMP_BUILD)/bin/gpio $(TARGET_DIR)/usr/bin
endef

define WIRINGPI_CLEAN_CMDS
	rm -rf  $(@D)/$(TMP_BUILD)
endef

# device-node file used by this package
define WIRINGPI_DEVICES
#	/dev/foo  c  666  0  0  42  0  -  -  -
endef

# permissions to set to specific files installed by this package
define WIRINGPI_PERMISSIONS
    usr/bin/gpio  f  4755  0  0  -  -  -  -  -
endef

# user that is used by this package (eg. to run a daemon as non-root) 
define WIRINGPI_USERS
#    foo -1 wiringpi -1 * - - - LibFoo daemon
endef

# generates, according to the variables defined previously, all the Makefile code necessary to make your package working
$(eval $(generic-package))
