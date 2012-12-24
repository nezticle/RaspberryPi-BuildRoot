UPSTART_VERSION = 1.6.1
UPSTART_SITE = http://upstart.ubuntu.com/download/$(UPSTART_VERSION)
UPSTART_SOURCE = upstart-$(UPSTART_VERSION).tar.gz
UPSTART_INSTALL_STAGING = YES
UPSTART_DEPENDENCIES = udev dbus libnih json-c
UPSTART_POST_INSTALL_TARGET_HOOKS += UPSTART_REPLACE_INITSCRIPTS

UPSTART_AUTORECONF = YES

UPSTART_CONF_OPT += --exec-prefix=/

define UPSTART_REPLACE_INITSCRIPTS
	#replace sysinitv scripts with upstart ones
	rm -f $(TARGET_DIR)/etc/init.d/S20urandom
	rm -f $(TARGET_DIR)/etc/init.d/S40network
	$(INSTALL) -m 0644 package/upstart/urandom.conf \
		$(TARGET_DIR)/etc/init
	$(INSTALL) -m 0644 package/upstart/network.conf \
		$(TARGET_DIR)/etc/init
endef

$(eval $(autotools-package))
