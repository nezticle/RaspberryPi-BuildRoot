UPSTART_VERSION = 1.6.1
UPSTART_SITE = http://upstart.ubuntu.com/download/$(UPSTART_VERSION)
UPSTART_SOURCE = upstart-$(UPSTART_VERSION).tar.gz
UPSTART_INSTALL_STAGING = YES
UPSTART_DEPENDENCIES = udev dbus libnih json-c

UPSTART_AUTORECONF = YES

UPSTART_CONF_OPT += --exec-prefix=/

$(eval $(autotools-package))
