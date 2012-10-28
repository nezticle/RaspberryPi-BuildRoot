UPSTART_VERSION = 1.5
UPSTART_SITE = http://upstart.ubuntu.com/download/$(UPSTART_VERSION)
UPSTART_SOURCE = upstart-$(UPSTART_VERSION).tar.gz
UPSTART_INSTALL_STAGING = YES
UPSTART_DEPENDENCIES = udev dbus libnih

UPSTART_AUTORECONF = YES

UPSTART_CONF_OPT += --exec-prefix=/

$(eval $(autotools-package))
