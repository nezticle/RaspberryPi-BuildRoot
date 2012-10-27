XWIIMOTE_VERSION = 083a8fe
XWIIMOTE_SITE = http://bsquask.com/downloads/src
XWIIMOTE_SOURCE = xwiimote-$(XWIIMOTE_VERSION).tar.gz
XWIIMOTE_DEPENDENCIES = udev ncurses
XWIIMOTE_INSTALL_STAGING = YES

XWIIMOTE_AUTORECONF = YES

$(eval $(autotools-package))
